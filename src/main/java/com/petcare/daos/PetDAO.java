package com.petcare.daos;

import com.petcare.models.Pets;

import java.sql.SQLException;
import java.util.List;

public interface PetDAO {

    List<Pets> findByOwner(int ownerId) throws SQLException;

    Pets findById(int petId) throws SQLException;

    /** Creates a pet (uses dbo.CreatePet with graceful fallback). */
    int create(Pets pet) throws SQLException;

    /** Updates a pet belonging to the owner (uses dbo.UpdatePet with fallback). */
    boolean update(Pets pet) throws SQLException;

    /** Deletes a pet belonging to the owner if it has no appointments (uses dbo.DeletePet with fallback). */
    boolean delete(int petId, int ownerId) throws SQLException;
}
