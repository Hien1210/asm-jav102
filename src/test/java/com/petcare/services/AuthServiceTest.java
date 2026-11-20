package com.petcare.services;

import com.petcare.daos.AccountDAO;
import com.petcare.daos.EmailVerificationDAO;
import com.petcare.daos.PasswordResetDAO;
import com.petcare.models.Users;
import org.junit.jupiter.api.Test;
import java.lang.reflect.Proxy;
import java.sql.SQLException;
import java.time.LocalDateTime;
import static org.junit.jupiter.api.Assertions.*;

class AuthServiceTest {
    private AccountDAO dao(boolean updateResult) {
        return (AccountDAO) Proxy.newProxyInstance(getClass().getClassLoader(),
                new Class[]{AccountDAO.class}, (p, m, a) -> switch (m.getName()) {
                    case "findById", "findByIdentifier" -> new Users(7, "QA", "qa@example.test",
                            "0901111222", "OldPass@123", "CUSTOMER", true, null);
                    case "existsByEmail", "existsByPhone" -> false;
                    case "updateProfile", "updatePassword" -> updateResult;
                    default -> null;
                });
    }

    @Test void overlongNameIsRejectedBeforeDatabaseWrite() {
        AuthService service = new AuthService(dao(true));
        assertThrows(IllegalArgumentException.class, () -> service.registerCustomer(
                "a".repeat(101), "0901111222", "qa@example.test", "Password@123", "http://x/verify"));
    }

    @Test void unsuccessfulProfileUpdateCannotReportSuccess() {
        assertThrows(SQLException.class, () -> new AuthService(dao(false)).updateProfile(
                7, "QA", "0901111222", "qa@example.test"));
    }

    @Test void unsuccessfulPasswordUpdateCannotReportSuccess() {
        assertThrows(SQLException.class, () -> new AuthService(dao(false)).changePassword(
                7, "OldPass@123", "NewPass@123"));
    }

    @Test void passwordChangeWorksWhenProfileProcedureOmitsHash() throws Exception {
        // findById intentionally has no hash; authentication supplies it separately.
        AccountDAO repository = (AccountDAO) Proxy.newProxyInstance(getClass().getClassLoader(),
                new Class[]{AccountDAO.class}, (p, m, a) -> switch (m.getName()) {
                    case "findById" -> new Users(7, "QA", "qa@example.test", "0901111222",
                            null, "CUSTOMER", true, null);
                    case "findByIdentifier" -> new Users(7, "QA", "qa@example.test", "0901111222",
                            "OldPass@123", "CUSTOMER", true, null);
                    case "updatePassword" -> true;
                    default -> null;
                });
        new AuthService(repository).changePassword(7, "OldPass@123", "NewPass@123");
    }

    private AccountDAO dao(boolean updateResult, Users createResult) {
        return (AccountDAO) Proxy.newProxyInstance(getClass().getClassLoader(),
                new Class[]{AccountDAO.class}, (p, m, a) -> switch (m.getName()) {
                    case "findById", "findByIdentifier" -> new Users(7, "QA", "qa@example.test",
                            "0901111222", "OldPass@123", "CUSTOMER", true, null);
                    case "existsByEmail", "existsByPhone" -> false;
                    case "updateProfile", "updatePassword" -> updateResult;
                    case "create" -> createResult;
                    default -> null;
                });
    }

    private static class FakeEmailVerificationDAO implements EmailVerificationDAO {
        int createCalls = 0;
        boolean pending;
        String consumeReturns;

        @Override
        public void createToken(int userId, String tokenHash, LocalDateTime expiresAt) {
            createCalls++;
        }

        @Override
        public Integer consumeToken(String tokenHash) {
            return "match".equals(consumeReturns) ? 7 : null;
        }

        @Override
        public boolean hasPendingVerification(int userId) {
            return pending;
        }
    }

    @Test void registeringSendsAVerificationEmailAndStoresItsToken() throws Exception {
        Users created = new Users(9, "QA", "qa@example.test", "0901111222",
                "hash", "CUSTOMER", true, null);
        FakeEmailVerificationDAO verificationDao = new FakeEmailVerificationDAO();
        AuthService service = new AuthService(dao(true, created), new PasswordResetDAOImplStub(),
                verificationDao, (to, subject, body) -> { });
        service.registerCustomer("QA", "0901111222", "qa@example.test", "Password@123", "http://x/verify");
        assertEquals(1, verificationDao.createCalls);
    }

    @Test void registrationMailOutageNeverStoresAVerificationToken() throws Exception {
        Users created = new Users(9, "QA", "qa@example.test", "0901111222",
                "hash", "CUSTOMER", true, null);
        FakeEmailVerificationDAO verificationDao = new FakeEmailVerificationDAO();
        AuthService.MailSender brokenSender = (to, subject, body) -> { throw new RuntimeException("SMTP down"); };
        AuthService service = new AuthService(dao(true, created), new PasswordResetDAOImplStub(),
                verificationDao, brokenSender);
        assertDoesNotThrow(() -> service.registerCustomer(
                "QA", "0901111222", "qa@example.test", "Password@123", "http://x/verify"));
        assertEquals(0, verificationDao.createCalls);
    }

    @Test void loginIsBlockedWhileEmailVerificationIsPending() {
        FakeEmailVerificationDAO verificationDao = new FakeEmailVerificationDAO();
        verificationDao.pending = true;
        AuthService service = new AuthService(dao(true, null), new PasswordResetDAOImplStub(),
                verificationDao, (to, subject, body) -> { });
        assertThrows(IllegalArgumentException.class,
                () -> service.authenticate("qa@example.test", "OldPass@123"));
    }

    @Test void loginSucceedsOnceEmailVerificationIsNoLongerPending() throws Exception {
        FakeEmailVerificationDAO verificationDao = new FakeEmailVerificationDAO();
        verificationDao.pending = false;
        AuthService service = new AuthService(dao(true, null), new PasswordResetDAOImplStub(),
                verificationDao, (to, subject, body) -> { });
        assertDoesNotThrow(() -> service.authenticate("qa@example.test", "OldPass@123"));
    }

    @Test void verifyingWithAnInvalidTokenIsRejected() {
        FakeEmailVerificationDAO verificationDao = new FakeEmailVerificationDAO();
        verificationDao.consumeReturns = "no-match";
        AuthService service = new AuthService(dao(true, null), new PasswordResetDAOImplStub(),
                verificationDao, (to, subject, body) -> { });
        assertThrows(IllegalArgumentException.class, () -> service.verifyEmail("some-token"));
    }

    @Test void verifyingWithAValidTokenSucceeds() {
        FakeEmailVerificationDAO verificationDao = new FakeEmailVerificationDAO();
        verificationDao.consumeReturns = "match";
        AuthService service = new AuthService(dao(true, null), new PasswordResetDAOImplStub(),
                verificationDao, (to, subject, body) -> { });
        assertDoesNotThrow(() -> service.verifyEmail("some-token"));
    }

    private static class PasswordResetDAOImplStub implements PasswordResetDAO {
        @Override public void createToken(int userId, String tokenHash, LocalDateTime expiresAt) { }
        @Override public Integer consumeToken(String tokenHash) { return null; }
    }

    private static class FakePasswordResetDAO implements PasswordResetDAO {
        int createCalls = 0;
        String consumeReturns;
        String lastTokenHash;

        @Override
        public void createToken(int userId, String tokenHash, LocalDateTime expiresAt) {
            createCalls++;
            lastTokenHash = tokenHash;
        }

        @Override
        public Integer consumeToken(String tokenHash) {
            return "match".equals(consumeReturns) ? 7 : null;
        }
    }

    @Test void requestingResetForUnknownIdentifierNeverCreatesAToken() throws Exception {
        AccountDAO repository = (AccountDAO) Proxy.newProxyInstance(getClass().getClassLoader(),
                new Class[]{AccountDAO.class}, (p, m, a) -> switch (m.getName()) {
                    case "findByIdentifier" -> null;
                    default -> null;
                });
        FakePasswordResetDAO resetDao = new FakePasswordResetDAO();
        new AuthService(repository, resetDao).requestPasswordReset("khong-ton-tai@example.test", "http://x/reset");
        assertEquals(0, resetDao.createCalls);
    }

    @Test void requestingResetForKnownActiveUserCreatesAToken() throws Exception {
        FakePasswordResetDAO resetDao = new FakePasswordResetDAO();
        AuthService service = new AuthService(dao(true), resetDao, (to, subject, body) -> { });
        service.requestPasswordReset("qa@example.test", "http://x/reset");
        assertEquals(1, resetDao.createCalls);
        assertNotNull(resetDao.lastTokenHash);
    }

    @Test void resettingWithAnInvalidTokenIsRejected() {
        FakePasswordResetDAO resetDao = new FakePasswordResetDAO();
        resetDao.consumeReturns = "no-match";
        AuthService service = new AuthService(dao(true), resetDao);
        assertThrows(IllegalArgumentException.class,
                () -> service.resetPasswordWithToken("some-token", "NewPass@123"));
    }

    @Test void resettingWithAValidTokenUpdatesThePassword() throws Exception {
        FakePasswordResetDAO resetDao = new FakePasswordResetDAO();
        resetDao.consumeReturns = "match";
        AuthService service = new AuthService(dao(true), resetDao);
        assertDoesNotThrow(() -> service.resetPasswordWithToken("some-token", "NewPass@123"));
    }

    @Test void resetPasswordRejectsTooShortNewPassword() {
        FakePasswordResetDAO resetDao = new FakePasswordResetDAO();
        resetDao.consumeReturns = "match";
        AuthService service = new AuthService(dao(true), resetDao);
        assertThrows(IllegalArgumentException.class,
                () -> service.resetPasswordWithToken("some-token", "short"));
    }
}
