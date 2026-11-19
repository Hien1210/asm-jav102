package com.petcare.services;

import com.petcare.daos.AccountDAO;
import com.petcare.daos.AccountDAOImpl;
import com.petcare.daos.AppointmentDAO;
import com.petcare.daos.AppointmentDAOImpl;
import com.petcare.daos.PetDAO;
import com.petcare.daos.PetDAOImpl;
import com.petcare.models.AppointmentBalance;
import com.petcare.models.Pets;
import com.petcare.models.Users;
import com.petcare.utils.ValidationUtil;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Nhân viên tạo lịch hẹn và thu tiền ngay tại quầy cho khách không tự đặt lịch trên website
 * (khách vãng lai). Khách được tra/tạo theo số điện thoại, không cần mật khẩu hay đăng nhập.
 */
public class WalkInBookingService {

    private final AccountDAO accountDAO;
    private final PetDAO petDAO;
    private final AppointmentDAO appointmentDAO;
    private final BookingService bookingService;
    private final PaymentService paymentService;

    public WalkInBookingService() {
        this.accountDAO = new AccountDAOImpl();
        this.petDAO = new PetDAOImpl();
        this.appointmentDAO = new AppointmentDAOImpl();
        this.bookingService = new BookingService();
        this.paymentService = new PaymentService();
    }

    /**
     * Tìm khách theo số điện thoại; nếu đã có thì tái sử dụng (và sửa lại tên nếu nhân viên nhập
     * tên khác tên đã lưu), nếu chưa có thì tạo mới một tài khoản CUSTOMER không cần mật khẩu thật
     * (email sinh tự động từ số điện thoại, giống cách AuthService.registerCustomer đã làm khi
     * người dùng tự đăng ký không nhập email).
     */
    public Users findOrCreateCustomer(String fullName, String phone) throws SQLException {
        String cleanPhone = ValidationUtil.normalizePhone(phone);
        if (!ValidationUtil.isValidPhone(cleanPhone)) {
            throw new IllegalArgumentException("Số điện thoại không hợp lệ (ví dụ: 0912345678).");
        }
        String cleanName = fullName == null ? "" : fullName.trim();

        Users existing = accountDAO.findByPhone(cleanPhone);
        if (existing != null) {
            if (!existing.isCustomer()) {
                throw new IllegalArgumentException(
                        "Số điện thoại này đã gắn với tài khoản nhân viên/quản trị, không thể đặt lịch khách hàng.");
            }
            if (!existing.isActive()) {
                throw new IllegalArgumentException("Tài khoản của khách này hiện đang bị khóa.");
            }
            if (!cleanName.isEmpty() && !cleanName.equalsIgnoreCase(existing.getFullName())) {
                existing.setFullName(cleanName);
                accountDAO.updateProfile(existing);
            }
            return existing;
        }

        if (cleanName.isEmpty() || cleanName.length() > 100) {
            throw new IllegalArgumentException("Vui lòng nhập tên khách hàng.");
        }

        Users newUser = new Users();
        newUser.setFullName(cleanName);
        newUser.setPhone(cleanPhone);
        newUser.setEmail(cleanPhone + "@petcare.vn");
        newUser.setPasswordHash(AuthService.hashPassword(UUID.randomUUID().toString()));
        newUser.setRole(Users.ROLE_CUSTOMER);
        newUser.setActive(true);
        try {
            return accountDAO.create(newUser);
        } catch (SQLException e) {
            throw new SQLException("Không tạo được hồ sơ khách hàng mới. Vui lòng thử lại.", e.getSQLState(), e);
        }
    }

    public Users getCustomer(int customerId) throws SQLException {
        Users customer = accountDAO.findById(customerId);
        if (customer == null || !customer.isCustomer()) {
            throw new IllegalArgumentException("Khách hàng không hợp lệ. Vui lòng tìm lại.");
        }
        return customer;
    }

    public List<Pets> listPets(int customerId) throws SQLException {
        return petDAO.findByOwner(customerId);
    }

    public int addPet(int customerId, String name, String species, String breed) throws SQLException {
        String cleanName = name == null ? "" : name.trim();
        String cleanSpecies = species == null ? "" : species.trim();
        if (ValidationUtil.isBlank(cleanName) || ValidationUtil.isBlank(cleanSpecies)
                || cleanName.length() > 100 || cleanSpecies.length() > 50) {
            throw new IllegalArgumentException("Vui lòng nhập tên và loài thú cưng.");
        }
        Pets pet = new Pets();
        pet.setOwnerId(customerId);
        pet.setName(cleanName);
        pet.setSpecies(cleanSpecies);
        pet.setBreed(breed == null ? null : breed.trim());
        return petDAO.create(pet);
    }

    /**
     * Đặt lịch, xác nhận ngay (CONFIRMED, vì nhân viên đã xác nhận trực tiếp trước mặt khách) rồi
     * thu đủ tiền tại quầy. Trả về appointment_id vừa tạo.
     */
    public int bookAndSettleAtCounter(int customerId, int petId, int serviceId, int staffId,
                                       LocalDateTime start, String method, String transactionRef)
            throws SQLException {
        int appointmentId = bookingService.bookService(customerId, petId, serviceId, staffId, start);

        try {
            appointmentDAO.setStatus(appointmentId, "CONFIRMED", null);
        } catch (SQLException e) {
            throw new SQLException("Đặt lịch thành công (#" + appointmentId
                    + ") nhưng xác nhận lịch hẹn thất bại. Vui lòng xác nhận lại thủ công.",
                    e.getSQLState(), e);
        }

        BigDecimal amount = findRemaining(customerId, appointmentId);
        try {
            paymentService.pay(customerId, appointmentId, amount, method, transactionRef);
        } catch (IllegalArgumentException e) {
            throw new SQLException("Đặt lịch #" + appointmentId
                    + " thành công nhưng chưa thu được tiền (" + e.getMessage()
                    + "). Vào lại trang này, chọn đúng phương thức và thử thu tiền lại cho lịch hẹn #"
                    + appointmentId + ".");
        }
        return appointmentId;
    }

    private BigDecimal findRemaining(int customerId, int appointmentId) throws SQLException {
        for (AppointmentBalance balance : paymentService.listPayable(customerId)) {
            if (balance.getAppointmentId() == appointmentId) {
                return balance.getRemainingAmount();
            }
        }
        throw new SQLException("Không xác định được số tiền cần thu cho lịch hẹn #" + appointmentId + ".");
    }
}
