package com.petcare.daos;

import com.petcare.models.Users;
<<<<<<< HEAD

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
=======
import java.sql.SQLException;
import java.util.List;

public interface AccountDAO {
    Users findById(int userId) throws SQLException;

    Users findByEmail(String email) throws SQLException;

    Users findByPhone(String phone) throws SQLException;

    Users findByIdentifier(String identifier) throws SQLException;

    boolean existsByEmail(String email) throws SQLException;

    boolean existsByPhone(String phone) throws SQLException;

    Users create(Users user) throws SQLException;

    boolean updateRoleAndStatus(int userId, String role, boolean isActive) throws SQLException;

    boolean updateProfile(Users user) throws SQLException;

    boolean updatePassword(int userId, String passwordHash) throws SQLException;

    List<Users> findAll() throws SQLException;
>>>>>>> bao
}
