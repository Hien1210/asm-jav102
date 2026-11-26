# Giao diện nhân viên — 19/11/2026

## Thiết kế

Phạm vi gồm Lịch hẹn của tôi, Lịch làm việc và Đặt lịch tại quầy. Không có mẫu thiết kế bên ngoài do người dùng cung cấp; lấy màu xanh PetCare, cấu trúc menu quản trị đang có và nhu cầu thao tác của staff làm cơ sở.

- Desktop dùng sidebar xanh navy cố định, logo dấu chân vàng, breadcrumb và liên kết hồ sơ. Màn hình nhỏ chuyển menu thành bốn mục phía trên, không cần mở ngăn menu.
- Nền sáng, viền nhẹ, chữ tối; giữ nút chính màu xanh và badge có chữ để phân biệt trạng thái. Không thêm font hoặc thư viện bên ngoài.
- Lịch hẹn ưu tiên giờ bắt đầu/kết thúc, ngày, tên bé, dịch vụ, khách và nút xử lý theo trạng thái. Tổng quan đếm **lượt dịch vụ** trong danh sách 30 ngày đang tải, không phải số lịch hẹn duy nhất. Khi lỗi tải, ẩn tổng quan để tránh báo số 0 sai.
- Ca làm việc hiển thị ngày/khung giờ trong bảng cuộn riêng; có tổng số ca trong 14 ngày và liên kết qua lịch hẹn.
- Tại quầy dùng ba bước khách hàng → thú cưng → dịch vụ/thu tiền. Hiện thú cưng có sẵn và tên dịch vụ cùng nhân viên trong lựa chọn. Hướng dẫn bên phải chuyển xuống dưới trên màn hình hẹp.
- Giữ action, name, CSRF và các ràng buộc hiện có của form; không thay đổi controller/DAO, quyền hay luồng giao dịch.

## Kiểm tra

- Preview Tomcat riêng port 18092, chỉ dùng servlet fixture trong `target/staff-design-preview`, không kết nối database. Servlet preview không được đóng gói vào WAR chính; POST fixture không thực hiện giao dịch.
- Ba JSP biên dịch qua Jasper và HTTP 200 ở 9 tổ hợp trang/trạng thái thường, rỗng, lỗi. Kết quả: `target/staff-design-render-results.json`.
- Kiểm tra trình duyệt ba trang tại 320, 768, 1024px: không tràn ngang toàn trang, mỗi trang đúng một menu active, không có input/select thiếu label. Quan sát thêm desktop 1440×1000 và mobile 390×844.
- Thử mở phần thêm thú cưng, chọn ONLINE để bật required mã giao dịch, menu bằng bàn phím Enter. Các form vẫn chứa CSRF. Console preview không có lỗi.
- Đã kiểm tra trạng thái lịch trống và lỗi tải; lỗi không hiển thị tổng quan giả bằng 0. Không thử thu tiền hoặc ghi dữ liệu thật trong lần làm giao diện.
- Maven: 82 test, 0 lỗi, 3 test tích hợp opt-in bỏ qua (79 đạt). WAR build thành công, JavaScript syntax và `git diff --check` đạt.
- Ảnh: `target/staff-design-screenshots/appointments-desktop.jpg`, `appointments-mobile.jpg`, `counter-desktop.jpg`, `counter-mobile.jpg`, `shifts-desktop.jpg`. Ảnh dùng dữ liệu mẫu để kiểm tra bố cục.

## Nạp bản mới

WAR ở `target/petcare.war`; IntelliJ Smart Tomcat cần nạp lại artifact hoặc chạy lại để nhận JSP/CSS mới. Lần này chưa restart/deploy server người dùng đang chạy. Giới hạn backend đã ghi trong `STAFF_UI_REVIEW.md` vẫn áp dụng.
