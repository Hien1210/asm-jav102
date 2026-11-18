package com.petcare.services;

import com.petcare.daos.AccountDAO;
import com.petcare.models.Users;
import org.junit.jupiter.api.Test;
import java.lang.reflect.Proxy;
import java.sql.SQLException;
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
                "a".repeat(101), "0901111222", "qa@example.test", "Password@123"));
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
}
