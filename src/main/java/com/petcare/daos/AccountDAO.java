package com.petcare.daos;

import com.petcare.models.Users;
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
}
