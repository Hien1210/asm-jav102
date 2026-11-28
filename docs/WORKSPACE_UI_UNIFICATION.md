# Đồng bộ giao diện Admin, Staff và hồ sơ — 28/11/2026

## Vấn đề và kết quả

Trước thay đổi, hồ sơ STAFF có cover/nút navy và header website công khai, trong khi các trang staff dùng portal xanh mint từ Figma. Admin lại có sidebar trắng và bộ màu riêng. Khi chuyển trang, người dùng thấy ba hệ giao diện khác nhau.

- Thêm `assets/css/workspace.css`: dùng chung token xanh `#006c49`, mint `#bbffe3`, sidebar `#eff4ff`, canvas `#f8f9ff`, font, chiều rộng sidebar, trạng thái menu, nút và ô nhập.
- Thêm `WEB-INF/includes/workspaceBrand.jspf`: Admin/Staff dùng cùng logo và cấu trúc thương hiệu, chỉ khác nhãn ADMIN PORTAL / STAFF PORTAL và đường dẫn theo vai trò.
- Tám trang admin (tài khoản, năm danh mục, lịch hẹn, báo cáo) và bốn trang staff tải stylesheet chung.
- `profile.jsp` chọn shell theo role: ADMIN dùng shell admin, STAFF dùng header/sidebar staff; CUSTOMER giữ header/footer website hiện có. Hồ sơ ADMIN/STAFF dùng cùng xanh/mint, có menu Hồ sơ cá nhân đang chọn, không còn chuyển sang header công khai.
- Menu mobile của workspace cuộn ngang, giữ đủ các mục và không kéo rộng trang. Sidebar/content dùng chung biến chiều rộng tại mỗi breakpoint.
- Cập nhật nhãn lịch làm việc theo tuần và sửa nội dung “BCrypt 256-bit” thành “BCrypt” cho đúng cách băm mật khẩu hiện có.

## Xác minh

- 15 trang/biến thể đã render HTTP 200 trên Tomcat preview riêng dùng dữ liệu mẫu: 8 admin, 4 staff, profile ADMIN/STAFF/CUSTOMER. Trang tài khoản dùng JSP fixture riêng do servlet preview bắt `/admin/*`; fixture nằm trong target, không sửa route ứng dụng thật.
- 42 kiểm tra responsive trong phạm vi Admin/Staff tại 320/768/1440px đều không tràn ngang: 8 admin, 4 staff, 2 hồ sơ × 3 kích thước.
- Kiểm tra thêm hồ sơ CUSTOMER: vẫn dùng giao diện công khai; có tràn header ở 320px từ bố cục website ngoài phạm vi đồng bộ workspace, chưa xử lý trong lần này.
- Đã quan sát hồ sơ STAFF, hồ sơ ADMIN, danh mục dịch vụ, quản lý tài khoản; mở/đóng hộp chỉnh ảnh bìa thành công. Không upload ảnh, gửi form hồ sơ, đổi mật khẩu hoặc thực hiện giao dịch.
- Đối chiếu các thẻ form/input/select với HEAD: contract `action`, `name` và các hidden input hồ sơ không thay đổi. Không sửa Servlet/DAO, phân quyền, CSRF hoặc dữ liệu DB.
- Console preview không có lỗi. `git diff --check` đạt. Thay đổi chỉ JSP/CSS; không viết test logic mới.
- Kết quả: `target/workspace-render-results.json`, `workspace-responsive-results.json`, `workspace-accounts-responsive.json`. Ảnh ở `target/workspace-screenshots/profile-staff.jpg`, `profile-admin.jpg`, `admin-services.jpg`, `profile-staff-mobile.jpg`.

## Nạp bản mới

Thay đổi có trong source và bản WAR được đóng gói lại. Chạy lại/nạp lại artifact Tomcat đang dùng, rồi tải lại trình duyệt; không áp dụng SQL migration cho thay đổi giao diện này. Các servlet/JSP fixture chỉ phục vụ preview, không đưa vào WAR.
