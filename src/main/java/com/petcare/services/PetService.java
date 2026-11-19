package com.petcare.services;

import com.petcare.daos.PetDAO;
import com.petcare.daos.PetDAOImpl;
import com.petcare.models.Pets;
import com.petcare.utils.DateUtil;
import com.petcare.utils.ValidationUtil;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PetService {
    private static final BigDecimal MAX_WEIGHT = new BigDecimal("999.99");
    private static final int MAX_MEDICAL_NOTES_LEN = 4000;

    private static final Map<Integer, String> FRIENDLY_ERRORS = new HashMap<>();
    static {
        FRIENDLY_ERRORS.put(51001, "Hệ thống đang bận, vui lòng thử lại sau giây lát.");
        FRIENDLY_ERRORS.put(51002, "Chỉ tài khoản khách hàng (CUSTOMER) mới được sở hữu thú cưng.");
        FRIENDLY_ERRORS.put(51060, "Tài khoản của bạn hiện không hoạt động hoặc không phải khách hàng.");
        FRIENDLY_ERRORS.put(51061, "Không tìm thấy thú cưng thuộc tài khoản của bạn.");
        FRIENDLY_ERRORS.put(51062, "Không thể xóa thú cưng đã có lịch hẹn trong hệ thống.");
        FRIENDLY_ERRORS.put(547, "Không thể xóa thú cưng đang được gắn với lịch hẹn trong hệ thống.");
    }

    private final PetDAO petDAO;

    public PetService() {
        this(new PetDAOImpl());
    }

    public PetService(PetDAO petDAO) {
        this.petDAO = petDAO;
    }

    public List<Pets> listMyPets(int customerId) throws SQLException {
        return petDAO.findByOwner(customerId);
    }

    public Pets getMyPet(int customerId, int petId) throws SQLException {
        Pets pet = petDAO.findById(petId);
        if (pet == null || pet.getOwnerId() == null || pet.getOwnerId() != customerId) {
            return null;
        }
        return pet;
    }

    public int createPet(int customerId, String name, String species, String breed,
                         BigDecimal weightKg, LocalDate birthDate, String medicalNotes) throws SQLException {
        Pets pet = buildValidatedPet(customerId, null, name, species, breed, weightKg, birthDate, medicalNotes);
        try {
            return petDAO.create(pet);
        } catch (SQLException e) {
            throw translate(e, "Không thể thêm thú cưng. Vui lòng kiểm tra lại thông tin.");
        }
    }

    public void updatePet(int customerId, int petId, String name, String species, String breed,
                          BigDecimal weightKg, LocalDate birthDate, String medicalNotes) throws SQLException {
        Pets existing = petDAO.findById(petId);
        if (existing == null || existing.getOwnerId() == null || existing.getOwnerId() != customerId) {
            throw new IllegalArgumentException("Thú cưng không tồn tại hoặc không thuộc tài khoản của bạn.");
        }
        Pets pet = buildValidatedPet(customerId, petId, name, species, breed, weightKg, birthDate, medicalNotes);
        try {
            if (!petDAO.update(pet)) {
                throw new IllegalArgumentException("Không tìm thấy thú cưng để cập nhật.");
            }
        } catch (SQLException e) {
            throw translate(e, "Không thể cập nhật thông tin thú cưng.");
        }
    }

    public void deletePet(int customerId, int petId) throws SQLException {
        Pets existing = petDAO.findById(petId);
        if (existing == null || existing.getOwnerId() == null || existing.getOwnerId() != customerId) {
            throw new IllegalArgumentException("Thú cưng không tồn tại hoặc không thuộc tài khoản của bạn.");
        }
        if (existing.getAppointmentCount() > 0) {
            throw new IllegalArgumentException("Không thể xóa thú cưng đã có lịch hẹn trong hệ thống.");
        }
        try {
            if (!petDAO.delete(petId, customerId)) {
                throw new IllegalArgumentException("Không tìm thấy thú cưng để xóa.");
            }
        } catch (SQLException e) {
            throw translate(e, "Không thể xóa thú cưng. Có thể thú cưng đang gắn với lịch hẹn.");
        }
    }

    private Pets buildValidatedPet(int customerId, Integer petId, String name, String species, String breed,
                                   BigDecimal weightKg, LocalDate birthDate, String medicalNotes) {
        String cleanName = trim(name);
        String cleanSpecies = trim(species);
        String cleanBreed = trim(breed);
        String cleanNotes = trim(medicalNotes);

        if (ValidationUtil.isBlank(cleanName)) {
            throw new IllegalArgumentException("Vui lòng nhập tên thú cưng.");
        }
        if (cleanName.length() > 100) {
            throw new IllegalArgumentException("Tên thú cưng tối đa 100 ký tự.");
        }
        if (ValidationUtil.isBlank(cleanSpecies)) {
            throw new IllegalArgumentException("Vui lòng nhập loài thú cưng (ví dụ: Chó, Mèo).");
        }
        if (cleanSpecies.length() > 50) {
            throw new IllegalArgumentException("Loài thú cưng tối đa 50 ký tự.");
        }
        if (cleanBreed.length() > 100) {
            throw new IllegalArgumentException("Giống thú cưng tối đa 100 ký tự.");
        }
        if (weightKg != null) {
            if (weightKg.compareTo(BigDecimal.ZERO) <= 0 || weightKg.compareTo(MAX_WEIGHT) > 0) {
                throw new IllegalArgumentException("Cân nặng phải lớn hơn 0 và không quá 999.99 kg.");
            }
        }
        if (birthDate != null && birthDate.isAfter(DateUtil.todayVn())) {
            throw new IllegalArgumentException("Ngày sinh thú cưng không được ở tương lai.");
        }
        if (cleanNotes.length() > MAX_MEDICAL_NOTES_LEN) {
            throw new IllegalArgumentException("Ghi chú sức khỏe tối đa " + MAX_MEDICAL_NOTES_LEN + " ký tự.");
        }

        Pets pet = new Pets();
        pet.setPetId(petId);
        pet.setOwnerId(customerId);
        pet.setName(cleanName);
        pet.setSpecies(cleanSpecies);
        pet.setBreed(cleanBreed.isEmpty() ? null : cleanBreed);
        pet.setWeightKg(weightKg);
        pet.setBirthDate(birthDate != null ? Date.valueOf(birthDate) : null);
        pet.setMedicalNotes(cleanNotes.isEmpty() ? null : cleanNotes);
        return pet;
    }

    private SQLException translate(SQLException e, String fallback) {
        String friendly = FRIENDLY_ERRORS.getOrDefault(e.getErrorCode(), fallback);
        return new SQLException(friendly, e.getSQLState(), e.getErrorCode(), e);
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
