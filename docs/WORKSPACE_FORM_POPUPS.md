# Popup thêm/sửa — 28/11/2026

- Năm trang danh mục Admin dùng dialog cho form thêm/sửa; danh sách mở rộng toàn chiều ngang. Link Sửa vẫn nạp dữ liệu qua controller, popup tự mở khi có bản ghi đang sửa hoặc hash `#editor`.
- Tài khoản: tạo mới, sửa thông tin và đặt lại mật khẩu hiển thị bằng popup. Các hàng ADMIN vẫn được bảo vệ như trước, không sinh nút sửa/reset mới.
- Staff tại quầy: thêm thú cưng bằng popup. Khi thêm sai, giữ các giá trị tên/loài/giống và mở lại thông báo lỗi.
- `workspace-dialog.js` dùng native dialog, nền mờ, nút X, Escape, bấm ngoài; browser giữ focus trong modal và trả focus về nút mở khi đóng. Đóng rồi mở lại không làm mất nội dung đang nhập.
- Di chuyển form gốc trong DOM, không clone form hay token. `action`, `name`, CSRF và backend giữ nguyên. Nếu trình duyệt không hỗ trợ dialog, form HTML cũ vẫn dùng được.
- Khi lỗi tài khoản, chỉ khôi phục tên/email/SĐT/role bằng giá trị được escape và textContent; không lưu lại mật khẩu vào HTML. Lỗi tạo/sửa tự mở đúng form theo action/userId.

## Kiểm tra

- Trình duyệt thực: thêm dịch vụ; sửa dịch vụ tự mở với giá/thời lượng đã tải; Escape trả focus; nhập rồi đóng/mở lại giữ nguyên giá trị; mở thêm/sửa tài khoản và thêm pet.
- Fixture lỗi sửa tài khoản tự mở đúng dialog, hiển thị lỗi và giữ chuỗi `<b>QA & Test</b>` dưới dạng giá trị văn bản, không tạo HTML.
- 10 trường hợp (5 danh mục × 320/1440px) đều mở dialog, không tràn ngang modal/trang, đủ CSRF. Popup pet quan sát thêm ở 390px. Console không có lỗi.
- Node syntax của admin.js và workspace-dialog.js đạt, git diff --check đạt. WAR đóng gói lại thành công. Không gửi form hoặc ghi DB trong kiểm tra này.
- Kết quả: target/dialog-browser-results.json. Ảnh: target/dialog-screenshots/add-service.jpg, add-pet-mobile.jpg.
- Các fixture kiểm tra chỉ ở target, không vào WAR. Chạy lại artifact/Tomcat và tải lại trang để nhận JS/CSS phiên bản mới.
