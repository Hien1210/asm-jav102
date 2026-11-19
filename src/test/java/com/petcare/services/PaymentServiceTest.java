package com.petcare.services;

import com.petcare.daos.PaymentDAO;
import com.petcare.models.AppointmentBalance;
import com.petcare.models.Payments;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Proxy;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicReference;

import static org.junit.jupiter.api.Assertions.*;

class PaymentServiceTest {

    @Test
    void rejectsOverpaymentAndInvalidMethod() {
        AppointmentBalance bal = new AppointmentBalance(
                10, "SERVICE", "PENDING",
                new BigDecimal("150000"), new BigDecimal("50000"), new Timestamp(System.currentTimeMillis()));
        PaymentDAO dao = (PaymentDAO) Proxy.newProxyInstance(getClass().getClassLoader(), new Class[]{PaymentDAO.class},
                (p, m, a) -> "findPayableAppointments".equals(m.getName()) ? List.of(bal) : null);

        PaymentService service = new PaymentService(dao);
        assertThrows(IllegalArgumentException.class, () ->
                service.initiatePayment(1, 10, BigDecimal.ZERO, "ONLINE", UUID.randomUUID()));
        assertThrows(IllegalArgumentException.class, () ->
                service.initiatePayment(1, 10, new BigDecimal("50000"), "CRYPTO", UUID.randomUUID()));
        assertThrows(IllegalArgumentException.class, () ->
                service.initiatePayment(1, 10, new BigDecimal("120000"), "ONLINE", UUID.randomUUID()));
        assertThrows(IllegalArgumentException.class, () ->
                service.initiatePayment(1, 999, new BigDecimal("50000"), "ONLINE", UUID.randomUUID()));
    }

    @Test
    void onlinePaymentGeneratesTransactionRefAndCanBeConfirmed() throws Exception {
        AppointmentBalance bal = new AppointmentBalance(
                10, "SERVICE", "PENDING",
                new BigDecimal("150000"), BigDecimal.ZERO, new Timestamp(System.currentTimeMillis()));
        AtomicReference<String> capturedRef = new AtomicReference<>();
        AtomicReference<String> capturedStatus = new AtomicReference<>();

        Payments pendingOnline = new Payments();
        pendingOnline.setPaymentId(77);
        pendingOnline.setAppointmentId(10);
        pendingOnline.setAmount(new BigDecimal("150000"));
        pendingOnline.setMethod(Payments.METHOD_ONLINE);
        pendingOnline.setPaymentType(Payments.TYPE_CHARGE);
        pendingOnline.setStatus(Payments.STATUS_PENDING);

        PaymentDAO dao = (PaymentDAO) Proxy.newProxyInstance(getClass().getClassLoader(), new Class[]{PaymentDAO.class},
                (p, m, a) -> switch (m.getName()) {
                    case "findPayableAppointments" -> List.of(bal);
                    case "recordPayment" -> {
                        capturedRef.set((String) a[4]);
                        yield 77;
                    }
                    case "findByIdForCustomer" -> pendingOnline;
                    case "setStatus" -> {
                        capturedStatus.set((String) a[1]);
                        yield null;
                    }
                    default -> null;
                });

        PaymentService service = new PaymentService(dao);
        int pid = service.initiatePayment(1, 10, new BigDecimal("150000"), "ONLINE", UUID.randomUUID());
        assertEquals(77, pid);
        assertNotNull(capturedRef.get());
        assertTrue(capturedRef.get().startsWith("PC-ONL-10-"));

        Payments confirmed = service.confirmOnlinePayment(1, 77);
        assertEquals(Payments.STATUS_PAID, confirmed.getStatus());
        assertEquals(Payments.STATUS_PAID, capturedStatus.get());
    }

    @Test
    void customerCannotSelfConfirmCashPayment() {
        Payments pendingCash = new Payments();
        pendingCash.setPaymentId(88);
        pendingCash.setMethod(Payments.METHOD_CASH);
        pendingCash.setPaymentType(Payments.TYPE_CHARGE);
        pendingCash.setStatus(Payments.STATUS_PENDING);

        PaymentDAO dao = (PaymentDAO) Proxy.newProxyInstance(getClass().getClassLoader(), new Class[]{PaymentDAO.class},
                (p, m, a) -> "findByIdForCustomer".equals(m.getName()) ? pendingCash : null);

        PaymentService service = new PaymentService(dao);
        assertThrows(IllegalArgumentException.class, () -> service.confirmOnlinePayment(1, 88));
    }
}
