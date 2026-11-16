package com.petcare.daos;

import com.petcare.models.Pets;
import com.petcare.utils.DBUtil;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class PetDAOImpl implements PetDAO {

    private Pets mapRow(ResultSet rs) throws SQLException {
        Pets pet = new Pets();
        pet.setPetId(rs.getInt("pet_id"));
        pet.setOwnerId(rs.getInt("owner_id"));
        pet.setName(rs.getString("name"));
        pet.setSpecies(rs.getString("species"));
        pet.setBreed(rs.getString("breed"));
        pet.setWeightKg(rs.getBigDecimal("weight_kg"));
        pet.setBirthDate(rs.getDate("birth_date"));
        return pet;
    }

    @Override
    public List<Pets> findByOwner(int ownerId) throws SQLException {
        List<Pets> pets = new ArrayList<>();
        String sql = "SELECT pet_id, owner_id, name, species, breed, weight_kg, birth_date "
                + "FROM dbo.Pets WHERE owner_id = ? ORDER BY name";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ownerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    pets.add(mapRow(rs));
                }
            }
        }
        return pets;
    }

    @Override
    public Pets findById(int petId) throws SQLException {
        String sql = "SELECT pet_id, owner_id, name, species, breed, weight_kg, birth_date "
                + "FROM dbo.Pets WHERE pet_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, petId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    @Override
    public int create(Pets pet) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
             CallableStatement stmt = conn.prepareCall("{call dbo.CreatePet(?,?,?,?,?,?,?)}")) {
            stmt.setInt(1, pet.getOwnerId());
            stmt.setString(2, pet.getName());
            stmt.setString(3, pet.getSpecies());
            stmt.setString(4, pet.getBreed());
            if (pet.getWeightKg() != null) {
                stmt.setBigDecimal(5, pet.getWeightKg());
            } else {
                stmt.setNull(5, Types.DECIMAL);
            }
            if (pet.getBirthDate() != null) {
                stmt.setDate(6, pet.getBirthDate());
            } else {
                stmt.setNull(6, Types.DATE);
            }
            stmt.registerOutParameter(7, Types.INTEGER);
            stmt.execute();
            return stmt.getInt(7);
        }
    }
}
