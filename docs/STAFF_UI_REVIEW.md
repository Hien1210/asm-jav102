# Kiểm tra giao diện staff — 19/11/2026

## Phạm vi và thay đổi

- Kiểm tra ba route: `/staff/lich-hen`, `/staff/lich-lam-viec`, `/staff/dat-lich-tai-quay`.
- Dùng chung `WEB-INF/includes/staffHeader.jspf` và `assets/css/staff.css`: đủ menu, trạng thái đang chọn, hỗ trợ bàn phím, header dài và form trên mobile.
- Đưa JSP thực vào `WEB-INF/views/staff`; JSP cũ chuyển hướng đến controller để luôn có dữ liệu và token.
- Thêm `StaffCsrfFilter` cho mọi POST staff, giữ AuthFilter kiểm soát vai trò. Filter đặt UTF-8 trước khi đọc tham số.
- Gắn label với input/select; escape dữ liệu khách hàng trong thuộc tính và nội dung; giữ lựa chọn đặt lịch khi báo lỗi; giữ khách/thú cưng khi thêm thú cưng không hợp lệ.
- Giới hạn ngày hẹn từ ngày hiện tại, yêu cầu mã giao dịch khi chọn ONLINE, khóa nút đặt khi không có nhân viên phù hợp.
- Lịch hẹn hiển thị mã lịch, thời gian và từng lượt dịch vụ được giao; giải thích trạng thái áp dụng cho cả lịch hẹn.

## Kết quả xác minh

- Maven: 79 test, 0 lỗi, 3 test tích hợp opt-in bỏ qua; 76 test chạy đạt, gồm 6 test mới của StaffCsrfFilter. WAR build thành công.
- 35 kiểm tra HTTP đạt trên Tomcat riêng với database `PetCareStaffQA_2d024b21ff` dùng dữ liệu giả. Bao gồm chặn guest/customer, đủ menu, redirect JSP cũ, view nội bộ bị chặn, CSRF sai/thiếu, tra khách có sẵn, escape ký tự đặc biệt, giữ context khi thêm pet sai và trạng thái staff chưa có lịch.
- Trình duyệt thực: ba trang ở desktop và mobile 390×844. Không tràn ngang form tại quầy, không có input/select thiếu label; ONLINE bật required cho mã giao dịch.
- Ảnh: `target/staff-ui-screenshots/counter-mobile.jpg`, `counter-desktop.jpg`; kết quả HTTP: `target/staff-ui-http-results.json`.
- JavaScript syntax và `git diff --check` đạt. Console có một lỗi ViewTransition từ trang home trong lúc đăng nhập, không phát sinh từ các trang staff.

## Giới hạn

- Không kiểm tra giao dịch thu tiền thực tế và không triển khai lên server chính. Database và cấu hình QA tạm được dọn sau kiểm tra.
- Trạng thái backend vẫn ở cấp lịch hẹn; lịch nhiều nhân viên do quản trị viên cập nhật, staff bị backend từ chối cập nhật cả lịch.
- Luồng tại quầy hiện chưa có giao diện thu lại riêng nếu tạo lịch thành công nhưng bước thanh toán thất bại; cần xử lý riêng nếu muốn hoàn thiện khôi phục thanh toán.
- Không áp dụng migration hoặc thay đổi quyền vào database PetCare chính.

## Chạy lại

Dựng database thử riêng từ `database/petcare.sql`, chạy `src/test/resources/staff-ui-fixture.sql`, trỏ Tomcat thử vào database đó rồi chạy `scripts/test-staff-ui.ps1 -BaseUrl http://127.0.0.1:18091/petcare`. Fixture bị chặn nếu tên database không có tiền tố PetCareStaffQA_. Không chạy fixture trên dữ liệu thật.
