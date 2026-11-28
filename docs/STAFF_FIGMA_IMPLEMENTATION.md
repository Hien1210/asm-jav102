# Triển khai 4 trang nhân viên từ Figma — 28/11/2026

Thiết kế nguồn: [PetCare Figma](https://www.figma.com/design/C1YfkM54eOBDw7S4SVdBa4/Untitled?node-id=95-2416). Link ban đầu trỏ vào một text node. Đã xác định frame cha và lấy design context, ảnh tham chiếu cho bốn màn hình. Người dùng xác nhận phạm vi chỉ gồm 4 trang nhân viên.

## Đối chiếu và triển khai

| Màn hình / frame | Thay đổi |
| --- | --- |
| Lịch hẹn — `95:1320` | Chọn ngày thực hiện (mặc định hôm nay), tìm không dấu theo khách/SĐT/thú cưng, lọc trạng thái, đếm kết quả, tên loài/giống và ghi chú sức khỏe từ Pets. Giữ các hành động check-in/bắt đầu/hoàn thành đã được backend cho phép. |
| Ca trực — `95:2320` | Tuần này/tuần sau/khoảng ngày, tối đa 31 ngày; danh sách ca, đánh dấu hôm nay, tổng số ca và giờ chính xác tới phút; lượt dịch vụ hôm nay, kỹ năng từ StaffSkills và giờ mở cửa từ BusinessHours. |
| Tại quầy — `95:2752` | Các bước khách/thú cưng/dịch vụ; thẻ chọn nhanh bé; tóm tắt khách, bé, ngày/giờ, người thực hiện, dịch vụ, giá dự kiến cập nhật theo form. Không dùng tên hay giá mẫu trong ứng dụng. |
| Tiền mặt — `96:3291` | Tổng quan tiền đã thu hôm nay và các khoản PENDING; danh sách khoản chờ kèm tên khách/bé, tra cứu mã lịch; nút xác nhận dùng đúng ConfirmCounterCash cũ; lịch sử CASH/CHARGE đã PAID trong ngày. Không thay đổi luồng ghi giao dịch. |

Khung chung chuyển sang sidebar nền `#eff4ff`, nền trang `#f8f9ff`, nút xanh `#006c49`, điểm nhấn mint và peach theo Figma. Menu đủ bốn trang, profile và đăng xuất; breadcrumb ngày hiện tại theo múi giờ Việt Nam. Icon gốc được tải về `assets/images/staff-figma`; không có URL asset Figma tạm trong JSP/CSS/JS. CSS/JS có phiên bản để tải bản mới.

## Dữ liệu và an toàn

- `StaffViewPolicy`: parse ngày nghiêm ngặt, tuần bắt đầu thứ Hai, khoảng custom 1–31 ngày, cộng phút ca làm.
- `StaffWorkspaceDAO`: chỉ SELECT kỹ năng, CASH PENDING của các lịch còn được thu, lịch sử CASH/CHARGE/PAID theo ngày. Giá trị staffId, appointmentId và ngày được bind qua PreparedStatement.
- Lịch hẹn vẫn lọc theo staffId của session phía server. Không mở quyền cho STAFF hủy lịch, đánh dấu vắng hoặc thao tác lịch của người khác.
- Mọi form POST vẫn có CSRF; dữ liệu tên/ghi chú được escape. Tóm tắt đơn dùng textContent, giá hiển thị không thay thế kiểm tra backend.
- Không chạy migration, cấp quyền mới, ghi dữ liệu thật hay deploy/restart Tomcat chính trong đợt này.

## Điều chỉnh so với bản thiết kế

Thiết kế có một số thông tin chưa tồn tại trong backend/schema hiện tại. Không hiển thị số liệu hay nút thao tác giả:

- Payments chưa ghi cashier/shift: tổng và lịch sử là **hôm nay, toàn hệ thống**, không gắn nhãn riêng ca. Tổng tiền đã thu chỉ gồm CASH/CHARGE/PAID, không phải doanh thu ròng sau hoàn tiền.
- Không có chỉ tiêu ca, điểm VIP, ảnh thú cưng, chi nhánh/ghi chú ca: không tạo dữ liệu giả để lấp các ô này.
- Tại quầy tiếp tục hỗ trợ một dịch vụ mỗi lần đặt qua WalkInBookingService. Các chế độ nhiều dịch vụ/combo/lưu trú và chọn CHECKED_IN mới trong Figma chưa có luồng backend tại quầy tương ứng, nên không thêm tab hoặc nút không hoạt động.
- Màn hình lịch được giao hiện quản lý các service line; boarding chưa có trường phân công nhân viên, nên không đưa boarding chưa phân công vào lịch cá nhân. Số đếm ghi rõ lượt dịch vụ, không gọi là số lịch duy nhất.
- Tiền mặt xác nhận các payment PENDING đã được tạo. Chưa thêm nghiệp vụ tạo khoản thu trực tiếp, thu số dư hoặc đích thu theo ca mới.

## Xác minh

- Đã quan sát test thất bại trước khi thêm StaffViewPolicy; sau triển khai 8/8 test mới đạt.
- Toàn suite Maven: **112 test, 109 đạt, 3 integration opt-in bỏ qua**, không lỗi. WAR build thành công.
- Bốn truy vấn SELECT mới/đã mở rộng đã chạy thành công trên schema cấu hình hiện tại: kỹ năng, khoản PENDING, lịch sử hôm nay và service line kèm ghi chú. Chỉ in thông báo thành công, không đưa thông tin khách hàng vào báo cáo.
- 12 tổ hợp trang/trạng thái normal/empty/error render HTTP 200 qua Tomcat preview riêng port 18094 dùng fixture, không kết nối DB. Báo cáo: `target/staff-figma-render-results.json`.
- 16 tổ hợp 4 trang × 320/390/768/1024px: không tràn ngang toàn trang, không ảnh lỗi, không ô nhập thiếu label, một menu active mỗi trang, đủ token cho POST. Báo cáo: `target/staff-figma-responsive-results.json`.
- Trình duyệt: chọn tuần sau chuyển đúng thứ Hai kế tiếp; tìm “nguyen thao vy” trả đúng một lượt; kết hợp trạng thái không khớp hiện empty state; tóm tắt đổi bé/dịch vụ cập nhật đúng 350.000 đ, ngày và nhân viên; ONLINE yêu cầu mã giao dịch. Console không có lỗi. Không bấm xác nhận thu tiền thật.
- Ảnh fixture: `target/staff-figma-screenshots/shifts-desktop.jpg`, `appointments-desktop.jpg`, `counter-desktop.jpg`, `cash-desktop.jpg` và ảnh mobile từng route.
- Preview servlet nằm trong target, không đóng gói vào WAR; process preview dừng sau kiểm tra. Bản nạp ứng dụng: `target/petcare.war`.

Chạy lại Tomcat hoặc nạp lại artifact đang dùng để nhận các lớp Java mới; nếu chỉ tải lại trình duyệt trong khi Tomcat giữ lớp cũ thì chưa có dữ liệu cho các phần mới.
