# PetCare (asm-jav102) — Tổng hợp hiện trạng dự án

Ghi lại ngày 2026-11-16, sau khi đọc lại toàn bộ source hiện tại trên nhánh `GiaHung`.
Đây là bản ghi hiện trạng thực tế (đã đọc code, không suy đoán), để cả nhóm dùng làm mốc đối chiếu.

**Cập nhật:** đã resolve xong 8 file conflict ở mục 2 (chọn bản "bao" làm nền vì nhiều tính năng hơn và đã có code khác phụ thuộc vào nó — `ProfileServlet`, `AuthFilter`), đồng bộ lại `QuanLyTaiKhoanServlet`/`DatLichServlet` theo API mới, sửa package `ProfileServlet`, và hoàn thiện `PaymentDAOImpl` (đang dở từ trước, chặn build). **`javac` toàn bộ `src/main/java` đã chạy sạch, không còn lỗi.** Phần "Vấn đề nghiêm trọng" dưới đây giữ lại để làm lịch sử — nay đã xử lý.

## 1. Tổng quan

- Ứng dụng web Java (Jakarta Servlet 6 + JSP + JSTL), build bằng Maven, deploy dạng WAR lên servlet container (Tomcat).
- Chủ đề: hệ thống đặt lịch chăm sóc thú cưng (PetCare) — khách hàng, nhân viên, quản trị viên.
- Database: SQL Server, tên DB `PetCare`, host `hung211.tail1f20d2.ts.net:1433` (qua Tailscale), kết nối bằng JDBC driver `mssql-jdbc`.
- Nhiều thành viên cùng code trên các nhánh riêng (`hung`/`GiaHung`, `bao`/`PhungBao`, `Chitien`, `Thanhhien`) rồi merge qua lại. Lịch sử commit gần đây có nhiều message không rõ nghĩa (`.`, `l`, `ádas`, `fgf`, `đâ`...) — dấu hiệu merge/commit vội.

## 2. ⚠️ VẤN ĐỀ NGHIÊM TRỌNG — Code hiện tại KHÔNG BUILD ĐƯỢC

Commit mới nhất (`7c002eb`, tác giả `hungpgty00316`) có **conflict marker merge chưa resolve** còn nằm trong code đã commit (không phải lỗi working-tree, đã nằm trong HEAD). 8 file bị ảnh hưởng:

- `src/main/java/com/petcare/models/Users.java`
- `src/main/java/com/petcare/services/AuthService.java`
- `src/main/java/com/petcare/daos/AccountDAO.java`
- `src/main/java/com/petcare/daos/AccountDAOImpl.java`
- `src/main/java/com/petcare/utils/SessionUtil.java`
- `src/main/java/com/petcare/utils/ValidationUtil.java`
- `src/main/java/com/petcare/controllers/LoginServlet.java`
- `src/main/java/com/petcare/controllers/RegisterServlet.java`

Mỗi file còn nguyên `<<<<<<< HEAD` / `=======` / `>>>>>>> bao` — đây là merge giữa bản của "hung" (nhánh GiaHung, cũ hơn/đơn giản hơn) và bản của "bao" (mới hơn, nhiều tính năng hơn: chuẩn hoá số điện thoại, đổi mật khẩu, cập nhật hồ sơ...). **Cần resolve conflict trước khi làm gì khác** — hiện tại `mvn compile` sẽ fail ngay ở các file này.

→ Khuyến nghị: giữ bản của "bao" làm nền (nhiều chức năng hơn: `registerCustomer`, `updateProfile`, `changePassword`, chuẩn hoá SĐT/email, hằng số `ROLE_CUSTOMER/STAFF/ADMIN`...), rồi merge thêm những phần bên "hung" chưa có (ví dụ `findByIdentifierWithPasswordHash` dùng cho login qua bcrypt — cần kiểm tra bản "bao" đã có tương đương hay chưa trước khi xoá).

## 3. Vấn đề khác cần lưu ý

- **`ProfileServlet.java`** (file mới, 117 dòng) khai báo `package com.petcare.controller;` (số ít) nhưng vật lý nằm ở thư mục `controllers/` (số nhiều). Không khớp package/thư mục — dễ gây nhầm lẫn, nên đổi lại cho nhất quán.
- **Hai hệ thống cấp quyền DB chồng chéo nhau** trong thư mục `database/`:
  - `petcare_accounts.sql` + `petcare_booking_demo.sql` (do phiên làm việc trước của tôi tạo) — theo mô hình "chỉ ghi qua stored procedure", role riêng `petcare_admin_app`.
  - `grant_auth_permissions.sql` (file mới, không rõ ai thêm) — làm ngược lại: `REVOKE` DENY trên `petcare_booking_app`/`petcare_payment_app`, rồi **GRANT trực tiếp INSERT/UPDATE trên bảng `Users`, `Pets`** cho các role đó và cho login `petcare_backend`. Đồng thời tạo lại gần như toàn bộ stored procedure quản lý tài khoản (trùng với `petcare_accounts.sql`) và tự seed 2 tài khoản mẫu `admin@petcare.vn` / `staff@petcare.vn`.
  - Hai cách này **triết lý bảo mật khác nhau** (chặn ghi trực tiếp vs cho ghi trực tiếp). Cần nhóm thống nhất chọn 1 hướng, nếu không DB sẽ ở trạng thái quyền lộn xộn tuỳ ai chạy script nào sau cùng.
- **`DBUtil.java`** đã được mở rộng rất nhiều (329 dòng, trước đây ~50 dòng): thêm "circuit breaker" khi mất kết nối TCP, và một **cơ chế fallback lạ** — khi cần, nó tạo ra một script PowerShell (mã hoá base64) để gọi `System.Data.SqlClient.SqlConnection` kết nối tới **SQL Server cài local** (`localhost\SQLEXPRESS`) khi không nối được server từ xa. Đây là cách làm khá bất thường (Java shell-out ra PowerShell để chạy SQL) — nên cả nhóm xác nhận có thật sự cần không, vì nó làm tăng bề mặt lỗi/bảo trì.

## 4. Tiến độ theo module (đọc trực tiếp từ code, dòng lệnh = ước lượng độ hoàn thiện)

| Module | Trạng thái | Ghi chú |
| --- | --- | --- |
| Kết nối DB (`DBUtil`, `ConfigUtil`) | ✅ Xong | Đã test kết nối SQL Server thật thành công (phiên trước). |
| Đăng nhập / Đăng ký (`LoginServlet`, `RegisterServlet`, `AuthService`) | ⚠️ Đang conflict | Logic đã viết đầy đủ ở cả 2 bản (hung & bao), nhưng **chưa resolve merge** nên không chạy được ngay. |
| Quản lý tài khoản — Admin (`QuanLyTaiKhoanServlet`, `AccountDAO`) | ⚠️ Đang conflict (AccountDAO/Impl) | Servlet (199 dòng) không nằm trong danh sách conflict, nhưng DAO nó gọi thì có — cần resolve DAO trước khi test lại. |
| Đặt lịch (`DatLichServlet`, `BookingService`, `AppointmentDAO`, `PetDAO`, `ServiceDAO`, `StaffDAO`) | ✅ Đã viết & test pass trên DB thật | Không bị conflict. Dùng stored procedure có sẵn `BookServiceAppointment`. |
| Hồ sơ cá nhân (`ProfileServlet`, `profile.jsp`) | 🆕 Mới (của "bao") | Chưa review kỹ, có vấn đề package (mục 3). |
| Đăng xuất (`DangXuatServlet`) | ✅ Xong | Dùng `SessionUtil.clearSession`. |
| Thanh toán (`ThanhToanServlet`, `PaymentDAO`, `PaymentService`) | 🚧 Đang làm (bị dừng giữa đường) | Đã có: model `Payments`, `AppointmentBalance`, interface `PaymentDAO` (24 dòng). **Chưa có**: `PaymentDAOImpl`, `PaymentService`, `ThanhToanServlet`, JSP. Stored procedure `RecordPayment`/`SetPaymentStatus` đã có sẵn trong `petcare.sql`, role `petcare_payment_app` đã gán cho `petcare_backend` — không cần thêm SQL mới cho phần core, chỉ cần viết code Java. |
| Lịch hẹn (khách hàng/nhân viên), Quản lý thú cưng, Combo, Dịch vụ, Phòng, Ca làm việc, Đánh giá | ❌ Chưa làm | Toàn bộ servlet/DAO liên quan vẫn là scaffold trống (`"Scaffold only..."`), ví dụ `LichHenKhachHangServlet`, `QuanLyThuCungServlet`, `QuanLyComboServlet`, `QuanLyDichVuServlet`, `QuanLyPhongServlet`, `QuanLyCaLamViecServlet`, `DanhGiaServlet`, `LichLamViecServlet`, `LichHenNhanVienServlet`. |

## 5. Trạng thái Database thật (đã xác minh bằng kết nối trực tiếp, phiên trước)

- Đã có dữ liệu mẫu: 1 dịch vụ ("Grooming & Tắm sấy"), giờ mở cửa đủ 7 ngày, 1 nhân viên demo + kỹ năng + ca làm việc 14 ngày tới (từ `petcare_booking_demo.sql`), cộng thêm tài khoản `admin@petcare.vn` / `staff@petcare.vn` (từ `grant_auth_permissions.sql`), và vài tài khoản/lịch hẹn test do tôi tạo khi kiểm thử (`e2e-test-admin@petcare.vn`, `e2e-customer@petcare.vn`...).
- Các stored procedure cốt lõi cho Booking & Payment (`BookServiceAppointment`, `BookBoardingAppointment`, `SetAppointmentStatus`, `RecordPayment`, `SetPaymentStatus`, `SubmitReview`) đã có sẵn từ đầu trong `petcare.sql`, có trigger kiểm tra tính toàn vẹn rất chặt (trùng giờ nhân viên/thú cưng, đúng ca làm việc, đúng giờ mở cửa, số tiền thanh toán không vượt tổng hoá đơn...).

## 6. Việc cần làm tiếp (đề xuất thứ tự)

1. **Resolve 8 file conflict ở mục 2** — bắt buộc trước tiên, nếu không code không build được.
2. Thống nhất lại 1 trong 2 hướng cấp quyền DB (mục 3), xoá/gộp file SQL còn lại để tránh nhầm.
3. Sửa package của `ProfileServlet.java` cho khớp thư mục.
4. Hoàn thiện module Thanh toán (`PaymentDAOImpl`, `PaymentService`, `ThanhToanServlet`, JSP) — đang làm dở.
5. Các module còn ❌ chưa làm ở mục 4, ưu tiên theo nhu cầu nhóm (gợi ý: Lịch hẹn khách hàng/nhân viên nên làm sớm vì Đặt lịch & Thanh toán đều cần nó để khách xem lại).
