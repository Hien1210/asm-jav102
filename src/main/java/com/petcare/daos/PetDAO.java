package com.petcare.daos;

import com.petcare.models.Pets;

import java.sql.SQLException;
import java.util.List;

public interface PetDAO {

    List<Pets> findByOwner(int ownerId) throws SQLException;

    Pets findById(int petId) throws SQLException;

    /** Writes go through dbo.CreatePet (see database/petcare_booking_demo.sql). */
    int create(Pets pet) throws SQLException;
}
