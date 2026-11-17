package com.petcare.daos;

import com.petcare.models.Users;

import java.sql.SQLException;
import java.util.List;

/** Account management; every write goes through a stored procedure (see database/petcare_accounts.sql). */
public interface AccountDAO {

    List<Users> findAll() throws SQLException;

    Users findById(int userId) throws SQLException;

    /** Matches email or phone; includes the password hash. Used only for authentication. */
    Users findByIdentifierWithPasswordHash(String identifier) throws SQLException;

    int create(Users account) throws SQLException;

    void update(Users account) throws SQLException;

    void setActive(int userId, boolean active) throws SQLException;

    void resetPassword(int userId, String passwordHash) throws SQLException;
}
