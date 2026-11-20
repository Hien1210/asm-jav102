package com.petcare.daos;

import java.sql.SQLException;
import java.time.LocalDateTime;

public interface PasswordResetDAO {

    /** Invalidates any still-usable tokens for the user, then stores a fresh one. */
    void createToken(int userId, String tokenHash, LocalDateTime expiresAt) throws SQLException;

    /** Marks the token used and returns its owner, or null if unknown/used/expired. */
    Integer consumeToken(String tokenHash) throws SQLException;
}
