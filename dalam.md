# PetCare (asm-jav102) — Tổng hợp hiện trạng dự án

## Thống kê CRUD toàn hệ thống — 26/11/2026

- Có 5 bảng nghiệp vụ với đủ thao tác thêm, đọc, sửa và xóa bản ghi qua chức năng web: `Services`, `Combos`, `Rooms`, `Shifts`, `Pets`.
- Tính cả bảng liên kết được quản lý khi sửa combo thì có 6 bảng nghiệp vụ. `ComboServices` lưu thay đổi danh sách dịch vụ bằng cách xóa liên kết cũ và thêm liên kết mới.
- Hai bảng token đặt lại mật khẩu và xác thực email có vòng đời tạo, đọc, cập nhật và dọn token tự động. Các bảng này thuộc luồng kỹ thuật xác thực.

## Review bản cập nhật GiaHung — 25/11/2026

- Phạm vi review là các thay đổi của merge `91ade6f` so với parent thứ nhất. Maven có 101 test đạt và 3 test tích hợp bỏ qua, build WAR thành công. Kiểm tra cú pháp JavaScript trình sửa ảnh đạt.
- Các điểm cần sửa ở `/profile/media`: bổ sung CSRF cho upload và xóa ảnh, trả thông báo chung thay cho chi tiết lỗi SQL/Cloudinary, và xử lý cập nhật đồng thời để dọn ảnh thực sự bị thay thế.
- Review chưa chạy luồng upload trên trình duyệt, SQL Server hoặc Cloudinary thật.

## Đổi giao diện khu vực nhân viên cho khác khách hàng 2026-11-19

Theo yêu cầu: giao diện nhân viên phải khác khách hàng để dễ phân biệt. Chưa commit.

- 3 trang `/staff/*` (`datLichTaiQuay.jsp`, `lichLamViec.jsp`, `quanLyLichHen.jsp`): đổi topbar + nút chính từ xanh ngọc `#0f766e` (trùng màu các trang khách hàng `customer/*` và trang chủ) sang **xanh indigo `#1e3a8a`**, thêm badge "KHU VỰC NHÂN VIÊN" cạnh logo PetCare trên topbar.
- `index.jsp` (trang chủ dùng chung mọi vai trò): nhãn vai trò "Nhân viên" trong dropdown tài khoản đổi màu chữ sang cùng tông indigo (`.header-user-role-tag-staff` trong `home.css`) thay vì xanh lá mặc định — để ngay từ trang chủ cũng phân biệt được đang đăng nhập vai trò gì.
- **Lưu ý kỹ thuật đã gặp khi test**: `index.jsp` có cache-bust `?v=15` cho `home.css`; đổi CSS mà không tăng số này thì trình duyệt vẫn dùng bản cache cũ (gặp đúng lỗi này khi test, nhìn mãi vẫn thấy màu cũ dù file đã sửa đúng) — đã tăng lên `?v=16`. **Lần sau sửa `home.css`, nhớ tăng số version này** nếu không sẽ thấy "không có gì đổi" dù code đã đúng.
- Test qua UI thật (`staff.demo@petcare.vn`): xác nhận bằng `getComputedStyle` lẫn mắt thường — topbar 3 trang nhân viên và nhãn vai trò trên trang chủ đều đúng màu indigo `rgb(30,58,138)`.

## Fix: đăng nhập nhân viên vẫn thấy giao diện y hệt khách hàng 2026-11-19

User báo đăng nhập STAFF xong thấy trang y hệt khách hàng. Nguyên nhân: KHÔNG phải sai đường dẫn — `LoginServlet` vẫn redirect đúng tới `/home`, và `/home` (`index.jsp`) có hiện đúng nhãn vai trò ("Nhân viên") trong dropdown tài khoản — nhưng khối link tắt (Đặt lịch, Lịch hẹn, Thanh toán...) trong dropdown đó chỉ hiện khi `loggedInRole == 'CUSTOMER'`, không có nhánh nào cho STAFF, nên nhân viên không có cách nào bấm vào 3 trang `/staff/*` đã làm (phải gõ tay URL).

- **`src/main/webapp/index.jsp`**: thêm `<c:if test="${sessionScope.loggedInRole == 'STAFF'}">` ngay sau khối của CUSTOMER, chứa 3 link: Đặt lịch tại quầy, Lịch hẹn của tôi, Lịch làm việc — cùng kiểu icon/style với khối CUSTOMER sẵn có.
- Test qua UI thật (đăng nhập `staff.demo@petcare.vn`): hover vào pill tài khoản ở góc phải trên cùng → dropdown hiện đúng 3 link mới kèm icon; bấm "Lịch hẹn của tôi" → điều hướng đúng tới `/staff/lich-hen` và hiển thị đúng dữ liệu.
- Không đụng nhánh ADMIN (đăng nhập ADMIN redirect thẳng `/admin/tai-khoan`, không qua `/home`) hay nhánh CUSTOMER.

## Đã làm "Lịch làm việc" + "Lịch hẹn nhân viên" 2026-11-19

Hoàn thiện 2 trang nhân viên còn thiếu (trước đó `LichLamViecServlet`/`LichHenNhanVienServlet` là scaffold rỗng). Chưa commit.

- **`StaffDAO`/`StaffDAOImpl`**: thêm `findShiftsForStaff(staffId, fromDate, toDate)` — như `findUpcomingShifts` có sẵn nhưng lọc theo đúng 1 nhân viên.
- **`AppointmentDAO`/`AppointmentDAOImpl`**: thêm `findServiceLinesByStaff(staffId, fromDate, toDate)` (join Appointments+Services+Users khách+Pets để có đủ tên khách/SĐT/thú cưng/trạng thái lịch hẹn) và `isSoleStaffOnAppointment(appointmentId, staffId)` (kiểm tra nhân viên này có phải người duy nhất thực hiện lịch hẹn đó không — dùng để chặn an toàn trước khi cho đổi trạng thái, vì 1 lịch hẹn combo có thể có nhiều nhân viên khác nhau cho từng dịch vụ).
- **`AppointmentServices.java`** (model): thêm các trường hiển thị `appointmentStatus`, `customerName`, `customerPhone`, `petName` (+ `getAppointmentStatusLabel()`), theo đúng pattern đã dùng cho `AppointmentBalance` trước đó.
- **`StaffScheduleService.java`** (mới): `getMyShifts(...)`, `getMyAppointments(...)`, và `advanceStatus(staffId, appointmentId, newStatus)` — chỉ cho phép CHECKED_IN/IN_PROGRESS/COMPLETED, và **chỉ khi nhân viên đó là người duy nhất** thực hiện lịch hẹn (gọi `isSoleStaffOnAppointment` trước), tránh 1 nhân viên tự ý đổi trạng thái ảnh hưởng tới phần việc của nhân viên khác trong cùng 1 lịch hẹn combo multi-staff.
- **`LichLamViecServlet`** (`/staff/lich-lam-viec`): xem ca làm việc 14 ngày tới — chỉ xem, không có hành động.
- **`LichHenNhanVienServlet`** (`/staff/lich-hen`): xem lịch hẹn được giao trong 30 ngày tới, có nút hành động theo đúng trạng thái hiện tại (CONFIRMED → nút "Check-in", CHECKED_IN → "Bắt đầu thực hiện", IN_PROGRESS → "Hoàn thành"; PENDING/COMPLETED/CANCELLED không có nút).
- 2 JSP (`staff/lichLamViec.jsp`, `staff/quanLyLichHen.jsp`) thay nội dung khung cũ; thêm link điều hướng qua lại giữa 3 trang nhân viên (đặt lịch tại quầy / lịch làm việc / lịch hẹn của tôi).

### Đã kiểm chứng
- `mvn test-compile` sạch.
- Test trên DB thật bằng tài khoản `staff.demo@petcare.vn` (user_id=4, có sẵn ca + lịch hẹn demo): `getMyShifts` ra đúng 9 ca còn lại trong 14 ngày; `getMyAppointments` ra đúng 7 lịch hẹn kèm đủ tên khách/SĐT/thú cưng. `advanceStatus` chạy đúng chuỗi CONFIRMED→CHECKED_IN→IN_PROGRESS→COMPLETED (appt#16, xác nhận lại trong DB cả `Appointments.status` lẫn `AppointmentServices.line_status` đều COMPLETED); bị từ chối đúng khi thử chuyển PENDING→CHECKED_IN (lỗi 51022).
- Test qua UI thật (đăng nhập `staff.demo@petcare.vn`/`12345678` lấy từ `docs/tk test petcare.txt` — lưu ý tài khoản `staff@petcare.vn` KHÔNG có dữ liệu demo, phải dùng đúng `staff.demo@petcare.vn`): trang Lịch làm việc hiện đúng 9 ca; trang Lịch hẹn của tôi hiện đúng 7 dòng với nút hành động đúng theo trạng thái; bấm "Check-in" cho appt#17 → báo "Đã check-in lịch hẹn #17", nút đổi thành "Bắt đầu thực hiện" ngay, đúng.

### Còn thiếu / lưu ý
- Trang "Lịch hẹn của tôi" chưa có hành động Hủy/Vắng mặt (CANCELLED/NO_SHOW) — chỉ cho đi tới (check-in → bắt đầu → hoàn thành) vì đó là nhu cầu chính; có thể bổ sung sau nếu cần.
- Khi lịch hẹn có nhiều nhân viên khác nhau (combo nhiều dịch vụ), trang chỉ hiển thị, không cho đổi trạng thái (an toàn hơn, tránh đụng việc của người khác) — chưa có nơi nào xử lý trường hợp này.

### ⚠️ Lại có người/phiên khác đang sửa code song song (lần 3)
Ngay khi viết xong mục này, `git status` cho thấy có thêm nhiều file mới hoàn toàn không phải do tôi: `AdminOperationsServlet.java`, `AdminOperationsDAO.java`, `AdminReport.java`, `AdminOperationsPolicy.java`, `docs/ADMIN_OPERATIONS.md`... Không đụng vào các file này. Nhắc lại: nên đồng bộ với nhóm trước khi merge/commit để tránh lặp lại sự cố mất code đã ghi ở mục trên.

## Sự cố merge làm mất code + khắc phục 2026-11-19 (quan trọng, đọc trước khi làm tiếp)

Sau khi merge nhiều nhánh (`PhungBao`, `Chitien`, `bao`...) vào `GiaHung` (commit `50e968a`), code working tree bị hỏng. Đã tìm và sửa xong, build sạch + test pass, nhưng có 1 thay đổi hành vi cần biết (xem mục cuối).

### Những gì bị hỏng do merge
- `ConfigUtil.java`: 2 bản load config bị dính chùm vào nhau (ngoặc `{}` không khớp) → **toàn bộ project không build được**. Không phải do tôi, do merge.
- `PaymentService.java`, `ThanhToanServlet.java` (của tôi, phần Thanh toán), `src/main/webapp/customer/thanhToan.jsp` bị merge đè về lại scaffold rỗng/trống hẳn — mất hết phần đã test UI thành công hôm trước.
- `AppointmentDAO.java` (interface) bị merge về bản cũ chỉ có 1 hàm `bookService`, trong khi `AppointmentDAOImpl.java` (bản đồng đội nâng cấp: combo, lưu trú, hủy lịch, `setStatus`...) `@Override` tới 7 hàm không khai báo trong interface đó.
- Phát hiện thêm: có **3 thiết kế `PaymentService` khác nhau** từng tồn tại song song của 3 người/phiên (tôi, `ProfileServlet.java` của đồng đội gọi `getPayableAppointments(customerId)`, và `src/test/java/com/petcare/services/PaymentServiceTest.java` của đồng đội đòi `PaymentService(PaymentDAO)` + `initiatePayment(...)` + `confirmOnlinePayment(...)`). Merge chỉ giữ lại các "người gọi" (callers), xoá mất class `PaymentService` thật.

### Đã sửa, đối chiếu theo thiết kế có sẵn (không tự bịa thêm)
- **`ConfigUtil.java`**: gộp lại thành 1 khối try/catch đúng, giữ nguyên ý định (ưu tiên `-Dpetcare.config`, sau đó `application-local.properties` ở thư mục làm việc, cuối cùng fallback đường dẫn tuyệt đối `C:/Users/Admin/Documents/GitHub/asm-jav102/...` — đúng kiểu DBUtil.java đã làm với truststore).
- **`AppointmentDAO.java`**: bổ sung đủ 6 hàm mà `AppointmentDAOImpl.java` đã implement (`bookServices`, `bookBoarding`, `findByCustomer`, `findDetailByIdForCustomer`, `cancelAppointment`, `setStatus`) — các import (`Appointments`, `ServiceBookingItem`, `LocalDate`, `List`) đã có sẵn trong file từ trước, chỉ thiếu khai báo.
- **`PaymentService.java`**: viết lại theo đúng hợp đồng mà `PaymentServiceTest.java` đòi hỏi (vì đó là thiết kế đã được test hóa, chặt hơn bản của tôi):
  - `PaymentService()` (mặc định) + `PaymentService(PaymentDAO)` (để test có thể mock).
  - `getPayableAppointments(customerId)` — giữ cho `ProfileServlet.java`.
  - `initiatePayment(customerId, appointmentId, amount, method, paymentKey)` — ghi nhận charge **PENDING** (không tự PAID), Online tự sinh `transaction_ref` dạng `PC-ONL-{appointmentId}-{timestamp}` (dự án không có cổng thanh toán thật nên không có bước nhập mã giao dịch thủ công nữa).
  - `confirmOnlinePayment(customerId, paymentId)` — khách tự xác nhận online đã thanh toán (giả lập callback cổng thanh toán) → PAID. **Chặn khách tự xác nhận thanh toán tiền mặt** (ném lỗi) — đúng ý đồ bảo mật: không cho khách tự bấm "đã trả tiền mặt" mà chưa đưa tiền thật.
  - `settleAtCounter(customerId, appointmentId, amount, method, transactionRef)` — hàm mới, dành cho **nhân viên tại quầy** (không bị chặn như trên vì nhân viên là người xác nhận trực tiếp): ghi nhận + PAID ngay. Dùng bởi `WalkInBookingService`.
- **`ThanhToanServlet.java`** (khách tự thanh toán online): đổi sang gọi `initiatePayment` rồi `confirmOnlinePayment` ngay cho ONLINE (gộp 1 lượt submit cho gọn vì không có cổng thật); với CASH chỉ `initiatePayment` rồi báo khách ra quầy, **không tự PAID nữa** (đổi hành vi so với bản tôi test hôm trước — xem mục cuối).
- **`thanhToan.jsp`**: bỏ ô nhập "mã giao dịch" thủ công (Online giờ tự sinh mã), đổi lại thứ tự dropdown + ghi chú rõ Online xác nhận ngay / Cash cần nhân viên xác nhận tại quầy.
- **`WalkInBookingService.java`**: đổi gọi `paymentService.pay(...)` (không còn tồn tại) sang `paymentService.settleAtCounter(...)`.

### Đã kiểm chứng sau khi sửa
- `mvn test-compile` sạch hoàn toàn (main + test, kể cả các class/test của đồng đội: `AdminModule`, `AdminCatalogServlet`, `QuanLyTaiKhoanServletTest`...).
- `mvn test -Dtest=PaymentServiceTest` → **3/3 PASS**.
- Test trực tiếp trên DB thật (khách mới SĐT `0911222333`): đặt lịch #19 → `initiatePayment` ONLINE → `confirmOnlinePayment` → payment PAID (appointment vẫn PENDING, đúng vì xác nhận lịch và xác nhận thanh toán là 2 việc khác nhau). Đặt lịch #20 → `initiatePayment` CASH → payment **PENDING** (đúng, chờ nhân viên) → gọi `confirmOnlinePayment` cho payment CASH này → bị từ chối đúng như thiết kế. Nhân viên tại quầy (`bookAndSettleAtCounter`) vẫn hoạt động đúng: appt#21 CONFIRMED + PAID ngay.
- Chưa test lại qua trình duyệt lần này (đã test qua code/DB trực tiếp, mức độ tin cậy tương đương lần test Payment đầu tiên trước khi test UI).

### Thay đổi hành vi cần nhóm biết
- Trước đây (bản tôi tự thiết kế, đã test UI): khách chọn CASH trên `/customer/thanh-toan` thì **PAID ngay lập tức**. Giờ theo thiết kế mới (khớp với `PaymentServiceTest.java` của đồng đội): CASH chỉ tạo yêu cầu **PENDING**, cần nhân viên xác nhận tại quầy mới thành PAID — nhưng **hiện chưa có trang nào cho nhân viên xác nhận** khoản CASH đang chờ này (đã tìm, không thấy). Đây là phần còn thiếu, cần làm tiếp nếu muốn luồng thanh toán tiền mặt tự phục vụ hoàn chỉnh.
- Appointment và Payment là 2 trạng thái độc lập: thanh toán PAID không tự động làm lịch hẹn thành CONFIRMED (trừ luồng nhân viên tại quầy, nơi cả 2 được làm cùng lúc).

### ⚠️ Đang có người/phiên khác sửa code song song ngay lúc này
Lúc viết xong mục này, `git status` cho thấy lại có thay đổi mới ở `AccountDAO.java`, `AccountDAOImpl.java`, `QuanLyTaiKhoanServlet.java`, admin JSP... (không phải do tôi). Nhiều khả năng có người đang code cùng lúc. **Nên trao đổi trong nhóm trước khi merge/commit lần tới** để tránh lặp lại y hệt sự cố ở mục này (các bản uncommitted bị merge đè mất).

## Đã làm phần "Khách vãng lai / đặt lịch tại quầy" 2026-11-19

Theo đề nghị của nhóm: khách không tự đặt lịch trên website (đến trực tiếp) thì nhân viên/lễ tân tạo lịch và thu tiền hộ ngay tại quầy, khách không cần tài khoản đăng nhập — giống mô hình "bấm bill tại quầy" của POS ngoài thị trường. Chưa commit.

- **`AppointmentDAO`/`AppointmentDAOImpl`**: thêm `setStatus(appointmentId, status, cancelReason)` gọi SP `SetAppointmentStatus` có sẵn trong DB (trước đó chưa có lớp Java nào gọi SP này).
- **`WalkInBookingService.java`** (mới): `findOrCreateCustomer(fullName, phone)` — tra theo SĐT qua `AccountDAO.findByPhone` (đã có sẵn), nếu có rồi thì tái dùng (và sửa lại tên nếu nhân viên xác nhận gõ nhầm, qua `updateProfile`), nếu chưa có thì tạo mới tài khoản CUSTOMER **không cần mật khẩu/email thật**: email sinh tự động từ SĐT theo đúng cơ chế có sẵn của `AuthService.registerCustomer` (`sdt@petcare.vn`), mật khẩu random không ai dùng để đăng nhập được (hash qua `AuthService.hashPassword`). `addPet(...)` tái dùng logic thêm thú cưng. `bookAndSettleAtCounter(...)`: gọi `BookingService.bookService` rồi **tự động chuyển PENDING → CONFIRMED ngay** (vì nhân viên đã xác nhận trực tiếp trước mặt khách) rồi gọi `PaymentService.pay` thu đủ tiền luôn.
- **`DatLichTaiQuayServlet.java`** (mới): `@WebServlet(urlPatterns = "/staff/dat-lich-tai-quay")`, cho cả STAFF và ADMIN (đã nằm trong vùng `/staff/*` mà `AuthFilter` bảo vệ sẵn, không cần sửa filter). 3 action trên cùng 1 trang: `timKhach` (tìm/tạo khách theo SĐT), `themThuCung` (thêm thú cưng cho khách đó), `datLichVaThu` (đặt lịch + thu tiền ngay, validate ONLINE phải có mã giao dịch trước khi tạo lịch để tránh kẹt ở trạng thái "đã đặt nhưng chưa thu được tiền").
- **`src/main/webapp/staff/datLichTaiQuay.jsp`** (file mới): cùng style/layout với `datLich.jsp`/`thanhToan.jsp` đã làm trước đó.
- Không đụng `LichHenNhanVienServlet`/`LichLamViecServlet` hay các module admin khác đang có người/phiên khác làm dở song song.

### Đã test thật trên DB (tầng service, gọi thẳng DB thật)
Khách vãng lai test SĐT `0977000111`: tạo mới (user_id=15, email tự sinh `0977000111@petcare.vn`) → gọi lại với tên khác → đúng cập nhật lại tên, giữ nguyên user_id. Thêm thú cưng, đặt 2 lịch hẹn (appt#16 CASH, appt#17 ONLINE kèm mã giao dịch) → cả hai đều **CONFIRMED** và **PAID** đủ ngay, biến mất khỏi `listPayable`. Đúng như thiết kế.

### Đã test qua UI thật (đăng nhập STAFF)
Dùng tài khoản `staff@petcare.vn` (mật khẩu lấy từ `docs/tk test petcare.txt` — ghi chú mật khẩu "Staff@123" trong `database/grant_auth_permissions.sql` không khớp hash thật trong DB, phải dùng file này). Luồng: đăng nhập STAFF → `/staff/dat-lich-tai-quay` → nhập SĐT `0933555777` + tên khách mới → tạo khách thành công → thêm thú cưng "Vang Lai Pet UI" → đặt lịch Grooming 20/11/2026 16:00, chọn Tiền mặt → báo **"Đã tạo và thu tiền lịch hẹn #18 cho khách Khach Vang Lai UI (0933555777)."** Kiểm tra lại DB: appt#18 status=CONFIRMED, total=150.000, đã thu đủ 150.000. Đúng toàn bộ.

Tomcat test (cổng 8081, xem mục Thanh toán bên dưới để biết cách dựng) đã dừng sau khi test xong.

### Còn thiếu / điểm cần lưu ý
- Nếu 2 nhân viên cùng lúc nhập đúng 1 SĐT khách mới (chưa từng có) thì có thể đụng độ tạo 2 user trùng SĐT (DB không có UNIQUE constraint trên cột `phone`, chỉ chặn ở tầng ứng dụng theo logic tìm-trước-khi-tạo) — rủi ro thấp trong thực tế (2 lễ tân hiếm khi nhập cùng lúc), nhưng nên biết trước.
- Chưa có cách tìm/sửa/xoá các tài khoản "khách vãng lai" này riêng biệt với khách tự đăng ký trong trang quản lý tài khoản admin (chúng chỉ là CUSTOMER bình thường, không có cờ đánh dấu riêng).
- Giống phần Thanh toán: do dự án không có cổng thanh toán thật, thu tiền tại quầy cũng được coi là thành công ngay khi nhân viên bấm xác nhận.

## Đã làm phần Thanh toán 2026-11-19

Thay cho mục "Thanh toán — làm được một phần" bên dưới: đã viết xong `PaymentService`, `ThanhToanServlet` và JSP, test thật trên DB qua `PaymentDAO`/stored procedure có sẵn. Chưa commit.

- **`PaymentService.java`** (mới, thay scaffold rỗng): `listPayable(customerId)` lọc `AppointmentBalance` còn `remainingAmount > 0` từ `PaymentDAO.findPayableAppointments`. `pay(customerId, appointmentId, amount, method, transactionRef)`: kiểm tra lịch hẹn thuộc đúng khách hàng (so với `listPayable`), số tiền > 0 và không vượt số còn nợ, `method` chỉ CASH/ONLINE, ONLINE bắt buộc `transactionRef`. Gọi `PaymentDAO.recordPayment` (SP `RecordPayment`, sinh `payment_key` UUID mới mỗi lần) rồi `setStatus(..., "PAID")` ngay (SP `SetPaymentStatus`) — **dự án chưa có cổng thanh toán thật nên coi mỗi lần submit là thu tiền mặt/chuyển khoản đã xác nhận ngay**, không có bước PENDING chờ xác nhận riêng. Map mã lỗi SQL (51016/51018/51038-51041...) sang thông báo tiếng Việt như `BookingService` đã làm với lỗi đặt lịch.
- **`ThanhToanServlet.java`** (thay scaffold rỗng): thêm `@WebServlet(urlPatterns = "/customer/thanh-toan")` (được `AuthFilter` bảo vệ theo pattern `/customer/*` có sẵn, không cần sửa filter). `doGet` nạp danh sách lịch hẹn còn nợ; `doPost` nhận `appointmentId`/`amount`/`method`/`transactionRef`, gọi `PaymentService.pay`, báo thành công/lỗi, gửi thông báo realtime qua `NotificationEndpoint` (cho khách và cho ADMIN/STAFF) giống `DatLichServlet`.
- **`src/main/webapp/customer/thanhToan.jsp`** (file mới): danh sách lịch hẹn còn nợ (tổng tiền/còn nợ dùng `fmt:formatNumber`), mỗi lịch hẹn có form chọn số tiền + CASH/ONLINE + mã giao dịch. Theo đúng style/layout của `datLich.jsp` (trang thật đang dùng), không dùng `assets/css/style.css` (CSS đó chỉ còn ở các JSP khung chưa làm).
- **`profile.jsp`**: thêm 1 thẻ "Thanh toán lịch hẹn" vào lưới shortcut (`profile-shortcut-grid`) trỏ tới `/customer/thanh-toan`, cùng mẫu với 3 thẻ có sẵn.
- Không sửa `PaymentDAO`/`PaymentDAOImpl`/schema/stored procedure — lớp DAO đã đúng từ trước.

### Đã test thật trên DB (ghi dữ liệu QA, không phải suy đoán)
Dùng tài khoản test `e2e-customer@petcare.vn` (customer_id=5), lịch hẹn test có sẵn `#1` (PENDING, total_amount=150000, chưa có payment nào) — không đụng tới lịch hẹn `#5` của `qa-smoke-20261117@petcare.test` vì `scripts/smoke-test.ps1` đang giữ slot đó để chạy lại.
- Gọi `PaymentService.pay` CASH 50.000đ → `remainingAmount` 150.000 → 100.000, payment_id=1, PAID. Đúng.
- Gọi tiếp ONLINE 100.000đ kèm `transactionRef="TEST-TXN-0001"` → hết nợ, payment_id=2, PAID, lịch hẹn biến mất khỏi `listPayable`. Đúng.
- Trả về đúng lỗi "Lịch hẹn không hợp lệ hoặc không thuộc tài khoản của bạn." khi: trả thêm cho lịch đã hết nợ, trả cho `appointmentId` không tồn tại, và trả cho lịch hẹn của khách khác (dùng `customerId` sai). Đúng cả 3.
- Chưa test qua UI thật (chưa mở trình duyệt bấm form); chỉ test tầng `PaymentService` gọi thẳng DB thật bằng một class test tạm ngoài project (không commit vào repo).
- `mvn compile` sạch, không lỗi.

### Đã test qua trình duyệt thật (UI) 2026-11-19
Không có SmartTomcat/launch.json sẵn trong repo nên tự deploy tạm: `mvn package` ra `target/petcare.war`, chạy bằng Tomcat 10.1.54 có sẵn trên máy ở `F:\apache-tomcat-10.1.54-windows-x64` — **đổi cổng sang 8081/8006** (sửa `conf/server.xml`) vì 8080/8005 đã có tiến trình Java khác đang chiếm (không phải do tôi khởi động, không đụng tới tiến trình đó). Thêm `bin/setenv.bat` set `-Dpetcare.config=F:/asm-jav102/application-local.properties`. Đã dừng Tomcat test này sau khi xong; cài đặt Tomcat đó nằm ngoài repo, vẫn còn trên máy nếu muốn dùng lại (nhớ đổi cổng lại 8080/8005 nếu muốn trùng với SmartTomcat).

Luồng test qua trình duyệt (tài khoản mới tạo qua UI, không dùng tài khoản QA cũ): đăng ký `qa-ui-test-20261119@petcare.test` → đăng nhập → thêm thú cưng "QA Pet" → đặt lịch dịch vụ Grooming ngày 20/11/2026 10:00 → ra lịch hẹn **#15** (150.000đ) → vào `/customer/thanh-toan`:
- Chọn Online, để trống mã giao dịch → đúng báo lỗi "Vui lòng nhập mã giao dịch thanh toán online.", không trừ tiền.
- Trả Tiền mặt 50.000đ → báo thành công, còn nợ cập nhật đúng 150.000 → 100.000.
- Trả Online 100.000đ kèm mã giao dịch → báo thành công, hết nợ, lịch hẹn biến mất khỏi danh sách còn phải thanh toán.
- Thẻ shortcut "Thanh toán lịch hẹn" mới thêm trên `/profile` hiển thị đúng, cùng style 3 thẻ có sẵn.

Tất cả đúng như thiết kế. Module Thanh toán coi như đã test đầy đủ cả tầng service (DB trực tiếp) lẫn UI thật.

### Còn thiếu để coi là "xong" hoàn toàn
- Chưa có nơi khách xem lại lịch sử thanh toán (`findByAppointment`) — hiện chỉ có luồng trả tiền, chưa có trang xem đã thanh toán bao nhiêu/khi nào.
- Việc coi mỗi submit là thanh toán thành công ngay (không có bước xác nhận/webhook cổng thanh toán thật) là giả định tạm vì dự án không có cổng thanh toán — nên nêu rõ với giảng viên/nhóm nếu cần mô phỏng trạng thái PENDING chờ xác nhận.

### Lưu ý: có người/phiên khác đang sửa song song (phát hiện 2026-11-19 sau khi test UI xong)
`git status` lúc này cho thấy nhiều file KHÔNG phải do tôi sửa đang ở trạng thái modified/untracked: `PROJECT_STRUCTURE.md`, `scripts/smoke-test.ps1`, `QuanLyCaLamViecServlet.java`, `QuanLyComboServlet.java`, `QuanLyDichVuServlet.java`, `QuanLyPhongServlet.java`, `QuanLyTaiKhoanServlet.java`, `QuanLyThuCungServlet.java`, các JSP admin (`quanLyCaLamViec.jsp`, `quanLyCombo.jsp`, `quanLyDichVu.jsp`, `quanLyPhong.jsp`, `quanLiTaiKhoan.jsp`), và file mới `AdminCatalogServlet.java`, `AdminCatalogDAO.java`, `AdminModule.java`, `database/admin_catalog.sql`, `assets/css/admin.css`, `assets/js/admin.js`... — có vẻ ai đó (người hoặc phiên AI khác) đang làm dở các module quản trị admin cùng lúc trên working tree này. Tôi **không đụng, không revert, không commit** các file đó — không thuộc phạm vi việc thanh toán. Nếu nhóm commit/push, cần kiểm tra kỹ tránh đụng tay vào nhau trên cùng file.

## Kiểm tra backend còn thiếu gì 2026-11-19 (đọc trực tiếp code, không suy đoán)

Phần "Tiến độ theo module" ở mục 4 bên dưới đã cũ (viết trước khi `PaymentDAOImpl` được hoàn thiện). Mục này là bản cập nhật chính xác hơn, kiểm bằng cách đọc từng file + grep `@WebServlet` để biết servlet nào thực sự có URL mapping.

### Scaffold rỗng, KHÔNG có `@WebServlet` → không hoạt động, chưa làm gì cả
- `ThanhToanServlet` (thanh toán) — không mapping, class rỗng.
- `DanhGiaServlet` (đánh giá) — không mapping, class rỗng. `ReviewDAOImpl` cũng rỗng (5 dòng).
- `LichHenKhachHangServlet`, `LichHenNhanVienServlet`, `LichLamViecServlet` (xem/quản lý lịch hẹn, lịch làm việc) — không mapping, rỗng.
- `QuanLyCaLamViecServlet` (admin quản lý ca làm việc) — không mapping, rỗng.
- `QuanLyComboServlet` (admin quản lý combo) — không mapping, rỗng. `ComboDAOImpl` cũng rỗng (5 dòng).
- `QuanLyDichVuServlet` (admin CRUD dịch vụ) — không mapping, rỗng. `ServiceDAOImpl` chỉ có 2 hàm đọc (`findActiveBookable`, `findById`) phục vụ trang đặt lịch, **chưa có thêm/sửa/xoá dịch vụ**.
- `QuanLyPhongServlet` (admin quản lý phòng) — không mapping, rỗng. `RoomDAOImpl` cũng rỗng (5 dòng).
- `QuanLyThuCungServlet` (admin quản lý thú cưng) — không mapping, rỗng. `PetDAOImpl` chỉ có hàm phục vụ đặt lịch (tìm theo chủ, tạo mới), chưa có giao diện quản lý riêng.
- `DangKyServlet`, `DangNhapServlet` — scaffold cũ, không có `@WebServlet`, là code chết/trùng lặp; bản thật đang chạy là `RegisterServlet` (`/register`, `/dang-ky`) và `LoginServlet` (`/login`, `/dang-nhap`). Nên xoá 2 file scaffold này để tránh nhầm với bản đang dùng.

### Thanh toán — làm được một phần
- `PaymentDAO` + `PaymentDAOImpl` (115 dòng): **đã triển khai thật**, gọi DB/stored procedure (`findPayableAppointments`, ghi nhận thanh toán...).
- `PaymentService`: scaffold rỗng (5 dòng) — chưa có logic nghiệp vụ nối DAO với servlet.
- `ThanhToanServlet`: scaffold rỗng, không mapping.
- Chưa có JSP thanh toán (không tìm thấy file `*thanh-toan*`/`payment*` trong `src/main/webapp`).
- → Việc còn thiếu: viết `PaymentService`, `ThanhToanServlet` (thêm `@WebServlet`), JSP thanh toán. Phần DB/DAO coi như xong.

### Đã làm, đang chạy thật (xác nhận còn đúng)
- Đăng ký/Đăng nhập/Đăng xuất: `RegisterServlet`, `LoginServlet`, `DangXuatServlet` — có mapping, dùng `AuthService`/`AccountDAOImpl` (396 dòng, đầy đủ).
- Trang chủ: `HomeServlet`.
- Hồ sơ cá nhân: `ProfileServlet` (`/profile`, `/ho-so`).
- Đặt lịch khách hàng: `DatLichServlet` (`/customer/dat-lich`) + `BookingService` + `AppointmentDAOImpl` (gọi SP `BookServiceAppointment`) + `StaffDAOImpl`, `ServiceDAOImpl` (phần đọc), `PetDAOImpl` (phần đọc/tạo) — chạy được, có test.
- Quản lý tài khoản (admin): `QuanLyTaiKhoanServlet` (`/admin/tai-khoan`) + `AccountDAOImpl`.
- Kết nối DB (`DBUtil`, `ConfigUtil`): đã xác minh kết nối thật, xem mục kiểm tra kết nối dưới.

### Tóm tắt phần backend CHƯA làm
1. Thanh toán — chỉ có DAO, thiếu Service + Servlet + JSP.
2. Đánh giá (review) — chưa làm gì (servlet + DAO đều rỗng).
3. Lịch hẹn khách hàng xem lại / lịch hẹn nhân viên / lịch làm việc nhân viên — chưa làm gì.
4. Toàn bộ trang quản trị (admin) cho: ca làm việc, combo, dịch vụ (CRUD), phòng, thú cưng — chưa làm gì (chỉ các servlet quản lý tài khoản là có thật).
5. Dọn dẹp: xoá `DangKyServlet`/`DangNhapServlet` (scaffold chết, trùng với Register/LoginServlet đang dùng thật).

## Kiểm tra kết nối database 2026-11-19

- Chạy `com.petcare.utils.DatabaseConnectionTest` với `-Dpetcare.config=F:/asm-jav102/application-local.properties` (compile bằng Maven của IntelliJ, classpath lấy qua `dependency:build-classpath`).
- Kết quả: **kết nối JDBC thành công** tới SQL Server `hung211.tail1f20d2.ts.net:1433`, database `PetCare`, đọc được `dbo.Users` = 11 dòng. Không phải dùng fallback local SQL Server.
- Không có thay đổi code; chỉ kiểm tra kết nối.

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

## Hướng dẫn xoá tài khoản test (2026-11-19)

- Đã cung cấp câu SQL cho người dùng tự chạy trong SSMS, nhắm đúng email E2E/QA đã ghi nhận: e2e-test-admin@petcare.vn, e2e-customer@petcare.vn, qa-smoke-20261117@petcare.test, qa-admin-target-20261117@petcare.test.
- Giữ tài khoản admin/staff chính và staff.demo (nhân viên demo có kỹ năng/ca làm việc). Không tự thực thi xoá trên DB.
- Xoá trong transaction với XACT_ABORT và TRY/CATCH; nếu có khoá ngoại từ thú cưng/lịch hẹn thì rollback toàn bộ. Schema chặn xoá lịch đã công bố và thanh toán bằng trigger; không tắt trigger trong câu lệnh hướng dẫn.

## Hướng dẫn tạo quản trị web (2026-11-19)

- Cung cấp SQL INSERT tài khoản ADMIN đang hoạt động, dùng email admin.web@petcare.vn và hash BCrypt mẫu của mật khẩu Admin@123 từ database/grant_auth_permissions.sql.
- Có kiểm tra email tồn tại để không ghi đè tài khoản cũ; không tự chạy SQL trên database. Người dùng nên đổi mật khẩu sau khi đăng nhập.

## Quản lý tài khoản và quyền quản trị — cập nhật 2026-11-19

Phạm vi người dùng xác nhận: chỉ quản lý tài khoản và quyền quản trị.

- Kiểm tra `QuanLyTaiKhoanServlet`, `AccountDAO/Impl`, `AuthFilter`, `SessionUtil`, trang quản lý tài khoản và script smoke test.
- Bổ sung token CSRF theo session cho cả bốn form tạo/sửa/khóa-mở/reset mật khẩu. POST thiếu/sai token trả HTTP 403 trước khi gọi DAO; mở GET `/admin/tai-khoan` để lấy token.
- Không hiểu trạng thái thiếu/sai thành khóa tài khoản; chỉ nhận `true`/`false`. Mã tài khoản phải là số nguyên dương.
- Tạo tài khoản đặt active rõ ràng và kiểm tra DAO trả ID hợp lệ trước khi báo thành công. Reset mật khẩu kiểm tra tài khoản tồn tại trước khi ghi.
- Giữ các quy tắc hiện có: chỉ ADMIN quản lý tài khoản, không tự khóa/tự bỏ quyền; filter xác minh trạng thái/vai trò từ DB mỗi request tới khu vực bảo vệ.
- Thêm 9 test servlet bằng DAO giả: token thiếu/sai, token hợp lệ, trạng thái sai, tự khóa, tự bỏ quyền, reset đích không tồn tại, tạo admin và CUSTOMER bị chặn. Ba test tái hiện đã quan sát FAIL trước sửa, PASS sau sửa.
- Kết quả: test-compile và toàn bộ 16 test JUnit PASS (Surefire 3.5.6 offline, Maven IntelliJ, repo local C:/Users/ADMIN/.m2/repository). Kiểm tra cú pháp PowerShell và git diff --check đạt. Script smoke tự lấy token trước POST admin.
- Chưa chạy smoke HTTP trên Tomcat/ghi dữ liệu DB thật trong lần này, chưa deploy/restart Tomcat, chưa commit/push. Các thay đổi thanh toán đang xuất hiện từ phiên khác được giữ nguyên, không thuộc phần triển khai này.

## Đối chiếu các trang admin 2026-11-19

- Kiểm tra trực tiếp 5 JSP trong src/main/webapp/admin và 6 QuanLy*Servlet.
- Quản lý tài khoản: có Servlet mapping /admin/tai-khoan, GET/POST, DAO và form thật; có test tự động, đợt sửa mới chưa xác minh lại trên Tomcat.
- Dịch vụ, combo, phòng, ca làm việc: 4 JSP chỉ hiển thị trang khung chờ triển khai; Servlet tương ứng chưa mapping/xử lý request. ComboDAOImpl và RoomDAOImpl còn rỗng.
- Quản lý thú cưng: Servlet còn scaffold, chưa có trang trong thư mục admin.
- Kết luận: chưa đủ toàn bộ trang admin. Lần làm trước chỉ bổ sung quản lý tài khoản/quyền quản trị theo phạm vi người dùng đã chọn.

## Chẩn đoán máy thành viên timeout SQL (2026-11-19)
- Ảnh SSMS: TCP Provider timeout, Error 258 khi tới 100.90.157.31:1433; chưa đủ căn cứ kết luận lỗi login/password.
- Kiểm tra máy chủ hiện tại: MSSQL$SQLEXPRESS và Tailscale Running; netstat xác nhận 0.0.0.0:1433 LISTENING và ESTABLISHED từ hai IP Tailscale khác. Đây là kết nối TCP, chưa khẳng định từng kết nối đã xác thực SQL thành công.
- Cần kết quả tailscale status, tailscale ping 100.90.157.31 và Test-NetConnection 100.90.157.31 -Port 1433 trên đúng máy thành viên bị lỗi. Xem IP/tài khoản Tailscale máy đó để phân biệt kết nối tailnet, policy theo nguồn hoặc firewall theo nguồn. Chưa thay đổi cấu hình mạng/firewall/schema.

## Hoàn thiện và kiểm thử các trang admin — 2026-11-19 (thay thế nhận định admin còn scaffold)

- Đã triển khai dịch vụ, combo, phòng, ca làm việc và thú cưng: danh sách, form tạo/sửa, xóa có ràng buộc, menu kết nối quản lý tài khoản. Servlet admin cũ đã có mapping thật. JSP cũ redirect về Servlet.
- Dùng AdminModule + AdminCatalogServlet + AdminCatalogDAO cho vòng đời CRUD chung; không thay đổi DAO đặt lịch hiện có. Ghi qua 11 stored procedure trong database/admin_catalog.sql; transaction giữ combo và các dịch vụ nhất quán, giữ nguyên trigger/khóa ngoại.
- Validation, ADMIN/CSRF, escape HTML, thông báo lỗi DB, redirect sau thành công; form không biến thành bản sửa trống khi xóa thất bại.
- Kiểm thử cuối: 27/27 JUnit (gồm test DB tích hợp nhiều trường hợp CRUD, trùng ca/phòng, tham chiếu và rollback lỗi bảng con); 69/69 HTTP catalog + phân quyền/CSRF và 13/13 HTTP quản lý tài khoản. Build WAR và kiểm tra cú pháp PowerShell/git diff --check đạt.
- Đã quan sát trình duyệt thật ở login admin, trang dịch vụ và phòng; chưa bấm toàn bộ form bằng browser hoặc kiểm tra viewport mobile.
- Môi trường kiểm thử: DB riêng PetCareAdminQA_ee134de11d + Tomcat QA loopback port 18089. Thao tác CRUD mới không chạy trên PetCare chính. Fixture catalog đã dọn; DB và process QA dọn sau test.
- IMPORTANT: tự động duyệt đã từ chối cài migration vào PetCare chính vì thay đổi schema/quyền lâu dài cần phê duyệt cụ thể. Migration/code/WAR đã sẵn sàng để duyệt; DB chính chưa được áp dụng, chưa deploy/restart server chính.
- Chi tiết và điều kiện triển khai: docs/ADMIN.md. Báo cáo ở target/surefire-reports, target/admin-http-results.json và target/admin-account-http-results.json. Chưa commit/push; giữ nguyên thay đổi thanh toán và file của phiên khác.

## Hoàn thiện giao diện 6 trang admin — 2026-11-19

- Đồng bộ giao diện tài khoản/dịch vụ/combo/phòng/ca/thú cưng: sidebar PetCare, breadcrumb, avatar, số bản ghi, form, bảng, badge và trạng thái tiếng Việt. Form tạo tài khoản đóng/mở bằng details; label liên kết input bằng ID.
- Thêm tìm kiếm không dấu và bộ lọc ngay trong bảng, số kết quả/không có kết quả. Giá định dạng Việt Nam, hiển thị tên chủ/nhân viên; giữ toàn bộ tên input/action/CSRF và URL backend.
- CSS responsive: sidebar desktop, menu cuộn ngang mobile, bảng cuộn riêng không kéo rộng trang. Fragment JSP có pageEncoding UTF-8 riêng (đã phát hiện và sửa lỗi dấu khi chạy Jasper).
- Kiểm tra đủ 6 trang HTTP 200 qua Tomcat preview fixture, trình duyệt desktop 1440x1000 và mobile 390x844 không tràn toàn trang. Tìm không dấu/lọc/mở form/focus/chuyển sửa sang thêm mới/chặn giá âm đạt. Không có input/select thiếu label ở lượt kiểm tra.
- Build WAR và 26 test JUnit PASS; 1 test DB tích hợp bỏ qua trong lượt sửa UI. Node syntax, selector HTTP test và git diff --check đạt. Không kết nối/ghi DB trong preview.
- Test hộp xác nhận xóa bị công cụ browser chặn ở focus, không tính PASS; khôi phục tab/viewport bằng API chưa thành công. Auto-review từ chối chụp cửa sổ host do có thể lộ nội dung ngoài preview; chỉ dùng ảnh từ tab preview đã lưu trước đó.
- Chi tiết: docs/ADMIN_UI.md; ảnh target/admin-ui-screenshots/desktop.jpg và mobile.jpg. Fixture/servlet preview chỉ ở target, không đưa vào WAR chính. Chưa deploy server chính, không áp dụng migration SQL đang chờ duyệt; chưa commit/push. Process preview dọn sau kiểm tra.

## Bảo vệ tài khoản ADMIN khỏi quản trị viên khác — 2026-11-19

- Theo yêu cầu người dùng: tài khoản ADMIN được bảo vệ trong trang quản lý tài khoản; không cho khóa/mở, hạ quyền, sửa hồ sơ hoặc reset mật khẩu ADMIN tại đây. Admin dùng trang hồ sơ cá nhân để tự cập nhật thông tin/đổi mật khẩu.
- QuanLyTaiKhoanServlet từ chối cả request POST gửi trực tiếp, kể cả có CSRF hợp lệ. Chặn hạ quyền trước rồi khóa và thay email/reset mật khẩu để chiếm tài khoản. Tài khoản STAFF/CUSTOMER vẫn quản lý bình thường; vẫn cho tạo/nâng tài khoản lên ADMIN.
- AccountDAO/Impl bổ sung updateManagedProfile, setManagedActive, resetManagedPassword: kiểm tra lại người thao tác còn ADMIN đang hoạt động và đích không phải ADMIN, khóa đọc UPDLOCK/HOLDLOCK và ghi cùng connection/transaction. Nếu đích vừa được nâng ADMIN sau kiểm tra Servlet thì DAO vẫn chặn. Không dùng fallback sang DB khác cho các thao tác này. Procedure hiện có và fallback SQL đều nằm sau kiểm tra, trong cùng transaction; đổi trạng thái không ghi lại role.
- JSP ẩn toàn bộ form khóa/sửa/reset của hàng ADMIN, hiển thị badge Được bảo vệ; hàng chính mình có liên kết /profile. JSP fixture HTTP 200: ADMIN không có form quản lý, STAFF vẫn có đủ 3 form. Không ghi DB trong lượt này, không cần migration mới.
- Đã quan sát 4 regression test FAIL trước sửa; sau sửa 13 test Servlet + 11 test DAO protection + 6 test AuthService/AuthFilter = 30/30 PASS. Test DAO dùng JDBC giả, gồm thay đổi vai trò sau kiểm tra, quyền người thao tác bị thu hồi, inactive, missing target, lỗi SQL rollback, phân biệt hoa thường, thứ tự tham số fallback và thao tác bình thường.
- Kiểm tra cuối: compile toàn bộ Java vào thư mục kiểm tra riêng thành công; toàn bộ suite 55 PASS, 1 integration test opt-in SKIPPED; WAR build thành công. Lỗi API thanh toán từ phiên song song từng chặn build đầu lượt đã hết ở lần kiểm tra cuối; không sửa phần thanh toán trong thay đổi này.
- Script scripts/test-admin-accounts.ps1 bổ sung các POST tấn công tài khoản ADMIN trên môi trường QA disposable; phần HTTP mới chưa chạy với DB thật. Process render JSP fixture đã dừng. Chưa deploy/restart Tomcat chính, chưa commit/push.

## Bổ sung quản lý lịch hẹn và báo cáo admin — 2026-11-19

- Theo yêu cầu người dùng, đã có /admin/lich-hen và /admin/bao-cao trong menu admin. Lịch: lọc theo ngày bắt đầu/trạng thái/loại/từ khóa, phân trang 25, xem khách/thú cưng/dịch vụ/nhân viên/phòng/giao dịch, chuyển trạng thái hợp lệ bằng procedure hiện có; hủy có lý do, chặn stale POST và xác minh ADMIN trong transaction. Tạo lịch dùng luồng tại quầy đã có.
- Báo cáo kỳ tối đa 366 ngày: lịch tạo theo trạng thái, khách/thú cưng mới, tiền thu/hoàn PAID theo ngày xác nhận, thực thu, top dịch vụ, biểu đồ ngày và CSV. Tổng tiền tính độc lập dòng dịch vụ để không cộng trùng; không tính PENDING/FAILED. Không cần schema/procedure mới.
- Giải thích Thú cưng: hồ sơ thuộc khách, tái dùng cho các lần đặt dịch vụ/lưu trú; khách quản lý trong hồ sơ cá nhân, admin xem toàn hệ thống. Phát hiện QuanLyThuCungServlet hiện trở lại scaffold nên nối lại /admin/thu-cung với module PETS; kiểm tra GET thật 200 và thấy dữ liệu QA.
- Full suite: 71 PASS/1 integration cũ SKIPPED; thêm test thiếu status rồi nhóm 15 test liên quan PASS (72 ca khác nhau đã thực thi đạt). Hai test SQL mới chạy trên DB PetCareOperationsQA_3de63ace04 với schema/fixture thật; 29/29 HTTP PASS, JSP desktop/mobile 1440/390 không tràn toàn trang. Build WAR, JS/PowerShell syntax, git diff --check đạt. Thử DENY ghi trực tiếp trên QA vẫn cập nhật qua procedure thành công.
- Không ghi nghiệp vụ hay đổi quyền/schema DB chính. Server/DB QA dọn sau test, cấu hình QA tạm xóa. Chưa deploy/restart server chính; chưa commit/push. Công việc lịch nhân viên của phiên khác giữ nguyên.
- Chi tiết định nghĩa chỉ số, test, ảnh và chạy lại: docs/ADMIN_OPERATIONS.md; báo cáo target/admin-operations-http-results.json, ảnh target/admin-operations-screenshots.

## Kiểm tra giao diện staff — 19/11/2026
Đã sửa menu/header responsive cho 3 trang staff, nhãn form, escape dữ liệu khách, giữ context khi lỗi thêm pet, CSRF cho POST và bảo vệ JSP qua WEB-INF. 35 kiểm tra HTTP đạt trên QA riêng; Maven 79 test (76 đạt, 3 tích hợp bỏ qua), WAR build thành công. Kiểm tra trình duyệt desktop/mobile 390px đạt. Chưa thử thu tiền thực tế; xem docs/STAFF_UI_REVIEW.md về giới hạn thanh toán và lịch nhiều nhân viên. Không đổi database PetCare chính.

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

Theo yêu cầu người dùng: link "Quên mật khẩu?" trên `login.jsp` trước đó chết (trỏ về chính `/login`). Đã làm theo thứ tự thư viện → cấu hình → logic như yêu cầu.

- Thêm `jakarta.mail-api:2.1.3` + `org.eclipse.angus:angus-mail:2.0.3` vào `pom.xml`. `MailUtil.send(to, subject, htmlBody)` (mới, trong `utils`) gửi qua Gmail SMTP (`smtp.gmail.com:587`, STARTTLS, App Password — không dùng mật khẩu Gmail thật).
- Cấu hình `mail.smtp.*` theo đúng pattern đã có với DB: placeholder an toàn trong `src/main/resources/application.properties` (đóng gói vào WAR), giá trị thật trong `application-local.properties` ở root (git-ignored, không đóng gói).
- Luồng: `/quen-mat-khau` (GET form, POST gửi email — **luôn trả lời chung chung** dù định danh có tồn tại hay không, chống dò email/SĐT) → email chứa link `/dat-lai-mat-khau?token=...` (hết hạn 15 phút, dùng 1 lần) → `/dat-lai-mat-khau` đặt mật khẩu mới.
- **Bảo mật token**: chỉ lưu SHA-256 hash của token (32 byte `SecureRandom`, Base64 URL-safe) trong DB — không bao giờ lưu token gốc, giống cách không lưu mật khẩu gốc. Mỗi lần yêu cầu mới sẽ xoá token chưa dùng cũ của user đó.
- `database/petcare_password_reset.sql`: bảng `dbo.PasswordResetTokens` (idempotent) + 2 procedure (`CreatePasswordResetToken`, `ConsumePasswordResetToken`) + GRANT cho role `petcare_admin_app`. **Đã chạy xong trên DB chính** (gặp lỗi "CREATE TABLE/PROCEDURE permission denied" khi chạy bằng tài khoản `petcare_backend` — phải đăng nhập SSMS bằng tài khoản db_owner/sysadmin mới chạy được; đã chạy lại đúng cách và xác nhận OK).
- `AuthService` thêm `requestPasswordReset`/`resetPasswordWithToken`; việc gửi mail đi qua interface nội bộ `AuthService.MailSender` (mặc định = `MailUtil::send`) để test không gọi mạng thật — ban đầu quên làm việc này, 1 test JUnit thực sự gửi mail thật mất ~5 giây mới phát hiện ra, đã sửa.
- Test: 5 test mới trong `AuthServiceTest`. Maven 87 test: 84 đạt, 3 tích hợp DB bỏ qua; build WAR đạt (đã kiểm tra file `application.properties` đóng gói trong WAR chỉ có placeholder, không lộ App Password thật).
- **Đã commit và push lên `origin/Thanhhien`** (`a01734c`). Chi tiết & giới hạn đã biết (chưa có rate-limit chống spam yêu cầu reset): docs/PASSWORD_RESET.md.

## Xác thực email khi đăng ký qua Gmail SMTP — 20/11/2026

Tiếp theo tính năng quên mật khẩu ở trên — theo yêu cầu người dùng, tài khoản mới đăng ký phải xác thực email qua link gửi về Gmail trước khi được đăng nhập (không chỉ gửi mail chào mừng thông thường).

- `AuthService.registerCustomer` thêm tham số `verifyPageBaseUrl`, vẫn tạo tài khoản `is_active = true` như cũ (**không đổi gì ở bảng `Users` hay procedure `GetAccountById`/`FindAccountByIdentifier` đang chạy sẵn trên DB chính** — tránh phải sửa + chạy lại migration cũ bằng tay thêm 1 lần nữa).
- Trạng thái "đang chờ xác thực" chỉ suy ra từ việc **còn tồn tại 1 token `EmailVerificationTokens` chưa dùng/chưa hết hạn cho user đó** — bảng + 2 procedure hoàn toàn mới, độc lập, không đụng tới DAO/procedure cũ nào. `AuthService.authenticate` chặn đăng nhập nếu còn token này, với thông báo riêng (khác "tài khoản bị khóa" của admin).
- **Đã cố ý thiết kế chống khoá tài khoản vĩnh viễn khi mail lỗi**: trong `registerCustomer`, gửi email TRƯỚC, chỉ lưu token NẾU gửi thành công — nếu Gmail SMTP lỗi, tài khoản mới không bị chặn đăng nhập (vì chặn mà người dùng chưa từng nhận được link, phải chờ 24h mới hết hạn, sẽ tệ hơn không có tính năng). Đồng thời `EmailVerificationDAOImpl.hasPendingVerification` **không bao giờ throw lỗi** (fail-open) — nếu quên chạy migration hoặc DB trục trặc, đăng nhập của mọi tài khoản khác vẫn hoạt động bình thường, tính năng chỉ "chưa bật" cho tài khoản đó.
- `database/petcare_email_verification.sql`: bảng `dbo.EmailVerificationTokens` + `CreateEmailVerificationToken`/`ConsumeEmailVerificationToken` + GRANT EXECUTE 2 procedure + **GRANT SELECT trực tiếp trên bảng** (vì việc kiểm tra "còn token chờ không" là SELECT thuần không qua procedure, nên không được hưởng ownership chaining). **Chưa áp dụng DB chính** — cần ai đó trong nhóm tự chạy file này bằng tài khoản db_owner/sysadmin (không phải `petcare_backend`) trước khi tính năng hoạt động thật; trước khi chạy, đăng ký tài khoản vẫn hoạt động bình thường (không bị chặn đăng nhập) nhờ thiết kế fail-open ở trên.
- `XacThucEmailServlet` (`/xac-thuc-email`) tiêu thụ token rồi redirect về `/login` kèm thông báo — tái dùng khung alert có sẵn của `login.jsp`, không tạo JSP mới.
- Dùng lại nguyên `MailUtil`/`AuthService.MailSender` và hàm sinh/băm token (đổi tên `generateResetToken` → `generateSecureToken` để dùng chung cho cả 2 tính năng) đã viết ở mục trên — không viết lại logic trùng lặp.
- Test: 6 test mới trong `AuthServiceTest`. Maven 93 test: 90 đạt, 3 tích hợp DB bỏ qua; build WAR đạt.
- **Đã commit và push lên `origin/Thanhhien`** (`f060a00`). Chi tiết & giới hạn đã biết (chưa có nút gửi lại email xác thực): docs/EMAIL_VERIFICATION.md.

## Tổng hợp báo cáo PetCare giai đoạn 1 — 2026-11-26

- Đã bổ sung giới thiệu, phạm vi, chức năng, Use Case, ERD ba mức và bốn ví dụ CRUD vào [báo cáo tổng hợp](https://docs.google.com/document/d/1Top9L6ZTsECizQXpI7fEzXNIo6A-lIyb0EBB8Rf49oU/edit). Có sáu hình và liên kết đến bốn báo cáo Lab, gồm từ điển dữ liệu và DDL ở Lab 3.
- Đã đọc lại Google Docs để xác nhận đủ bảy mục, sáu hình, bốn ví dụ và bốn liên kết.

## Bổ sung các chức năng làm thêm vào báo cáo — 2026-11-26

- Đã thêm mục riêng gồm bảy nhóm chức năng mở rộng của PetCare vào Google Docs. Đã đối chiếu nội dung với tài liệu dự án và đọc lại đủ bảy nhóm sau khi lưu.
- Đã ghi rõ tiêu đề Phần làm thêm 1 đến Phần làm thêm 7 trong báo cáo và kiểm tra đủ bảy tiêu đề.
- Đã viết chi tiết cách thao tác, điều kiện và kết quả cho bảy phần làm thêm trong Google Docs. Đã đọc lại đủ bảy phần và xác nhận mục thiết kế Figma vẫn có trong báo cáo.
- Đã thêm mục lục ở đầu báo cáo, gồm 16 liên kết nội bộ đến các mục chính, nhóm chức năng làm thêm, bảy phần làm thêm và thiết kế Figma. Đã kiểm tra từng liên kết trỏ tới đúng tiêu đề.
- Đã chỉnh trình bày mục lục với tiêu đề xanh đậm, đường kẻ, nền nhạt theo nhóm và khoảng cách dòng dễ đọc. Đã kiểm tra đủ 16 liên kết nội bộ sau khi định dạng.
- Đã thiết kế lại mục lục thành hai cột, dùng nền xanh nhạt và viền mảnh. Đã kiểm tra đủ 16 liên kết và bỏ danh sách mục lục cũ sau khi xác nhận nội dung khớp.

## Kiểm tra kết nối DB ngày 2026-11-26
- Compile các lớp ConfigUtil, DBUtil, DatabaseConnectionTest hiện tại vào target/db-check rồi chạy truy vấn chỉ đọc ngoài sandbox.
- JDBC trực tiếp tới hung211.tail1f20d2.ts.net:1433 thất bại, SQLState 08S01: No such host is known (không phân giải được tên máy chủ). Chưa tới bước xác thực SQL.
- DatabaseConnectionTest kết nối thành công bằng fallback SQL Server local, DB PetCare, COUNT dbo.Users = 17. Kết quả này chỉ xác nhận DB local, không xác nhận server Tailscale dùng chung hoạt động.
- Không sửa cấu hình, quyền, schema hoặc dữ liệu trong lần kiểm tra này.

## Đã tìm và xử lý nguyên nhân DNS SQL — 2026-11-26
- Tailscale hiện Running; hostname Bunnny, DNS bunnny.tail1f20d2.ts.net, IP 100.90.157.31. Tên hung211.tail1f20d2.ts.net cũ không còn phân giải được.
- SQL Server TCP Enabled, ListenOnAllIPs, 0.0.0.0:1433 LISTENING. DNS mới phân giải đúng về 100.90.157.31.
- Đã thử JDBC trực tiếp bằng hostname mới: PetCare, server DESKTOP-VO3JCGJ\SQLEXPRESS, 17 tài khoản; không dùng fallback.
- Đã thay hostname cũ bằng mới trong application-local.properties trên máy này (file gitignore); không đổi tài khoản, mật khẩu, TLS hoặc dữ liệu. Thành viên phải tự cập nhật file local/DB_URL vì file local không đi theo Git.
- Khởi động lại Tomcat sau khi thay cấu hình để ConfigUtil nạp lại và xóa trạng thái circuit breaker cũ.
