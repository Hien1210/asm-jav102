# Giao diện quản trị PetCare — 2026-11-19

## Phạm vi hoàn thiện

Áp dụng chung cho tài khoản, dịch vụ, combo, phòng lưu trú, ca làm việc và thú cưng.

- Sidebar nhận diện PetCare, biểu tượng SVG nội bộ, trạng thái mục đang mở, breadcrumb và tên quản trị viên từ session.
- Nền sáng/xanh PetCare; CSS chung thay cho style riêng trong trang tài khoản. Không thêm thư viện UI, font mạng hay ảnh từ bên ngoài.
- Số liệu tổng lấy từ danh sách thật. Trang tài khoản có số đang hoạt động; không thêm số liệu kinh doanh giả.
- Tìm kiếm ngay trong danh sách, hỗ trợ nhập tiếng Việt không dấu; bộ lọc lấy các trạng thái/nhóm thật có trong bảng. Có số kết quả và trạng thái không tìm thấy.
- Form catalog cạnh bảng ở màn hình rộng, chuyển xuống dưới bảng khi không đủ chỗ. Các cột ghi chú/mô tả dài không hiển thị trong bảng tóm tắt, vẫn sửa được trong form.
- Tên nhóm/trạng thái bằng tiếng Việt, giá định dạng Việt Nam, tên người sở hữu/nhân viên thay cho chỉ hiển thị ID khi có dữ liệu đối chiếu.
- Form tạo tài khoản đóng/mở bằng `details`; nút thêm mở form và focus trường đầu tiên. Mỗi input/select có label liên kết và ID riêng.
- Bảng cuộn ngang riêng, giữ thao tác catalog ở cạnh phải; mobile chuyển menu sang cuộn ngang, tránh kéo rộng toàn trang.
- Giữ nguyên URL, tên input/action, CSRF token và cơ chế ghi của backend. Nút thêm mới từ trang sửa mở form mới, không giữ ID đang sửa.

## File chính

- `src/main/webapp/WEB-INF/views/admin/shell-start.jspf`, `shell-end.jspf`: bố cục chung.
- `src/main/webapp/WEB-INF/views/admin/table-tools.jspf`: tìm kiếm và bộ lọc.
- `src/main/webapp/WEB-INF/views/admin/catalog.jsp`: năm trang catalog.
- `src/main/webapp/admin/quanLiTaiKhoan.jsp`: trang tài khoản đồng bộ giao diện.
- `src/main/webapp/assets/css/admin.css`, `assets/js/admin.js`: style và thao tác UI.

Các fragment đặt `pageEncoding="UTF-8"` riêng để Jasper không đọc sai dấu tiếng Việt.

## Kiểm chứng

- Render đủ 6 JSP qua Tomcat preview: HTTP 200, có token CSRF và menu tiếng Việt đúng encoding.
- Quan sát 6 trang bằng trình duyệt ở desktop 1440×1000 và mobile 390×844; không có tràn chiều ngang toàn trang, bảng/menu cuộn riêng.
- Kiểm tra tìm `le thao nguyen` khớp `Lê Thảo Nguyên`, lọc tài khoản đã khóa, thông báo không có kết quả, mở/focus form tạo tài khoản, mở bản sửa rồi chuyển về thêm mới, ràng buộc HTML chặn giá âm.
- Không có input/select thiếu label trong các trang đã kiểm tra. Không có cảnh báo/lỗi console ở lượt quan sát trước thử hộp thoại xóa; đây không phải chứng nhận WCAG đầy đủ.
- Build WAR thành công. Chạy lại 26 test JUnit: PASS; 1 test DB tích hợp được bỏ qua vì đợt này chỉ sửa giao diện.
- `node --check` cho admin.js, kiểm tra selector script HTTP theo markup `<tr data-record>`, `git diff --check`: PASS.

Lượt này dùng fixture trong ứng dụng preview dưới `target/admin-ui-preview`, không kết nối DB. Servlet/fixture preview **không nằm trong source hoặc WAR chính**. Ảnh desktop/mobile thể hiện dữ liệu mẫu; không phải dữ liệu thật của người dùng.

Thử hộp xác nhận xóa khiến trình duyệt tự động bị chặn ở lệnh focus; không tính bài hủy/xác nhận này là PASS, không thực thi xóa dữ liệu. Khôi phục tab/viewport bằng API cũng bị chặn. Yêu cầu chụp cửa sổ ứng dụng host bị auto-review từ chối vì có thể lộ nội dung riêng ngoài preview; không chụp cửa sổ đó. Ảnh bàn giao được lấy từ chính tab preview trước sự cố.

Báo cáo trên máy: `target/admin-ui-preview/http-checks.json`, `browser-checks.json`. Ảnh: `target/admin-ui-screenshots/desktop.jpg`, `mobile.jpg`.

WAR: `target/petcare.war`. Chưa deploy server chính, chưa thay đổi DB hay áp dụng migration đang chờ duyệt. Process Tomcat preview được dừng sau kiểm tra. Chưa commit/push.
