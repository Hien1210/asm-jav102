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
- QuenMatKhauServlet.java (`/quen-mat-khau`) — yêu cầu đặt lại mật khẩu, gửi link qua email (Gmail SMTP), phản hồi chung chung chống dò định danh.
- DatLaiMatKhauServlet.java (`/dat-lai-mat-khau`) — xác thực token từ email, đặt mật khẩu mới.
- XacThucEmailServlet.java (`/xac-thuc-email`) — tiêu thụ token xác thực email gửi lúc đăng ký, redirect về `/login` kèm thông báo.
- ProfileServlet.java (`/profile`, `/ho-so`) — hồ sơ cá nhân, đổi mật khẩu và thống kê tổng quan cho khách hàng (số thú cưng, lịch hẹn, công nợ, đánh giá, thông báo).
- QuanLyCaLamViecServlet.java
- QuanLyComboServlet.java
- QuanLyDichVuServlet.java
- QuanLyPhongServlet.java
- QuanLyTaiKhoanServlet.java (`/admin/tai-khoan`)
- QuanLyThuCungServlet.java (`/customer/thu-cung`) — CRUD đầy đủ thú cưng của khách hàng (tên, loài, giống, cân nặng, ngày sinh, ghi chú sức khỏe).
- RegisterServlet.java
- ThanhToanServlet.java (`/customer/thanh-toan`) — xem hóa đơn còn nợ, khởi tạo thanh toán `CASH`/`ONLINE` idempotent (`dbo.RecordPayment`), xác nhận giao dịch `ONLINE` (`PAID`) hoặc hủy yêu cầu `PENDING` (`FAILED`) qua `dbo.SetPaymentStatus`, lịch sử giao dịch & hoàn tiền.
- ThuTienMatServlet.java (`/staff/thu-tien`) — tra khoản tiền mặt chờ thu theo mã lịch và xác nhận qua `dbo.ConfirmCounterCash` trong `database/petcare_counter_cash.sql`.
- ThongBaoServlet.java (`/customer/thong-bao`) — lịch sử thông báo của khách hàng theo loại (`dbo.Notifications`).
- TrangChuServlet.java

## daos

- AccountDAO.java / AccountDAOImpl.java
- AppointmentDAO.java / AppointmentDAOImpl.java — đặt dịch vụ đơn/đa dịch vụ/combo, đặt phòng lưu trú, tra cứu lịch hẹn kèm chi tiết, hủy lịch.
- BusinessHoursDAO.java / BusinessHoursDAOImpl.java — tải khung giờ mở cửa `dbo.BusinessHours`.
- ComboDAO.java / ComboDAOImpl.java — tải các gói combo đang hoạt động kèm danh sách dịch vụ thành phần.
- NotificationDAO.java / NotificationDAOImpl.java — lưu và tra cứu `dbo.Notifications`.
- PasswordResetDAO.java / PasswordResetDAOImpl.java — tạo/kiểm tra token đặt lại mật khẩu (`dbo.PasswordResetTokens`, hash SHA-256, hết hạn, dùng 1 lần).
- EmailVerificationDAO.java / EmailVerificationDAOImpl.java — tạo/kiểm tra token xác thực email khi đăng ký (`dbo.EmailVerificationTokens`). `hasPendingVerification` không bao giờ throw (fail-open nếu DB/migration chưa sẵn sàng).
- PaymentDAO.java / PaymentDAOImpl.java — hóa đơn cần thanh toán, lịch sử thanh toán khách hàng, `dbo.RecordPayment`, `dbo.SetPaymentStatus`.
- PetDAO.java / PetDAOImpl.java — CRUD đầy đủ `dbo.Pets` (`CreatePet`, `UpdatePet`, `DeletePet` kèm fallback).
- ReviewDAO.java / ReviewDAOImpl.java — `dbo.SubmitReview`, danh sách lịch hoàn thành chưa đánh giá, đánh giá của khách và đánh giá công khai mới nhất.
- RoomDAO.java / RoomDAOImpl.java — danh sách phòng mở đặt và phòng trống theo khoảng ngày.
- ServiceDAO.java / ServiceDAOImpl.java
- StaffDAO.java / StaffDAOImpl.java — nhân viên có kỹ năng theo dịch vụ và ca trực sắp tới `dbo.Shifts`.

## filter

- AuthFilter.java — xác minh trạng thái/vai trò hiện tại từ DB trước khi truy cập khu vực bảo vệ.
- StaffHomeRedirectFilter.java — chuyển phiên STAFF từ `/home`, `/trang-chu`, `/index.jsp` về `/staff/lich-hen`.
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

- AuthService.java — đăng ký/đăng nhập/đổi hồ sơ/đổi mật khẩu; `requestPasswordReset`/`resetPasswordWithToken` gửi email đặt lại mật khẩu qua Gmail SMTP (token 1 lần, hết hạn 15 phút). `registerCustomer` gửi email xác thực (hết hạn 24 giờ, gửi trước-lưu token sau để tránh khoá tài khoản khi mail lỗi); `authenticate` chặn đăng nhập khi còn token xác thực chưa dùng.
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
- MailUtil.java — gửi email qua Gmail SMTP (Jakarta Mail), cấu hình qua `mail.smtp.*` trong `ConfigUtil`.
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
- `database/petcare_password_reset.sql` — bảng `dbo.PasswordResetTokens` + `CreatePasswordResetToken`/`ConsumePasswordResetToken` cho tính năng quên mật khẩu qua email. **Đã áp dụng DB chính.**
- `database/petcare_email_verification.sql` — bảng `dbo.EmailVerificationTokens` + `CreateEmailVerificationToken`/`ConsumeEmailVerificationToken` cho xác thực email khi đăng ký. Chưa áp dụng DB chính (chờ duyệt).

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

## Quản lý tài khoản (2026-11-19)

- `QuanLyTaiKhoanServlet` kiểm tra CSRF trên POST, trạng thái true/false, ID dương và tài khoản đích reset mật khẩu.
- `src/test/java/com/petcare/controllers/QuanLyTaiKhoanServletTest.java` — 9 test quản trị tài khoản, dùng DAO giả.
- `admin/quanLiTaiKhoan.jsp` gửi token theo session; `scripts/smoke-test.ps1` lấy token trước POST quản trị.

## Các trang admin hoàn chỉnh trong source (2026-11-19)

- `services/AdminModule.java`: định nghĩa và validation dịch vụ/combo/phòng/ca/thú cưng.
- `daos/AdminCatalogDAO.java`: đọc danh sách/chi tiết, gọi procedure ghi và transaction combo.
- `controllers/AdminCatalogServlet.java` và 5 `QuanLy*Servlet`: `/admin/dich-vu`, `/admin/combo`, `/admin/phong`, `/admin/ca-lam-viec`, `/admin/thu-cung`.
- `WEB-INF/views/admin/catalog.jsp`, `assets/css/admin.css`, `assets/js/admin.js`: giao diện quản trị chung; JSP admin cũ redirect.
- `database/admin_catalog.sql`: migration 11 procedure + quyền EXECUTE/SELECT cho role admin, chưa áp dụng DB chính (chờ duyệt).
- `scripts/test-admin.ps1`, `scripts/test-admin-accounts.ps1`: test HTTP trên QA. Test JUnit mới: AdminModuleTest, AdminCatalogServletTest, AdminCatalogIntegrationTest (opt-in).
- Chi tiết phạm vi, triển khai và kết quả: `docs/ADMIN.md`. 27/27 JUnit và 82/82 HTTP PASS trên database QA riêng.

## Giao diện admin đồng bộ (2026-11-19)

- Bố cục 6 trang dùng `WEB-INF/views/admin/shell-start.jspf`, `shell-end.jspf` và thanh tìm kiếm/bộ lọc `table-tools.jspf`.
- `admin/quanLiTaiKhoan.jsp` dùng chung `admin.css`/`admin.js` với `catalog.jsp`; sidebar, breadcrumb, bộ lọc/tìm không dấu, form có label và bảng responsive.
- Chi tiết kiểm thử desktop/mobile, ảnh preview và giới hạn: `docs/ADMIN_UI.md`. Không thêm dependency, không đổi luồng ghi DB.

## Bảo vệ quản trị viên (2026-11-19)

- `QuanLyTaiKhoanServlet` chặn chỉnh sửa/khóa/reset tài khoản ADMIN trong trang quản lý; UI hiển thị badge bảo vệ và liên kết hồ sơ của chính mình.
- `AccountDAO`/`AccountDAOImpl`: các hàm quản lý `updateManagedProfile`, `setManagedActive`, `resetManagedPassword` xác minh actor/target và ghi trong cùng transaction; luồng hồ sơ cá nhân giữ riêng.
- `src/test/java/com/petcare/daos/AccountAdminProtectionTest.java`: 11 test DAO/JDBC giả cho quyền, race, rollback và fallback; Servlet có 13 test. Không có migration mới.

## Lịch hẹn và báo cáo admin (2026-11-19)

- `controllers/AdminOperationsServlet.java`: `/admin/lich-hen` (GET + POST trạng thái) và `/admin/bao-cao` (GET HTML/CSV), ADMIN/CSRF.
- `daos/AdminOperationsDAO.java`: danh sách phân trang, chi tiết dịch vụ/lưu trú/giao dịch, cập nhật qua SetAppointmentStatus có khóa kiểm tra trạng thái, SQL báo cáo không nhân tiền theo dòng dịch vụ.
- `services/AdminOperationsPolicy.java`, `models/AdminReport.java`: khoảng ngày, state machine, tổng thực thu và CSV.
- `WEB-INF/views/admin/appointments.jsp`, `reports.jsp`, `operations-filters.jspf`; menu chung thêm 2 trang. QuanLyThuCungServlet nối lại module PETS sau khi phát hiện scaffold.
- Test mới: AdminOperationsPolicyTest, AdminReportTest, AdminOperationsServletTest, AdminOperationsIntegrationTest (opt-in QA). Fixture src/test/resources/admin-operations-fixture.sql và scripts/test-admin-operations.ps1.
- Phạm vi/định nghĩa chỉ số/kết quả và điều kiện chạy lại: docs/ADMIN_OPERATIONS.md.

## Staff UI — 19/11/2026
- Controller routes: /staff/lich-hen, /staff/lich-lam-viec, /staff/dat-lich-tai-quay.
- Protected JSPs: src/main/webapp/WEB-INF/views/staff; common header: WEB-INF/includes/staffHeader.jspf; assets: assets/css/staff.css, assets/js/staff.js.
- StaffCsrfFilter guards staff POST forms. Legacy staff JSPs redirect to controllers.
- Verification and limitations: docs/STAFF_UI_REVIEW.md.

## Sửa chuyển trang sau đăng nhập STAFF — 19/11/2026
- Nguyên nhân: LoginServlet chỉ phân nhánh ADMIN; STAFF bị chuyển về /home.
- Đã thêm nhánh STAFF sang /staff/lich-hen, giữ ADMIN và CUSTOMER như cũ.
- Test hồi quy tái hiện lỗi trước sửa; sau sửa 3 test LoginServlet đạt. Toàn suite: 82 test, 79 đạt, 3 tích hợp bỏ qua; WAR build thành công.
- Bản đóng gói: target/petcare.war. Cần nạp lại artifact/redeploy trên Tomcat đang dùng để nhận mã mới.

## Làm lại giao diện staff — 19/11/2026
- Sidebar navy/vàng, menu mobile 4 mục; header/breadcrumb và hồ sơ chung trong staffHeader.jspf.
- Ba protected JSP staff dùng staff.css mới: lịch hẹn có tổng quan lượt dịch vụ, khung giờ/tên bé/thao tác; lịch làm việc có bảng ca; tại quầy có ba bước và thẻ thú cưng.
- Preview riêng không DB: 9 trạng thái render HTTP đạt, ba trang tại 320/768/1024px không tràn; đã quan sát 1440px và 390px, thử menu bàn phím và form ONLINE. Maven 82 test: 79 đạt, 3 tích hợp bỏ qua; build WAR đạt.
- Chi tiết thiết kế và ảnh: docs/STAFF_UI_DESIGN.md. Không đổi controller/DAO hoặc deploy server chính.

## Quên mật khẩu qua Gmail SMTP — 20/11/2026
- Thêm Jakarta Mail (`jakarta.mail-api` 2.1.3 + `angus-mail` 2.0.3) vào `pom.xml`; cấu hình `mail.smtp.*` qua `ConfigUtil` (placeholder trong `application.properties`, giá trị thật trong `application-local.properties` git-ignored).
- `QuenMatKhauServlet` (`/quen-mat-khau`), `DatLaiMatKhauServlet` (`/dat-lai-mat-khau`), `quenMatKhau.jsp`, `datLaiMatKhau.jsp`; link "Quên mật khẩu?" trên `login.jsp` đã nối đúng (trước đó trỏ về chính nó).
- `AuthService.requestPasswordReset`/`resetPasswordWithToken`, `PasswordResetDAO`/`PasswordResetDAOImpl`, `MailUtil`; token SHA-256, hết hạn 15 phút, dùng 1 lần. `database/petcare_password_reset.sql` (đã áp dụng DB chính 20/11/2026).
- Test mới: 5 test trong `AuthServiceTest` (mail sender giả, không gọi mạng thật). Maven 87 test: 84 đạt, 3 tích hợp bỏ qua; build WAR đạt.
- Chi tiết và giới hạn đã biết: docs/PASSWORD_RESET.md.

## Xác thực email khi đăng ký — 20/11/2026
- `registerCustomer` gửi email xác thực sau khi tạo tài khoản (không đổi `is_active`/procedure cũ); gửi mail trước, chỉ lưu token nếu gửi thành công — tránh khoá tài khoản vĩnh viễn khi Gmail SMTP lỗi.
- `AuthService.authenticate` chặn đăng nhập khi còn token xác thực chưa dùng/chưa hết hạn (24 giờ); `XacThucEmailServlet` (`/xac-thuc-email`) tiêu thụ token, redirect về `/login` (tái dùng alert có sẵn, không JSP mới).
- `EmailVerificationDAO`/`EmailVerificationDAOImpl`, `database/petcare_email_verification.sql` (bảng + 2 procedure độc lập, không đụng `Users`/procedure cũ; chưa áp dụng DB chính). `hasPendingVerification` fail-open (không throw) nếu DB/migration chưa sẵn sàng.
- Test mới: 6 test trong `AuthServiceTest`. Maven 93 test: 90 đạt, 3 tích hợp bỏ qua; build WAR đạt.
- Chi tiết và giới hạn đã biết: docs/EMAIL_VERIFICATION.md.
