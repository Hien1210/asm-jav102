package com.petcare.services;

import com.petcare.daos.PetDAO;
import com.petcare.models.Pets;
import com.petcare.utils.DateUtil;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Proxy;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.concurrent.atomic.AtomicReference;

import static org.junit.jupiter.api.Assertions.*;

class PetServiceTest {

    private PetDAO fakeDao(Pets existingPet, AtomicReference<Pets> savedRef) {
        return (PetDAO) Proxy.newProxyInstance(getClass().getClassLoader(), new Class[]{PetDAO.class}, (p, m, a) ->
                switch (m.getName()) {
                    case "findByOwner" -> existingPet != null ? List.of(existingPet) : List.of();
                    case "findById" -> existingPet;
                    case "create" -> {
                        if (savedRef != null) savedRef.set((Pets) a[0]);
                        yield 42;
                    }
                    case "update" -> {
                        if (savedRef != null) savedRef.set((Pets) a[0]);
                        yield true;
                    }
                    case "delete" -> true;
                    default -> null;
                });
    }

    @Test
    void rejectsInvalidWeightAndFutureBirthDate() {
        PetService service = new PetService(fakeDao(null, null));
        assertThrows(IllegalArgumentException.class, () ->
                service.createPet(1, "Miu", "Mèo", "Anh", BigDecimal.ZERO, null, null));
        assertThrows(IllegalArgumentException.class, () ->
                service.createPet(1, "Miu", "Mèo", "Anh", new BigDecimal("1000.00"), null, null));
        assertThrows(IllegalArgumentException.class, () ->
                service.createPet(1, "Miu", "Mèo", "Anh", new BigDecimal("3.5"), DateUtil.todayVn().plusDays(1), null));
        assertThrows(IllegalArgumentException.class, () ->
                service.createPet(1, "a".repeat(101), "Mèo", null, null, null, null));
    }

    @Test
    void createsPetWithAllSchemaFields() throws Exception {
        AtomicReference<Pets> saved = new AtomicReference<>();
        PetService service = new PetService(fakeDao(null, saved));
        LocalDate birth = DateUtil.todayVn().minusYears(2);
        int id = service.createPet(5, "  Bé Bơ ", " Chó ", " Corgi ",
                new BigDecimal("11.25"), birth, "Đã tiêm 7 bệnh");
        assertEquals(42, id);
        assertEquals(5, saved.get().getOwnerId());
        assertEquals("Bé Bơ", saved.get().getName());
        assertEquals("Chó", saved.get().getSpecies());
        assertEquals("Corgi", saved.get().getBreed());
        assertEquals(new BigDecimal("11.25"), saved.get().getWeightKg());
        assertEquals("Đã tiêm 7 bệnh", saved.get().getMedicalNotes());
    }

    @Test
    void rejectsForeignOwnerUpdateAndDeleteOfPetWithAppointments() {
        Pets foreignPet = new Pets();
        foreignPet.setPetId(10);
        foreignPet.setOwnerId(99);
        PetService foreignSvc = new PetService(fakeDao(foreignPet, null));
        assertThrows(IllegalArgumentException.class, () ->
                foreignSvc.updatePet(5, 10, "Miu", "Mèo", null, null, null, null));

        Pets bookedPet = new Pets();
        bookedPet.setPetId(11);
        bookedPet.setOwnerId(5);
        bookedPet.setAppointmentCount(2);
        PetService bookedSvc = new PetService(fakeDao(bookedPet, null));
        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () ->
                bookedSvc.deletePet(5, 11));
        assertTrue(ex.getMessage().contains("lịch hẹn"));
    }

    @Test
    void translatesSqlDeleteConstraintError() {
        Pets ownPet = new Pets();
        ownPet.setPetId(11);
        ownPet.setOwnerId(5);
        ownPet.setAppointmentCount(0);
        PetDAO failingDao = (PetDAO) Proxy.newProxyInstance(getClass().getClassLoader(), new Class[]{PetDAO.class}, (p, m, a) ->
                switch (m.getName()) {
                    case "findById" -> ownPet;
                    case "delete" -> throw new SQLException("Constraint", "23000", 51062);
                    default -> null;
                });
        SQLException ex = assertThrows(SQLException.class, () -> new PetService(failingDao).deletePet(5, 11));
        assertTrue(ex.getMessage().contains("lịch hẹn"));
    }
}
