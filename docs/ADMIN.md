# Quản trị PetCare — 2026-11-19

## Chức năng và URL

| URL | Chức năng |
| --- | --- |
| `/admin/tai-khoan` | Danh sách, tạo/sửa vai trò, khóa/mở, reset mật khẩu; không tự khóa/tự bỏ quyền |
| `/admin/dich-vu` | Thêm/sửa/xóa dịch vụ, nhóm dịch vụ, giá, thời lượng, bật/tắt hoạt động |
| `/admin/combo` | Thêm/sửa/xóa combo và chọn nhiều dịch vụ, lưu cùng transaction |
| `/admin/phong` | Thêm/sửa/xóa phòng, mã phòng duy nhất, giá ngày, trạng thái |
| `/admin/ca-lam-viec` | Thêm/sửa/xóa ca, chọn nhân viên, kiểm tra khoảng giờ và trùng ca |
| `/admin/thu-cung` | Thêm/sửa/xóa thú cưng, chọn khách hàng, giống/loài/cân nặng/ngày sinh/ghi chú |

Menu quản trị nối cả sáu trang. Các JSP admin cũ chuyển hướng tới URL Servlet thật.

## Thiết kế

- `AdminModule`: danh sách trường/cột cố định và validation theo schema. Không nhận tên bảng/cột từ HTTP. Giới hạn giá/cân nặng, độ dài chuỗi, lựa chọn trạng thái, ngày sinh, ID dương và giờ kết thúc sau giờ bắt đầu.
- `AdminCatalogServlet`: vòng đời GET/POST, ADMIN, CSRF theo session, giữ input khi form sai, redirect sau ghi thành công. JSP thật nằm trong `WEB-INF/views/admin/catalog.jsp`.
- Năm Servlet `QuanLy*` chọn module và URL; `AdminCatalogDAO` đọc bằng prepared statement và ghi qua stored procedure. Các DAO đặt lịch cũ được giữ nguyên.
- Combo lưu bản ghi cha và danh sách dịch vụ trong cùng transaction; dịch vụ phải đang hoạt động và không thuộc BOARDING. Lỗi ghi bảng con rollback toàn bộ bản sửa.
- Không tắt trigger hoặc bỏ khóa ngoại. Xóa dữ liệu bị tham chiếu báo lỗi. Dịch vụ/combo có thể ngừng hoạt động thay vì xóa.
- Chủ thú cưng/nhân viên được kiểm tra đúng vai trò và đang hoạt động. Quy tắc DB về ca/lịch hẹn/phòng vẫn được áp dụng.
- JSP escape dữ liệu đầu vào khi hiển thị, có nhãn form, menu và bố cục responsive; bảng rộng cuộn ngang. Chưa kiểm thử viewport mobile bằng trình duyệt.

## Migration cần áp dụng trước khi dùng DB chính

File: `database/admin_catalog.sql`.

Điều kiện: database PetCare đã có schema `petcare.sql`, stored procedure/role `petcare_accounts.sql`, và login backend đã thuộc `petcare_admin_app` như thiết lập của dự án.

Migration tạo/cập nhật 11 stored procedure: 5 `AdminSave*`, 5 `AdminDelete*`, và `AdminSetComboServices`. Cấp EXECUTE cho các procedure này và SELECT trên bảng quản trị cho role `petcare_admin_app`; không cấp ghi trực tiếp, không đổi login, không xóa dữ liệu hay tắt trigger. Có thể chạy lại migration.

Migration **chưa cài trên PetCare chính**: automatic approval review từ chối thay đổi schema/quyền SQL lâu dài khi chưa có phê duyệt cụ thể. Chỉ cài trên DB QA tách biệt để kiểm chứng. Sau khi được duyệt, chạy migration bằng tài khoản SQL quản trị rồi deploy/restart WAR mới. Không chạy lại `petcare.sql` trên DB hiện có.

WAR đã đóng gói: `target/petcare.war`. Các thay đổi thanh toán hiện có trong workspace cũng nằm trong WAR; chúng thuộc phiên làm việc khác, không phải phần triển khai admin này.

## Bằng chứng kiểm thử

- **27/27 JUnit PASS**, gồm 1 bài DB tích hợp thao tác nhiều trường hợp CRUD/constraint/rollback. 4 test Servlet mới kiểm tra CSRF, validation, redirect sau POST và trạng thái form khi xóa thất bại.
- **69/69 HTTP PASS** qua `scripts/test-admin.ps1`: guest/STAFF/CUSTOMER bị chặn đúng, ADMIN mở sáu trang, thiếu token trả 403, tạo/sửa/xóa catalog, escape HTML, giữ dịch vụ combo khi sửa, trùng phòng/ca và dữ liệu bị tham chiếu bị chặn, redirect JSP cũ, dọn fixture.
- **13/13 HTTP tài khoản PASS** qua `scripts/test-admin-accounts.ps1`: tạo, sửa vai trò, login, khóa/mở, thu hồi session, reset, mật khẩu cũ bị từ chối, mật khẩu mới đăng nhập được, tự khóa và reset đích không tồn tại bị chặn.
- Quan sát trình duyệt thật: login ADMIN, menu sáu trang, trang dịch vụ và bố cục trang phòng. Các thao tác CRUD được kiểm chứng bằng HTTP và DB, chưa bấm từng form bằng trình duyệt.
- Build WAR, kiểm tra cú pháp hai script PowerShell, `git diff --check`: PASS.
- Báo cáo máy hiện tại: `target/surefire-reports`, `target/admin-http-results.json`, `target/admin-account-http-results.json` (không commit).
- DB QA dùng schema PetCare và tài khoản SQL ứng dụng, tên riêng `PetCareAdminQA_ee134de11d`; HTTP dùng Tomcat riêng loopback `127.0.0.1:18089`. DB chính chưa được chạy CRUD mới. DB QA và process QA được dọn sau kiểm thử.

Test tích hợp chỉ chạy khi truyền `-Dpetcare.integration=true` và `-Dpetcare.config=<file cấu hình QA>`; mặc định bỏ qua để tránh ghi DB ngoài ý muốn. Hai script HTTP mặc định dùng tài khoản QA và URL QA, chỉ chạy trên môi trường disposable.

Chưa commit/push.

## Quy tắc bảo vệ ADMIN (cập nhật 2026-11-19)

Trang quản lý không cho thao tác khóa/mở, hạ quyền, sửa email/hồ sơ hay reset mật khẩu với tài khoản ADMIN, gồm cả bản thân người đang đăng nhập. Thông tin/mật khẩu cá nhân được thay đổi qua `/profile` theo luồng xác thực hiện có. STAFF/CUSTOMER vẫn quản lý bình thường, có thể nâng lên ADMIN; khi đã là ADMIN thì trở thành tài khoản được bảo vệ. Không có vai trò super-admin mới.

Bảo vệ thực thi ở Servlet và các hàm quản lý riêng trong AccountDAOImpl; DAO giữ lock khi xác minh quyền người thao tác và vai trò đích đến lúc ghi/commit, không dùng trạng thái session/role cũ để quyết định. Không fallback sang DB khác. Các công cụ SQL/DBA trực tiếp nằm ngoài quyền hạn web; thay đổi này không sửa schema/quyền SQL.

UI: hàng ADMIN chỉ hiển thị Được bảo vệ và liên kết hồ sơ của chính mình, không sinh form quản lý. Kiểm chứng JSP qua HTTP với fixture. Kết quả cuối: 30 test bảo vệ/tài khoản liên quan PASS; toàn suite 55 PASS, 1 integration test SKIPPED; compile toàn bộ Java và đóng gói WAR thành công. Các test DAO dùng JDBC giả; chưa kiểm thử luồng ghi mới trên DB thật hoặc deploy server chính.

## Lịch hẹn và báo cáo đã bổ sung (2026-11-19)

Menu có thêm /admin/lich-hen và /admin/bao-cao: danh sách/chi tiết/phân trang/cập nhật trạng thái lịch; thống kê thu/hoàn/thực thu, lịch và lượt dịch vụ theo kỳ, xuất CSV theo ngày. Xem docs/ADMIN_OPERATIONS.md để biết định nghĩa số liệu, kiểm thử và điều kiện triển khai. Hồ sơ thú cưng được dùng lại giữa các lần đặt lịch, không phải một lịch hẹn riêng hay phân hệ bệnh án.
