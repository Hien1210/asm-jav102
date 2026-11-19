# PetCare Java structure

## config


## controllers

- DangKyServlet.java
- DangNhapServlet.java
- DangXuatServlet.java
- DanhGiaServlet.java (`/customer/danh-gia`) — xem lịch hoàn thành chờ đánh giá, gửi đánh giá 1-5 sao qua `dbo.SubmitReview`, xem lịch sử đánh giá.
- DatLichServlet.java (`/customer/dat-lich`) — thêm thú cưng nhanh, đặt dịch vụ lẻ, đặt nhiều dịch vụ, đặt gói Combo (`dbo.BookServiceAppointment`) và đặt phòng lưu trú (`dbo.BookBoardingAppointment`), hiển thị giờ mở cửa & ca trực nhân viên.
- HomeServlet.java (`/home`, `/trang-chu`, `/dat-lich`) — trang chủ, nạp đánh giá thật từ DB (fallback dữ liệu mẫu), chuyển `/dat-lich` về `/customer/dat-lich`.
- LichHenKhachHangServlet.java (`/customer/lich-hen`) — danh sách lịch hẹn của khách hàng, lọc theo trạng thái/loại, chi tiết dịch vụ/lưu trú/thanh toán và hủy lịch (`dbo.SetAppointmentStatus`).
- LichHenNhanVienServlet.java
- LichLamViecServlet.java
- LoginServlet.java
- ProfileServlet.java (`/profile`, `/ho-so`) — hồ sơ cá nhân, đổi mật khẩu và thống kê tổng quan cho khách hàng (số thú cưng, lịch hẹn, công nợ, đánh giá, thông báo).
- QuanLyCaLamViecServlet.java
- QuanLyComboServlet.java
- QuanLyDichVuServlet.java
- QuanLyPhongServlet.java
- QuanLyTaiKhoanServlet.java (`/admin/tai-khoan`)
- QuanLyThuCungServlet.java (`/customer/thu-cung`) — CRUD đầy đủ thú cưng của khách hàng (tên, loài, giống, cân nặng, ngày sinh, ghi chú sức khỏe).
- RegisterServlet.java
- ThanhToanServlet.java (`/customer/thanh-toan`) — xem hóa đơn còn nợ, khởi tạo thanh toán `CASH`/`ONLINE` idempotent (`dbo.RecordPayment`), xác nhận giao dịch `ONLINE` (`PAID`) hoặc hủy yêu cầu `PENDING` (`FAILED`) qua `dbo.SetPaymentStatus`, lịch sử giao dịch & hoàn tiền.
- ThongBaoServlet.java (`/customer/thong-bao`) — lịch sử thông báo của khách hàng theo loại (`dbo.Notifications`).
- TrangChuServlet.java

## daos

- AccountDAO.java / AccountDAOImpl.java
- AppointmentDAO.java / AppointmentDAOImpl.java — đặt dịch vụ đơn/đa dịch vụ/combo, đặt phòng lưu trú, tra cứu lịch hẹn kèm chi tiết, hủy lịch.
- BusinessHoursDAO.java / BusinessHoursDAOImpl.java — tải khung giờ mở cửa `dbo.BusinessHours`.
- ComboDAO.java / ComboDAOImpl.java — tải các gói combo đang hoạt động kèm danh sách dịch vụ thành phần.
- NotificationDAO.java / NotificationDAOImpl.java — lưu và tra cứu `dbo.Notifications`.
- PaymentDAO.java / PaymentDAOImpl.java — hóa đơn cần thanh toán, lịch sử thanh toán khách hàng, `dbo.RecordPayment`, `dbo.SetPaymentStatus`.
- PetDAO.java / PetDAOImpl.java — CRUD đầy đủ `dbo.Pets` (`CreatePet`, `UpdatePet`, `DeletePet` kèm fallback).
- ReviewDAO.java / ReviewDAOImpl.java — `dbo.SubmitReview`, danh sách lịch hoàn thành chưa đánh giá, đánh giá của khách và đánh giá công khai mới nhất.
- RoomDAO.java / RoomDAOImpl.java — danh sách phòng mở đặt và phòng trống theo khoảng ngày.
- ServiceDAO.java / ServiceDAOImpl.java
- StaffDAO.java / StaffDAOImpl.java — nhân viên có kỹ năng theo dịch vụ và ca trực sắp tới `dbo.Shifts`.

## filter

- AuthFilter.java — xác minh trạng thái/vai trò hiện tại từ DB trước khi truy cập khu vực bảo vệ.
- package-info.java

## listener

- package-info.java

## models

- AppointmentBalance.java
- Appointments.java
- AppointmentServices.java
- BoardingDetails.java
- BusinessHours.java
- Combos.java
- ComboServices.java
- Notifications.java
- Payments.java
- Pets.java
- Reviews.java
- Rooms.java
- ServiceBookingItem.java
- Services.java
- Shifts.java
- StaffOption.java
- StaffSkills.java
- Users.java

## services

- AuthService.java
- BookingService.java — đặt dịch vụ đơn, đa dịch vụ, gói combo (tự động xếp nối tiếp tránh trùng giờ), phòng lưu trú và hủy lịch phía khách hàng.
- NotificationService.java — lưu thông báo vào DB (best-effort) kết hợp đẩy toast realtime qua WebSocket.
- PaymentService.java — kiểm tra quyền sở hữu/công nợ, tạo giao dịch `CASH`/`ONLINE`, xác nhận `ONLINE` (`PAID`) và hủy `PENDING` (`FAILED`).
- PetService.java — kiểm tra hợp lệ theo schema SQL, kiểm tra chủ sở hữu và chặn xóa thú cưng đã có lịch hẹn.
- ReviewService.java — kiểm tra điểm 1-5 sao, độ dài nhận xét và ánh xạ lỗi SQL từ `dbo.SubmitReview`.

## utils

- ConfigUtil.java
- DatabaseConnectionTest.java
- DateUtil.java — múi giờ Việt Nam (`Asia/Ho_Chi_Minh`), định dạng ngày/giờ/VNĐ và nhãn thứ trong tuần.
- DBUtil.java — kết nối SQL Server JDBC kèm fallback SQL Server local (`localhost\SQLEXPRESS`) hỗ trợ tham số `INT`/`BIT`/`DECIMAL`/`GUID`/`STRING`.
- SessionUtil.java
- ValidationUtil.java

## websocket

- HttpSessionConfigurator.java
- NotificationEndpoint.java
- package-info.java

## webapp (Customer UI)

- `WEB-INF/includes/customerNav.jspf` — thanh điều hướng chung cho cổng Khách hàng (`/customer/*`).
- `assets/css/customer.css` — stylesheet thống nhất cho toàn bộ trang role `CUSTOMER`.
- `assets/css/profile.css` — stylesheet nâng cấp giao diện trang hồ sơ người dùng (`/profile`).
- `profile.jsp` — trang hồ sơ thành viên kèm banner kính mờ, thống kê hoạt động trực tiếp, danh sách bé cưng nhanh, form hồ sơ & đổi mật khẩu (có thanh đo độ mạnh mật khẩu) và 6 thẻ tiện ích.
- `customer/quanLyThuCung.jsp` — quản lý thú cưng (thêm/sửa/xóa, cân nặng, ngày sinh, ghi chú sức khỏe).
- `customer/datLich.jsp` — trung tâm đặt lịch 4 chế độ (Dịch vụ lẻ, Nhiều dịch vụ, Gói Combo, Phòng lưu trú) kèm giờ mở cửa & ca trực nhân viên.
- `customer/lichHenDanhSach.jsp` — danh sách lịch hẹn của tôi, lọc trạng thái/loại, chi tiết hóa đơn và hủy lịch kèm lý do.
- `customer/thanhToan.jsp` — thanh toán hóa đơn `ONLINE`/`CASH`, xác nhận/hủy giao dịch đang chờ và lịch sử thanh toán.
- `customer/danhGia.jsp` — gửi đánh giá 1-5 sao cho lịch hẹn `COMPLETED` và xem lại đánh giá đã gửi.
- `customer/thongBao.jsp` — trung tâm thông báo lọc theo loại.

## database

- `database/petcare.sql` — schema v2 gốc + triggers toàn vẹn + stored procedures cốt lõi.
- `database/petcare_accounts.sql` — stored procedures quản lý tài khoản & role `petcare_admin_app`.
- `database/petcare_booking_demo.sql` — thủ tục đặt lịch cơ bản & seed ban đầu.
- `database/grant_auth_permissions.sql` — cấp quyền bổ sung & tài khoản mẫu ADMIN/STAFF.
- `database/petcare_customer_features.sql` — migration tăng dần (idempotent) cho đầy đủ chức năng `CUSTOMER`: `CreatePet` (hỗ trợ `medical_notes`), `UpdatePet`, `DeletePet`, `CreateNotification`, `ListUserNotifications`, cấp quyền `SELECT`/`EXECUTE` và seed dữ liệu mẫu (dịch vụ, combo, phòng lưu trú, giờ mở cửa, kỹ năng & ca trực nhân viên).

## Kiểm thử (cập nhật 2026-11-19)

- `src/test/java/com/petcare/controllers/HomeServletTest.java` — không báo đặt lịch thành công khi chưa lưu DB.
- `src/test/java/com/petcare/services/AuthServiceTest.java` — giới hạn input, kết quả cập nhật, đổi mật khẩu khi hồ sơ không có hash.
- `src/test/java/com/petcare/filter/AuthFilterTest.java` — session cũ sau khi khóa hoặc thu hồi vai trò.
- `src/test/java/com/petcare/services/PetServiceTest.java` — kiểm tra validate thú cưng, chặn sửa/xóa thú cưng người khác hoặc đã có lịch hẹn.
- `src/test/java/com/petcare/services/BookingServiceTest.java` — xếp nối tiếp combo, chặn trùng dịch vụ/giờ, chặn phòng bảo trì, hủy lịch có lý do.
- `src/test/java/com/petcare/services/PaymentServiceTest.java` — chặn thanh toán vượt số dư, sinh `transaction_ref` cho `ONLINE`, chặn tự xác nhận `CASH`.
- `src/test/java/com/petcare/services/ReviewServiceTest.java` — giới hạn sao 1-5, nhận xét tối đa 1000 ký tự, dịch lỗi SQL 51044/2627.
- `scripts/smoke-test.ps1` — kiểm thử HTTP trên Tomcat đang chạy; có ghi dữ liệu QA, đọc `dalam.md` trước khi chạy.

## Database to model mapping

| Database table | Java model |
| --- | --- |
| Users | Users.java |
| Pets | Pets.java |
| Services | Services.java |
| Combos | Combos.java |
| ComboServices | ComboServices.java |
| StaffSkills | StaffSkills.java |
| Shifts | Shifts.java |
| BusinessHours | BusinessHours.java |
| Rooms | Rooms.java |
| Appointments | Appointments.java |
| AppointmentServices | AppointmentServices.java |
| BoardingDetails | BoardingDetails.java |
| Payments | Payments.java |
| Reviews | Reviews.java |
| Notifications | Notifications.java |

## Controllers consolidation
HomeServlet.java, LoginServlet.java and RegisterServlet.java now use com.petcare.controllers.
The singular controller package was removed. Existing servlet URL mappings are unchanged.
