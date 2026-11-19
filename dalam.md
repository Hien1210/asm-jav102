# PetCare (asm-jav102) — Tổng hợp hiện trạng dự án

## Cập nhật 2026-11-19 — Hoàn thiện đầy đủ chức năng role Khách hàng (`CUSTOMER`) & Nâng cấp giao diện Hồ sơ

### 1. Chức năng role `CUSTOMER` đã triển khai theo đầy đủ schema `database/petcare.sql`

- **Quản lý thú cưng (`/customer/thu-cung` — `QuanLyThuCungServlet`, `PetService`, `PetDAOImpl`, `customer/quanLyThuCung.jsp`)**:
  - Đầy đủ CRUD trên `dbo.Pets` gồm tất cả cột SQL: `name`, `species`, `breed`, `weight_kg` (`> 0`, `<= 999.99`), `birth_date` (không ở tương lai), `medical_notes`, `created_at`.
  - Chặn chỉnh sửa/xóa thú cưng không thuộc tài khoản đang đăng nhập và chặn xóa thú cưng đã có lịch hẹn (đếm số lịch hẹn + xử lý lỗi SQL `51062` / `547`).
- **Đặt lịch chăm sóc & lưu trú (`/customer/dat-lich` — `DatLichServlet`, `BookingService`, `AppointmentDAOImpl`, `ComboDAOImpl`, `RoomDAOImpl`, `BusinessHoursDAOImpl`, `StaffDAOImpl`, `customer/datLich.jsp`)**:
  - Giữ tương thích 100% luồng cũ (`action=addPet`, `action=book`) cho `scripts/smoke-test.ps1`.
  - Hỗ trợ đủ 4 hình thức đặt lịch theo đúng stored procedures trong `petcare.sql`:
    1. Đặt 1 dịch vụ lẻ (`dbo.BookServiceAppointment`).
    2. Đặt nhiều dịch vụ trong cùng 1 lịch hẹn (`action=bookMulti`, truyền TVP `dbo.ServiceBookingItems`, chặn trùng dịch vụ và trùng khung giờ trên cùng thú cưng).
    3. Đặt gói Combo ưu đãi (`action=bookCombo`, truyền `@combo_id`, tự động xếp khung giờ nối tiếp theo `duration_minutes` của từng dịch vụ trong `dbo.ComboServices`, đóng băng giá `combo_price_at_booking`).
    4. Đặt phòng lưu trú (`action=bookBoarding` -> `dbo.BookBoardingAppointment`, tính số đêm và ước tính giá phòng tự động, chặn phòng `MAINTENANCE` hoặc trùng ngày).
  - Hiển thị trực tiếp giờ mở cửa (`dbo.BusinessHours`) và ca trực nhân viên 7 ngày tới (`dbo.Shifts`).
- **Lịch hẹn của tôi (`/customer/lich-hen` — `LichHenKhachHangServlet`, `customer/lichHenDanhSach.jsp`)**:
  - Xem toàn bộ lịch hẹn của khách hàng với KPI tổng quan, bộ lọc theo `status` và `appointment_type` (`SERVICE` / `BOARDING`).
  - Hiển thị đầy đủ chi tiết từng dòng dịch vụ (`AppointmentServices`), chi tiết lưu trú (`BoardingDetails`), bảng giá (`subtotal`, `adjustment`, `total`, đã trả, đang chờ, còn lại), lý do hủy và đánh giá đã gửi.
  - Hủy lịch hẹn đang `PENDING` hoặc `CONFIRMED` với lý do bắt buộc qua `dbo.SetAppointmentStatus`.
- **Thanh toán hóa đơn (`/customer/thanh-toan` — `ThanhToanServlet`, `PaymentService`, `PaymentDAOImpl`, `customer/thanhToan.jsp`)**:
  - Xem danh sách lịch hẹn còn số dư (`AppointmentBalance`) và lịch sử toàn bộ giao dịch (`CHARGE` & `REFUND`) từ `dbo.Payments`.
  - Khởi tạo thanh toán `CASH` (tại quầy, trạng thái `PENDING`) hoặc `ONLINE` (tự sinh mã tham chiếu `transaction_ref` duy nhất) có khóa chống trùng `payment_key` (UUID) qua `dbo.RecordPayment`.
  - Xác nhận giao dịch `ONLINE` đang chờ (`PAID` qua `dbo.SetPaymentStatus` mô phỏng cổng thanh toán) hoặc hủy yêu cầu `PENDING` (`FAILED`) để giải phóng hạn mức. Chặn tự xác nhận `CASH` ở phía khách hàng và chặn thanh toán vượt số tiền còn lại.
- **Đánh giá dịch vụ (`/customer/danh-gia` — `DanhGiaServlet`, `ReviewService`, `ReviewDAOImpl`, `customer/danhGia.jsp`)**:
  - Liệt kê lịch hẹn `COMPLETED` chưa đánh giá, gửi đánh giá 1–5 sao + nhận xét (tối đa 1000 ký tự) qua `dbo.SubmitReview`, xem lịch sử đánh giá đã gửi.
  - Trang chủ (`HomeServlet`) nạp đánh giá thật mới nhất từ DB (fallback về dữ liệu mặc định nếu chưa có) và escape HTML an toàn (`fn:escapeXml`) trên `index.jsp`.
- **Thông báo của tôi (`/customer/thong-bao` — `ThongBaoServlet`, `NotificationService`, `NotificationDAOImpl`, `customer/thongBao.jsp`)**:
  - Lưu lịch sử thông báo (`CONFIRMATION`, `CANCELLATION`, `OTHER`) vào `dbo.Notifications` (best-effort) kết hợp đẩy toast realtime qua WebSocket `NotificationEndpoint`; hỗ trợ lọc theo loại thông báo.
- **Nâng cấp giao diện Hồ sơ người dùng (`/profile` — `ProfileServlet`, `profile.jsp`, `assets/css/profile.css`)**:
  - Nâng cấp Hero Banner (hiệu ứng ánh sáng emerald, avatar có huy hiệu xác thực, badge trạng thái hoạt động có chấm nhịp sáng, KPI kèm icon).
  - Bổ sung thanh thống kê trực tiếp cho `CUSTOMER` (số thú cưng, lịch hẹn & số lịch đang hoạt động, số tiền cần thanh toán, số đánh giá & thông báo), dải xem nhanh "Bé cưng của bạn", thanh đo độ mạnh mật khẩu & khớp mật khẩu trực tiếp khi đổi mật khẩu, và 6 thẻ tiện ích đầy đủ.
  - Cập nhật dropdown điều hướng đầy đủ cho `CUSTOMER` ở `index.jsp`, `profile.jsp`, `services.jsp` và thanh điều hướng chung `WEB-INF/includes/customerNav.jspf`.

### 2. SQL Migration & Hỗ trợ DB Local/Remote

- Tạo script migration tăng dần (idempotent, chạy lại an toàn): `database/petcare_customer_features.sql`:
  - Cập nhật/bổ sung stored procedures: `dbo.CreatePet` (thêm tham số tùy chọn `@medical_notes`), `dbo.UpdatePet`, `dbo.DeletePet`, `dbo.ListActiveStaffForService`, `dbo.CreateNotification`, `dbo.ListUserNotifications`.
  - Cấp quyền `SELECT`/`EXECUTE` đầy đủ cho `petcare_booking_app`, `petcare_payment_app`, `petcare_admin_app`, `petcare_backend`.
  - Seed dữ liệu mẫu idempotent cho `BusinessHours` (7 ngày), `Services` (6 dịch vụ), `Combos` + `ComboServices` (3 gói combo), `Rooms` (4 phòng), `StaffSkills` và `Shifts` 14 ngày tới cho nhân viên hiện có.
- Mở rộng `DBUtil.java` hỗ trợ thêm tham số `DECIMAL`/`GUID`/`DATE`/`DATETIME2` cho fallback SQL Server local (`localhost\SQLEXPRESS`) khi server remote không truy cập được; tất cả DAO role `CUSTOMER` đều hỗ trợ cả JDBC lẫn fallback local.
- **Lưu ý triển khai trên DB chung (`hung211.tail1f20d2.ts.net`)**: cần chạy thêm 1 lần `database/petcare_customer_features.sql` bằng tài khoản quản trị DB để cấp quyền `SELECT`/`EXECUTE` và tạo các thủ tục mới (`UpdatePet`, `DeletePet`, `CreateNotification`, `ListUserNotifications`) cùng seed combo/phòng (trên máy local `localhost\SQLEXPRESS` đã chạy xong 14/14 batch thành công).

### 3. Bằng chứng kiểm thử (2026-11-19)

| Nhóm | Kết quả |
| --- | --- |
| Compile toàn bộ `src/main/java` (`javac --release 17`) | **PASS** (82 file, 0 lỗi) |
| Unit tests JUnit 5 (`src/test/java`) | **21/21 PASS** (gồm 7 test cũ + 14 test mới: `PetServiceTest`, `BookingServiceTest`, `PaymentServiceTest`, `ReviewServiceTest`) |
| E2E tích hợp trên SQL Server thật (`localhost\SQLEXPRESS`) | **24/24 PASS** — đăng ký khách tạm, tải dịch vụ/combo/phòng/giờ mở cửa/ca trực, CRUD thú cưng, đặt dịch vụ lẻ/đa dịch vụ/combo/lưu trú, chặn xóa thú cưng có lịch, hủy lịch có lý do, thanh toán `CASH` -> `FAILED`, `ONLINE` -> `PAID`, chặn trả quá số dư, chặn đánh giá lịch chưa hoàn thành, hoàn thành & gửi đánh giá, chặn đánh giá trùng, lưu & lọc thông báo; đã dọn sạch dữ liệu test tạm sau khi chạy |
| Kiểm tra cân bằng thẻ JSTL trên 10 file JSP/JSPF | **10/10 PASS** |
| Trình duyệt / Tomcat thực tế & server remote | Chưa restart Tomcat và chưa chạy lại `scripts/smoke-test.ps1` trên HTTP hoặc mở Chrome kiểm tra trực quan trang `/profile` và `/customer/*`; cần build/redeploy WAR lên Tomcat để kiểm thử giao diện trực tiếp |

### 4. Chức năng còn lại chưa triển khai (role `STAFF` & `ADMIN`)

- Các module scaffold của **STAFF** (`LichLamViecServlet`, `LichHenNhanVienServlet`) và **ADMIN** (`QuanLyDichVuServlet`, `QuanLyComboServlet`, `QuanLyPhongServlet`, `QuanLyCaLamViecServlet`) vẫn đang chờ triển khai.

---

## Kết quả kiểm thử và sửa lỗi 2026-11-17 (trạng thái trước đó)

Mục này thay thế các nhận định cũ về conflict/build bên dưới. Không còn conflict marker; code compile thành công. Đã restart SmartTomcat từ IntelliJ để nạp các lớp mới và kiểm thử trên `http://localhost:8080/asm-jav102`.

### Lỗi đã sửa và kiểm chứng

- Trang admin lỗi HTTP 500: JSTL `fmt:formatDate` không nhận `LocalDateTime`. Hiển thị `createdAt.toLocalDate()`.
- Các nút đặt lịch ở trang dịch vụ/hồ sơ và JS trang chủ nay đi tới `/customer/dat-lich`. Gỡ modal demo báo thành công giả; cả GET/POST `/dat-lich` cũ chuyển về luồng đặt lịch lưu DB.
- Escape HTML tên/email/điện thoại, thông báo và giá trị form ở trang chủ, hồ sơ, login/register, admin và đặt lịch. Đã thử chuỗi có dấu `<`, `>` và script trên tài khoản QA.
- `AuthFilter` tải lại tài khoản từ DB cho khu vực bảo vệ: khóa tài khoản/thu hồi vai trò có hiệu lực cả với session đã đăng nhập. DB lỗi trả 503 thay vì dùng quyền cũ. Hồ sơ cũng loại bỏ tài khoản bị khóa.
- `AuthService` không báo lưu hồ sơ/đổi mật khẩu thành công nếu DAO trả false; chặn tên dài hơn schema 100 ký tự.
- Admin kiểm tra email/SĐT trùng, chuẩn hóa dữ liệu, kiểm tra tài khoản tồn tại trước khi sửa và báo rõ ràng các ràng buộc DB (chủ thú cưng phải là CUSTOMER, nhân viên có ca/kỹ năng phải là STAFF, không khóa khách đang có lịch chưa kết thúc).
- Đặt lịch kiểm tra action, chiều dài dữ liệu thú cưng và dùng giờ Việt Nam khi chặn lịch quá khứ.
- Lỗi mapper thiếu `password_hash` ở phần cập nhật trước tiếp tục được xác minh qua hồ sơ và đổi mật khẩu thật bằng tài khoản QA.

### Bằng chứng kiểm thử

| Nhóm | Kết quả |
| --- | --- |
| HTTP trên Tomcat thật | **52/52 PASS**, gồm trang công khai, đăng ký, login email/SĐT, sai mật khẩu, hồ sơ, escape HTML, phân quyền, thú cưng, đặt lịch, trùng giờ/sai chủ/ngoài ca/quá khứ, admin tạo/sửa/khóa/mở/reset mật khẩu, đổi mật khẩu và logout |
| Unit/regression JUnit | **7/7 PASS**, đã quan sát test fail trước khi sửa (đặt lịch giả, tên quá dài, lưu thất bại nhưng báo thành công, session quyền cũ) |
| WebSocket | Có session đăng nhập: Open; không có session: server gửi Close |
| UI | Đã quan sát trang chủ/hồ sơ/dịch vụ bằng Chrome và restart Tomcat từ IntelliJ. Lần kiểm tra cuối bị công cụ CUA chặn vì không đọc chắc URL; không coi là đã test mọi thao tác UI |

Test tái sử dụng: `scripts/smoke-test.ps1`. Truyền `-AdminEmail` / `-AdminPassword` hoặc biến môi trường `PETCARE_QA_ADMIN_EMAIL` / `PETCARE_QA_ADMIN_PASSWORD` để kiểm tra admin. Script ghi dữ liệu QA trên DB thật, không dùng tài khoản cá nhân. Kết quả máy hiện tại ở `target/qa-smoke-results.json` (gitignore).

Tài khoản test: `qa-smoke-20261117@petcare.test`, `qa-admin-target-20261117@petcare.test`; 1 thú cưng QA và lịch hẹn test **#5, 18/11/2026 11:15** được giữ lại. Tài khoản đích admin đã được trả về CUSTOMER, hoạt động, mật khẩu QA ban đầu sau kiểm thử. Script lưu slot trong `target/qa-booking-state.json` để chạy lại không tạo thêm lịch cùng đợt.

Build/test trên máy này dùng Maven đi kèm IntelliJ:

```powershell
& 'F:/IntelliJ IDEA 2026.2/plugins/maven-plugin/lib/maven3/bin/mvn.cmd' '-Dmaven.repo.local=C:/Users/ADMIN/.m2/repository' test-compile
& 'F:/IntelliJ IDEA 2026.2/plugins/maven-plugin/lib/maven3/bin/mvn.cmd' '-Dmaven.repo.local=C:/Users/ADMIN/.m2/repository' org.apache.maven.plugins:maven-surefire-plugin:3.5.6:test
```

Surefire 3.5.4 mặc định bị treo tải provider trên máy trong lần chạy này; đã dùng 3.5.6 có sẵn để chạy đủ test, không sửa phiên bản dependency của project.

### Chức năng chưa triển khai (không đánh dấu PASS)

Thanh toán còn thiếu Service/Servlet/JSP; chỉ có model/DAO. Lịch hẹn khách hàng/nhân viên, quản lý thú cưng đầy đủ, quản lý ca/dịch vụ/combo/phòng và đánh giá còn scaffold. Những trang này chưa có nghiệp vụ để kiểm thử hoàn chỉnh; chưa tích hợp cổng thanh toán. Giá marketing trang chủ/dịch vụ vẫn là dữ liệu tĩnh, chưa đồng bộ DB.

Chưa commit/push các thay đổi của đợt kiểm thử này.

## Cập nhật 2026-11-17: hồ sơ báo thiếu password_hash

- `GetAccountById` và `ListAccounts` trong `petcare_accounts.sql` chủ động không trả `password_hash`; mapper sau merge lại luôn đọc cột này nên trang `/profile` báo lỗi.
- Sửa mapper JDBC chấp nhận kết quả không có hash, sửa mapper local tương thích cả 7 cột hồ sơ và 8 cột xác thực. Đổi mật khẩu lấy hash qua `findByIdentifier` và đối chiếu user ID trước khi xác minh mật khẩu hiện tại. Không cần thay đổi schema hay chạy lại SQL.

## Cập nhật 2026-11-17: lỗi kết nối khi đăng ký

- Tái hiện bằng `DatabaseConnectionTest`: cấu hình resource mặc định gây `UnrecoverableKeyException` (mật khẩu truststore không khớp), sau đó DAO/test chuyển sang SQL Server local qua Windows Authentication. Đây là lý do có thể thấy lỗi login Windows như `MSI\Admin` thay vì tài khoản SQL của server chung.
- Chạy cùng test với `-Dpetcare.config=F:/asm-jav102/application-local.properties` kết nối JDBC thành công tới `PetCare`, đọc được 6 tài khoản; chỉ kiểm tra đọc dữ liệu.
- `ConfigUtil` nay tự đọc `application-local.properties` trong thư mục làm việc nếu không chỉ định `-Dpetcare.config`. File này đã được gitignore. Tham số `-Dpetcare.config` vẫn được ưu tiên.
- Với Tomcat có thư mục làm việc khác, thêm VM option `-Dpetcare.config=F:/asm-jav102/application-local.properties`, build/deploy lại và restart Tomcat. Không cần tạo DB local hay cấp quyền cho tài khoản Windows để dùng DB chung.

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

- Kiểm chứng: compile các lớp liên quan thành công; test chỉ đọc trên DB thật tải danh sách và hồ sơ từng tài khoản: PASS (9 tài khoản). Chưa xác minh qua trình duyệt hoặc ghi đổi mật khẩu.

## Kiểm tra Chrome qua điều khiển máy (2026-11-17)
- Đã quan sát trang chủ và mở trang đăng nhập tại http://localhost:8080/asm-jav102/login thành công.
- Chưa hoàn tất đăng nhập hoặc kiểm tra profile: công cụ phát hiện thao tác người dùng cùng cửa sổ nên dừng thao tác tự động. Chưa ghi dữ liệu ứng dụng trong lần kiểm tra này.

## Kết quả kiểm tra giao diện Chrome (2026-11-17)
- Đã điều khiển Chrome mở /profile với phiên CUSTOMER đang đăng nhập: trang tải đủ thông tin và không còn thông báo lỗi password_hash.
- Trang /services.jsp tải được nhưng các liên kết Đặt lịch vẫn trỏ /login, nút Đặt lịch chăm sóc ngay trỏ /register dù phiên đã đăng nhập; cần nối về luồng đặt lịch thật.
- Chỉ kiểm tra điều hướng và hiển thị; chưa submit sửa hồ sơ, đổi mật khẩu, đặt lịch hoặc thanh toán qua UI.
