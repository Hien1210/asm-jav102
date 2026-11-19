package com.petcare.daos;

import com.petcare.models.Pets;
import com.petcare.utils.DBUtil;
import com.petcare.utils.DateUtil;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class PetDAOImpl implements PetDAO {

    private static final String SELECT_WITH_COUNT =
            "SELECT p.pet_id, p.owner_id, p.name, p.species, p.breed, p.weight_kg, p.birth_date, "
            + "p.medical_notes, p.created_at, "
            + "(SELECT COUNT(*) FROM dbo.Appointments a WHERE a.pet_id = p.pet_id) AS appointment_count "
            + "FROM dbo.Pets p ";

    private Pets mapRow(ResultSet rs) throws SQLException {
        Pets pet = new Pets();
        pet.setPetId(rs.getInt("pet_id"));
        pet.setOwnerId(rs.getInt("owner_id"));
        pet.setName(rs.getString("name"));
        pet.setSpecies(rs.getString("species"));
        pet.setBreed(rs.getString("breed"));
        pet.setWeightKg(rs.getBigDecimal("weight_kg"));
        pet.setBirthDate(rs.getDate("birth_date"));
        pet.setMedicalNotes(rs.getString("medical_notes"));
        Timestamp createdTs = rs.getTimestamp("created_at");
        pet.setCreatedAt(createdTs != null ? createdTs.toLocalDateTime() : null);
        pet.setAppointmentCount(rs.getInt("appointment_count"));
        return pet;
    }

    private Pets mapLocalRow(String[] cols) {
        Pets pet = new Pets();
        pet.setPetId(Integer.parseInt(cols[0]));
        pet.setOwnerId(Integer.parseInt(cols[1]));
        pet.setName(cols[2]);
        pet.setSpecies(cols[3]);
        pet.setBreed(cols[4]);
        pet.setWeightKg(cols[5] != null && !cols[5].isEmpty() ? new BigDecimal(cols[5]) : null);
        pet.setBirthDate(cols[6] != null && !cols[6].isEmpty() ? Date.valueOf(DateUtil.parseLocalDate(cols[6])) : null);
        pet.setMedicalNotes(cols[7]);
        pet.setCreatedAt(DateUtil.parseLocalDateTime(cols[8]));
        if (cols.length > 9 && cols[9] != null && !cols[9].isEmpty()) {
            pet.setAppointmentCount(Integer.parseInt(cols[9]));
        }
        return pet;
    }

    @Override
    public List<Pets> findByOwner(int ownerId) throws SQLException {
        List<Pets> pets = new ArrayList<>();
        String sql = SELECT_WITH_COUNT + "WHERE p.owner_id = ? ORDER BY p.created_at DESC, p.name";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ownerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    pets.add(mapRow(rs));
                }
            }
            return pets;
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                String localSql = SELECT_WITH_COUNT + "WHERE p.owner_id = @p0 ORDER BY p.created_at DESC, p.name";
                for (String[] cols : DBUtil.queryLocalSql(localSql, DBUtil.localIntParam(ownerId))) {
                    pets.add(mapLocalRow(cols));
                }
                return pets;
            }
            throw e;
        }
    }

    @Override
    public Pets findById(int petId) throws SQLException {
        String sql = SELECT_WITH_COUNT + "WHERE p.pet_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, petId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                String localSql = SELECT_WITH_COUNT + "WHERE p.pet_id = @p0";
                List<String[]> rows = DBUtil.queryLocalSql(localSql, DBUtil.localIntParam(petId));
                return rows.isEmpty() ? null : mapLocalRow(rows.get(0));
            }
            throw e;
        }
    }

    @Override
    public int create(Pets pet) throws SQLException {
        try (Connection conn = DBUtil.getConnection()) {
            try (CallableStatement stmt = conn.prepareCall("{call dbo.CreatePet(?,?,?,?,?,?,?,?)}")) {
                stmt.setInt(1, pet.getOwnerId());
                stmt.setString(2, pet.getName());
                stmt.setString(3, pet.getSpecies());
                setNullableString(stmt, 4, pet.getBreed());
                setNullableDecimal(stmt, 5, pet.getWeightKg());
                setNullableDate(stmt, 6, pet.getBirthDate());
                stmt.registerOutParameter(7, Types.INTEGER);
                setNullableString(stmt, 8, pet.getMedicalNotes());
                stmt.execute();
                return stmt.getInt(7);
            } catch (SQLException procErr) {
                if (procErr.getErrorCode() == 8144) {
                    // Older 7-parameter dbo.CreatePet deployed on remote server.
                    try (CallableStatement stmt = conn.prepareCall("{call dbo.CreatePet(?,?,?,?,?,?,?)}")) {
                        stmt.setInt(1, pet.getOwnerId());
                        stmt.setString(2, pet.getName());
                        stmt.setString(3, pet.getSpecies());
                        setNullableString(stmt, 4, pet.getBreed());
                        setNullableDecimal(stmt, 5, pet.getWeightKg());
                        setNullableDate(stmt, 6, pet.getBirthDate());
                        stmt.registerOutParameter(7, Types.INTEGER);
                        stmt.execute();
                        int id = stmt.getInt(7);
                        if (pet.getMedicalNotes() != null && !pet.getMedicalNotes().isBlank()) {
                            tryUpdateMedicalNotesDirect(conn, id, pet.getOwnerId(), pet.getMedicalNotes());
                        }
                        return id;
                    }
                }
                if (procErr.getErrorCode() == 2812 || procErr.getErrorCode() == 229) {
                    return insertDirect(conn, pet);
                }
                throw procErr;
            }
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                return DBUtil.executeLocalScalarInt(
                        "DECLARE @pid INT; "
                        + "EXEC dbo.CreatePet @owner_id = @p0, @name = @p1, @species = @p2, @breed = @p3, "
                        + "@weight_kg = @p4, @birth_date = @p5, @pet_id = @pid OUTPUT, @medical_notes = @p6; "
                        + "SELECT @pid;",
                        DBUtil.localIntParam(pet.getOwnerId()),
                        DBUtil.localStringParam(pet.getName()),
                        DBUtil.localStringParam(pet.getSpecies()),
                        DBUtil.localStringParam(emptyToNull(pet.getBreed())),
                        DBUtil.localDecimalParam(pet.getWeightKg()),
                        DBUtil.localDateParam(pet.getBirthDate()),
                        DBUtil.localStringParam(emptyToNull(pet.getMedicalNotes())));
            }
            throw e;
        }
    }

    @Override
    public boolean update(Pets pet) throws SQLException {
        try (Connection conn = DBUtil.getConnection()) {
            try (CallableStatement stmt = conn.prepareCall("{call dbo.UpdatePet(?,?,?,?,?,?,?,?)}")) {
                stmt.setInt(1, pet.getPetId());
                stmt.setInt(2, pet.getOwnerId());
                stmt.setString(3, pet.getName());
                stmt.setString(4, pet.getSpecies());
                setNullableString(stmt, 5, pet.getBreed());
                setNullableDecimal(stmt, 6, pet.getWeightKg());
                setNullableDate(stmt, 7, pet.getBirthDate());
                setNullableString(stmt, 8, pet.getMedicalNotes());
                stmt.execute();
                return true;
            } catch (SQLException procErr) {
                if (procErr.getErrorCode() == 2812 || procErr.getErrorCode() == 229) {
                    String sql = "UPDATE dbo.Pets SET name = ?, species = ?, breed = ?, weight_kg = ?, "
                            + "birth_date = ?, medical_notes = ? WHERE pet_id = ? AND owner_id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setString(1, pet.getName());
                        ps.setString(2, pet.getSpecies());
                        setNullableString(ps, 3, pet.getBreed());
                        setNullableDecimal(ps, 4, pet.getWeightKg());
                        setNullableDate(ps, 5, pet.getBirthDate());
                        setNullableString(ps, 6, pet.getMedicalNotes());
                        ps.setInt(7, pet.getPetId());
                        ps.setInt(8, pet.getOwnerId());
                        return ps.executeUpdate() > 0;
                    }
                }
                throw procErr;
            }
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                DBUtil.executeLocalNonQuery(
                        "EXEC dbo.UpdatePet @pet_id = @p0, @owner_id = @p1, @name = @p2, @species = @p3, "
                        + "@breed = @p4, @weight_kg = @p5, @birth_date = @p6, @medical_notes = @p7;",
                        DBUtil.localIntParam(pet.getPetId()),
                        DBUtil.localIntParam(pet.getOwnerId()),
                        DBUtil.localStringParam(pet.getName()),
                        DBUtil.localStringParam(pet.getSpecies()),
                        DBUtil.localStringParam(emptyToNull(pet.getBreed())),
                        DBUtil.localDecimalParam(pet.getWeightKg()),
                        DBUtil.localDateParam(pet.getBirthDate()),
                        DBUtil.localStringParam(emptyToNull(pet.getMedicalNotes())));
                return true;
            }
            throw e;
        }
    }

    @Override
    public boolean delete(int petId, int ownerId) throws SQLException {
        try (Connection conn = DBUtil.getConnection()) {
            try (CallableStatement stmt = conn.prepareCall("{call dbo.DeletePet(?,?)}")) {
                stmt.setInt(1, petId);
                stmt.setInt(2, ownerId);
                stmt.execute();
                return true;
            } catch (SQLException procErr) {
                if (procErr.getErrorCode() == 2812 || procErr.getErrorCode() == 229) {
                    String sql = "DELETE FROM dbo.Pets WHERE pet_id = ? AND owner_id = ?";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setInt(1, petId);
                        ps.setInt(2, ownerId);
                        return ps.executeUpdate() > 0;
                    }
                }
                throw procErr;
            }
        } catch (SQLException e) {
            if (DBUtil.isConnectionFailure(e)) {
                DBUtil.executeLocalNonQuery(
                        "EXEC dbo.DeletePet @pet_id = @p0, @owner_id = @p1;",
                        DBUtil.localIntParam(petId),
                        DBUtil.localIntParam(ownerId));
                return true;
            }
            throw e;
        }
    }

    private int insertDirect(Connection conn, Pets pet) throws SQLException {
        String sql = "INSERT INTO dbo.Pets(owner_id, name, species, breed, weight_kg, birth_date, medical_notes) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, pet.getOwnerId());
            ps.setString(2, pet.getName());
            ps.setString(3, pet.getSpecies());
            setNullableString(ps, 4, pet.getBreed());
            setNullableDecimal(ps, 5, pet.getWeightKg());
            setNullableDate(ps, 6, pet.getBirthDate());
            setNullableString(ps, 7, pet.getMedicalNotes());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : 0;
            }
        }
    }

    private void tryUpdateMedicalNotesDirect(Connection conn, int petId, int ownerId, String notes) {
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE dbo.Pets SET medical_notes = ? WHERE pet_id = ? AND owner_id = ?")) {
            ps.setString(1, notes);
            ps.setInt(2, petId);
            ps.setInt(3, ownerId);
            ps.executeUpdate();
        } catch (SQLException ignored) {
            // Remote role may deny direct table UPDATE until petcare_customer_features.sql is applied.
        }
    }

    private String emptyToNull(String value) {
        return (value == null || value.isBlank()) ? null : value.trim();
    }

    private void setNullableString(PreparedStatement stmt, int idx, String value) throws SQLException {
        String cleaned = emptyToNull(value);
        if (cleaned != null) {
            stmt.setString(idx, cleaned);
        } else {
            stmt.setNull(idx, Types.NVARCHAR);
        }
    }

    private void setNullableDecimal(PreparedStatement stmt, int idx, BigDecimal value) throws SQLException {
        if (value != null) {
            stmt.setBigDecimal(idx, value);
        } else {
            stmt.setNull(idx, Types.DECIMAL);
        }
    }

    private void setNullableDate(PreparedStatement stmt, int idx, Date value) throws SQLException {
        if (value != null) {
            stmt.setDate(idx, value);
        } else {
            stmt.setNull(idx, Types.DATE);
        }
    }
}
