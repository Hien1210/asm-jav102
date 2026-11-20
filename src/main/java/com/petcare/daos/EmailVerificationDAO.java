package com.petcare.daos;

import java.sql.SQLException;
import java.time.LocalDateTime;

public interface EmailVerificationDAO {

    /** Invalidates any still-usable tokens for the user, then stores a fresh one. */
    void createToken(int userId, String tokenHash, LocalDateTime expiresAt) throws SQLException;

    /** Marks the token used and returns its owner, or null if unknown/used/expired. */
    Integer consumeToken(String tokenHash) throws SQLException;

    /** True if the user still has an unconsumed, unexpired verification token. Never throws. */
    boolean hasPendingVerification(int userId);
}
