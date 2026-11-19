# Lịch hẹn và báo cáo admin

## Phạm vi

- `/admin/lich-hen`: xem toàn hệ thống, lọc theo ngày hẹn/trạng thái/loại, tìm tên khách/thú cưng/điện thoại, phân trang 25 dòng; mở chi tiết dịch vụ/nhân viên hoặc lưu trú/phòng và lịch sử thanh toán.
- Cập nhật trạng thái theo state machine hiện có của `SetAppointmentStatus`. Hủy phải có lý do. Không sửa giá/nhân viên/giờ của lịch đã công bố; không xóa lịch hẹn. Nút tạo lịch nối luồng đặt tại quầy đang có.
- `/admin/bao-cao`: lọc tối đa 366 ngày; số lịch tạo trong kỳ, phân bổ trạng thái, khách/thú cưng mới; thu/hoàn/thực thu dựa trên `Payments.paid_at` và `status=PAID`. Tiền chờ xác nhận/thất bại không phải tiền đã thu. Thống kê lượt dịch vụ không nhân với số giao dịch thanh toán. Có chuỗi ngày và xuất CSV.
- Chỉ ADMIN; POST đổi trạng thái có CSRF, kiểm tra lại quyền và trạng thái hiện tại khi ghi. GET báo cáo không ghi DB.
- Tái sử dụng schema/procedure hiện có; không áp dụng migration quyền SQL lên DB chính.

## Cách hiểu hồ sơ thú cưng

`Pets` là hồ sơ thú cưng thuộc một khách hàng, dùng chung cho các lần đặt dịch vụ/lưu trú. Hồ sơ gồm tên, chủ, loài/giống, cân nặng, ngày sinh, ghi chú. `Appointments.pet_id` nối lịch với đúng bé. Trang admin xem hồ sơ toàn hệ thống; trang khách hàng chỉ quản lý thú cưng thuộc chính tài khoản. Ghi chú sức khỏe hiện là văn bản, không phải phân hệ bệnh án/chẩn đoán.

## Tiêu chí kiểm thử

1. Khoảng ngày hợp lệ, bao gồm trọn ngày cuối; từ chối ngày sai/đảo chiều/khoảng quá lớn.
2. Chỉ cho chuyển trạng thái hợp lệ; hủy có lý do, lịch kết thúc không bị mở lại, request cũ không ghi đè trạng thái mới.
3. Khách/nhân viên không truy cập trang admin; thiếu/sai CSRF không ghi dữ liệu.
4. Tiền thu/hoàn độc lập với số dịch vụ; chỉ PAID, đúng khoảng ngày thanh toán; CSV khớp số hiển thị.
5. Test unit, SQL/schema thật trên DB QA riêng, HTTP/JSP và build WAR. Không đổi dữ liệu nghiệp vụ thật để test.

Kết quả thực hiện được cập nhật ở cuối tài liệu.

## Kết quả thực hiện — 2026-11-19

- Đã thêm AdminOperationsServlet, AdminOperationsDAO, AdminOperationsPolicy và model AdminReport. Hai trang dùng layout/CSRF/phân quyền admin hiện có, menu có Lịch hẹn và Báo cáo hệ thống.
- Lịch hẹn: lọc theo ngày bắt đầu, trạng thái, loại, từ khóa; phân trang; chi tiết dịch vụ/nhân viên/phòng/giao dịch; cập nhật qua SetAppointmentStatus. Actor ADMIN đang hoạt động và trạng thái đích được kiểm tra lại cùng transaction; POST cũ bị từ chối. Có liên kết luồng tạo lịch tại quầy sẵn có. Không tự hoàn tiền khi hủy lịch.
- Báo cáo: số lịch theo ngày tạo và trạng thái hiện tại, khách/thú cưng mới, tiền thu/hoàn PAID theo paid_at, thực thu và top 10 lượt dịch vụ. Dòng tiền không join với từng dòng dịch vụ; tổng lấy từ cùng chuỗi ngày dùng cho CSV. Biểu đồ hiển thị tối đa 14 ngày cuối kỳ, bảng/CSV giữ toàn kỳ. Tiền hiển thị giữ tối đa 2 chữ số thập phân.
- Trang Thú cưng được bổ sung giải thích; phát hiện QuanLyThuCungServlet đã trở lại scaffold nên nối lại /admin/thu-cung với AdminModule.PETS. Kiểm tra GET thật trả HTTP 200 và hiển thị hồ sơ QA. Luồng khách hàng quản lý thú cưng nằm trong ProfileServlet/trang hồ sơ cá nhân.
- Không thêm schema/procedure/quyền SQL mới trên DB chính. Cần quyền SELECT các bảng hiện có (như migration petcare_customer_features.sql đã khai báo) và EXECUTE dbo.SetAppointmentStatus. Thử thêm DENY ghi trực tiếp trên schema trong DB QA: cập nhật vẫn thành công qua ownership chain của procedure hiện có.

### Kiểm thử

- Full suite đầu lượt: 71 PASS, 1 test AdminCatalogIntegrationTest opt-in SKIPPED, gồm 2 test SQL tích hợp mới. Sau đó thêm 1 ca thiếu status và chạy lại nhóm 15 test policy/model/Servlet: 15/15 PASS. Tổng 72 ca khác nhau đã thực thi đạt; không cộng lượt chạy lại thành test mới.
- SQL tích hợp trên PetCareOperationsQA_3de63ace04, dùng schema petcare.sql và fixture admin-operations-fixture.sql. Xác minh tổng thu 350.000, hoàn 50.000, thực thu 300.000 dù lịch có nhiều dòng dịch vụ; giao dịch PENDING/FAILED không tính. Kiểm tra ngày không có dữ liệu, lọc loại/thú cưng, ký tự wildcard tìm literal, chi tiết, STAFF bị từ chối, state machine hoàn thành/hủy và request cũ.
- 29/29 HTTP PASS: guest/STAFF/CUSTOMER, admin login, JSP danh sách/chi tiết/lưu trú, bộ lọc sai, khoảng ngày, CSRF, chỉ đọc báo cáo, CSV khớp tiền, lý do hủy, cập nhật và stale POST. Báo cáo: target/admin-operations-http-results.json.
- Trình duyệt thật: lọc ngày, menu, báo cáo đúng số từ QA, 3 lịch hiển thị; desktop 1440×1000 và mobile 390×844 không tràn ngang toàn trang. Form chi tiết không thiếu label và tự required lý do khi chọn hủy. Có một lỗi ViewTransition opt-in disabled ở navigation của browser; không có thất bại HTTP hoặc chức năng đi kèm trong lượt test.
- Build WAR thành công; node --check, cú pháp PowerShell và git diff --check đạt. Ảnh dưới target/admin-operations-screenshots là dữ liệu QA, không phải dữ liệu khách thật.

### Chạy lại

Chỉ dùng database mới, tách biệt, tên bắt đầu PetCareOperationsQA_. Cài schema petcare.sql vào DB rỗng đó, seed src/test/resources/admin-operations-fixture.sql, cấu hình kết nối QA riêng. Test tích hợp tự từ chối ghi nếu catalog không có prefix QA; bật bằng -Dpetcare.operations.integration=true và -Dpetcare.config=<file QA>. Chạy JUnit trước scripts/test-admin-operations.ps1; fixture có trạng thái nên cần DB mới cho mỗi lượt đầy đủ. Không chạy fixture trên PetCare chính.

Tomcat QA dùng loopback 127.0.0.1:18090. Server/DB QA được dọn sau kiểm thử; file cấu hình kết nối QA tạm được xóa. Chưa deploy/restart server chính, chưa commit/push. Giữ nguyên công việc lịch nhân viên đang được chỉnh ở phiên khác.
