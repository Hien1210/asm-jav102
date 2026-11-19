# PetCare Java structure

## config


## controllers

- DangKyServlet.java
- DangNhapServlet.java
- DangXuatServlet.java
- DanhGiaServlet.java
- DatLichServlet.java
- LichHenKhachHangServlet.java
- LichHenNhanVienServlet.java
- LichLamViecServlet.java
- QuanLyCaLamViecServlet.java
- QuanLyComboServlet.java
- QuanLyDichVuServlet.java
- QuanLyPhongServlet.java
- QuanLyTaiKhoanServlet.java
- QuanLyThuCungServlet.java
- ThanhToanServlet.java
- TrangChuServlet.java

## daos

- AccountDAO.java
- AccountDAOImpl.java
- AppointmentDAO.java
- AppointmentDAOImpl.java
- ComboDAO.java
- ComboDAOImpl.java
- PaymentDAO.java
- PaymentDAOImpl.java
- PetDAO.java
- PetDAOImpl.java
- ReviewDAO.java
- ReviewDAOImpl.java
- RoomDAO.java
- RoomDAOImpl.java
- ServiceDAO.java
- ServiceDAOImpl.java
- StaffDAO.java
- StaffDAOImpl.java

## filter

- AuthFilter.java — xác minh trạng thái/vai trò hiện tại từ DB trước khi truy cập khu vực bảo vệ.
- package-info.java

## listener

- package-info.java

## models

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
- Services.java
- Shifts.java
- StaffSkills.java
- Users.java

## services

- AuthService.java
- BookingService.java
- PaymentService.java

## utils

- ConfigUtil.java
- DateUtil.java
- DBUtil.java
- SessionUtil.java
- ValidationUtil.java

## websocket

- HttpSessionConfigurator.java
- NotificationEndpoint.java
- package-info.java

## Kiểm thử (cập nhật 2026-11-17)

- `src/test/java/com/petcare/controllers/HomeServletTest.java` — không báo đặt lịch thành công khi chưa lưu DB.
- `src/test/java/com/petcare/services/AuthServiceTest.java` — giới hạn input, kết quả cập nhật, đổi mật khẩu khi hồ sơ không có hash.
- `src/test/java/com/petcare/filter/AuthFilterTest.java` — session cũ sau khi khóa hoặc thu hồi vai trò.
- `scripts/smoke-test.ps1` — kiểm thử HTTP trên Tomcat đang chạy; có ghi dữ liệu QA, đọc `dalam.md` trước khi chạy.
- Luồng đặt lịch thật: `/customer/dat-lich`; `/dat-lich` cũ chỉ redirect. Thanh toán và các module scaffold chưa được triển khai hoàn chỉnh.

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
