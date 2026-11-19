package com.petcare.services;

import com.petcare.daos.AppointmentDAO;
import com.petcare.daos.ComboDAO;
import com.petcare.daos.PetDAO;
import com.petcare.daos.RoomDAO;
import com.petcare.daos.ServiceDAO;
import com.petcare.models.Appointments;
import com.petcare.models.Combos;
import com.petcare.models.Pets;
import com.petcare.models.Rooms;
import com.petcare.models.ServiceBookingItem;
import com.petcare.models.Services;
import com.petcare.utils.DateUtil;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Proxy;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicReference;

import static org.junit.jupiter.api.Assertions.*;

class BookingServiceTest {

    private Pets ownedPet(int ownerId, int petId) {
        Pets p = new Pets();
        p.setOwnerId(ownerId);
        p.setPetId(petId);
        p.setName("Miu");
        p.setSpecies("Mèo");
        return p;
    }

    private Services service(int id, int durationMinutes, String category) {
        Services s = new Services();
        s.setServiceId(id);
        s.setName("Service " + id);
        s.setCategory(category);
        s.setDurationMinutes(durationMinutes);
        s.setPrice(new BigDecimal("150000"));
        s.setActive(true);
        return s;
    }

    @Test
    void comboBookingChainsSequentialDurationsWithoutOverlap() throws Exception {
        Services s1 = service(1, 45, "GROOMING");
        Services s2 = service(2, 30, "GROOMING");
        Combos combo = new Combos();
        combo.setComboId(10);
        combo.setName("Combo Spa");
        combo.setPrice(new BigDecimal("220000"));
        combo.setActive(true);
        combo.setServices(List.of(s1, s2));

        AtomicReference<List<ServiceBookingItem>> capturedItems = new AtomicReference<>();
        AtomicReference<Integer> capturedComboId = new AtomicReference<>();

        PetDAO petDAO = (PetDAO) Proxy.newProxyInstance(getClass().getClassLoader(), new Class[]{PetDAO.class},
                (p, m, a) -> "findById".equals(m.getName()) ? ownedPet(7, 3) : null);
        ComboDAO comboDAO = (ComboDAO) Proxy.newProxyInstance(getClass().getClassLoader(), new Class[]{ComboDAO.class},
                (p, m, a) -> "findByIdWithServices".equals(m.getName()) ? combo : null);
        AppointmentDAO apptDAO = (AppointmentDAO) Proxy.newProxyInstance(getClass().getClassLoader(), new Class[]{AppointmentDAO.class},
                (p, m, a) -> {
                    if ("bookServices".equals(m.getName())) {
                        @SuppressWarnings("unchecked")
                        List<ServiceBookingItem> list = (List<ServiceBookingItem>) a[2];
                        capturedItems.set(list);
                        capturedComboId.set((Integer) a[3]);
                        return 88;
                    }
                    return null;
                });

        BookingService bookingService = new BookingService(petDAO, null, comboDAO, null, apptDAO);
        LocalDateTime start = DateUtil.todayVn().plusDays(1).atTime(9, 0);
        int id = bookingService.bookCombo(7, 3, 10, start, Map.of(1, 20, 2, 21));

        assertEquals(88, id);
        assertEquals(10, capturedComboId.get());
        assertEquals(2, capturedItems.get().size());
        assertEquals(start, capturedItems.get().get(0).getScheduledStart());
        assertEquals(start.plusMinutes(45), capturedItems.get().get(0).getScheduledEnd());
        assertEquals(start.plusMinutes(45), capturedItems.get().get(1).getScheduledStart());
        assertEquals(start.plusMinutes(75), capturedItems.get().get(1).getScheduledEnd());
    }

    @Test
    void multiServiceRejectsDuplicateAndOverlappingSlots() {
        PetDAO petDAO = (PetDAO) Proxy.newProxyInstance(getClass().getClassLoader(), new Class[]{PetDAO.class},
                (p, m, a) -> "findById".equals(m.getName()) ? ownedPet(7, 3) : null);
        ServiceDAO serviceDAO = (ServiceDAO) Proxy.newProxyInstance(getClass().getClassLoader(), new Class[]{ServiceDAO.class},
                (p, m, a) -> "findById".equals(m.getName()) ? service((int) a[0], 60, "GROOMING") : null);

        BookingService svc = new BookingService(petDAO, serviceDAO, null, null, null);
        LocalDateTime t1 = DateUtil.todayVn().plusDays(1).atTime(10, 0);

        // Duplicate service ID
        assertThrows(IllegalArgumentException.class, () -> svc.bookMultipleServices(7, 3, List.of(
                new ServiceBookingItem(1, 2, t1),
                new ServiceBookingItem(1, 2, t1.plusHours(2)))));

        // Overlapping times for same pet
        assertThrows(IllegalArgumentException.class, () -> svc.bookMultipleServices(7, 3, List.of(
                new ServiceBookingItem(1, 2, t1),
                new ServiceBookingItem(2, 3, t1.plusMinutes(30)))));
    }

    @Test
    void boardingRejectsMaintenanceRoomAndInvalidDates() {
        Rooms maint = new Rooms();
        maint.setRoomId(5);
        maint.setStatus(Rooms.STATUS_MAINTENANCE);

        PetDAO petDAO = (PetDAO) Proxy.newProxyInstance(getClass().getClassLoader(), new Class[]{PetDAO.class},
                (p, m, a) -> "findById".equals(m.getName()) ? ownedPet(7, 3) : null);
        RoomDAO roomDAO = (RoomDAO) Proxy.newProxyInstance(getClass().getClassLoader(), new Class[]{RoomDAO.class},
                (p, m, a) -> "findById".equals(m.getName()) ? maint : null);

        BookingService svc = new BookingService(petDAO, null, null, roomDAO, null);
        LocalDate tomorrow = DateUtil.todayVn().plusDays(1);

        assertThrows(IllegalArgumentException.class, () ->
                svc.bookBoarding(7, 3, 5, tomorrow.minusDays(2), tomorrow));
        assertThrows(IllegalArgumentException.class, () ->
                svc.bookBoarding(7, 3, 5, tomorrow, tomorrow));
        assertThrows(IllegalArgumentException.class, () ->
                svc.bookBoarding(7, 3, 5, tomorrow, tomorrow.plusDays(2)));
    }

    @Test
    void cancelRequiresReasonAndPendingOrConfirmedStatus() throws Exception {
        Appointments completed = new Appointments();
        completed.setAppointmentId(50);
        completed.setCustomerId(7);
        completed.setStatus(Appointments.STATUS_COMPLETED);

        Appointments pending = new Appointments();
        pending.setAppointmentId(51);
        pending.setCustomerId(7);
        pending.setStatus(Appointments.STATUS_PENDING);

        AtomicReference<String> cancelReasonRef = new AtomicReference<>();
        AppointmentDAO apptDAO = (AppointmentDAO) Proxy.newProxyInstance(getClass().getClassLoader(), new Class[]{AppointmentDAO.class},
                (p, m, a) -> switch (m.getName()) {
                    case "findDetailByIdForCustomer" -> ((int) a[0] == 50) ? completed : pending;
                    case "cancelAppointment" -> {
                        cancelReasonRef.set((String) a[1]);
                        yield null;
                    }
                    default -> null;
                });

        BookingService svc = new BookingService(null, null, null, null, apptDAO);
        assertThrows(IllegalArgumentException.class, () -> svc.cancelByCustomer(7, 51, "   "));
        assertThrows(IllegalArgumentException.class, () -> svc.cancelByCustomer(7, 50, "Đổi lịch"));

        svc.cancelByCustomer(7, 51, "  Bận đột xuất  ");
        assertEquals("Bận đột xuất", cancelReasonRef.get());
    }
}
