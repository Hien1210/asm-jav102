package com.petcare.services;

import at.favre.lib.crypto.bcrypt.BCrypt;
import com.petcare.daos.AccountDAO;
import com.petcare.daos.AccountDAOImpl;
import com.petcare.models.Users;

import java.sql.SQLException;

public class AuthService {

    private final AccountDAO accountDAO;

    public AuthService() {
        this.accountDAO = new AccountDAOImpl();
    }

    public AuthService(AccountDAO accountDAO) {
        this.accountDAO = accountDAO;
    }

    public static String hashPassword(String rawPassword) {
        return BCrypt.withDefaults().hashToString(12, rawPassword.toCharArray());
    }

    /** Returns the authenticated account, or null if the identifier/password/active state does not match. */
    public Users authenticate(String identifier, String rawPassword) throws SQLException {
        Users user = accountDAO.findByIdentifierWithPasswordHash(identifier);
        if (user == null || !user.isActive()) {
            return null;
        }
        BCrypt.Result result = BCrypt.verifyer().verify(rawPassword.toCharArray(), user.getPasswordHash());
        return result.verified ? user : null;
    }
}
