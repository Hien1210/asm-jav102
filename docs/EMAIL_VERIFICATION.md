# Xác thực email khi đăng ký — 20/11/2026

## Phạm vi
- Đăng ký (`/register`) vẫn tạo tài khoản `CUSTOMER` với `is_active = true` như cũ (không đổi gì ở `dbo.Users`/các procedure đang chạy sẵn trên DB chính).
- Ngay sau khi tạo tài khoản, hệ thống gửi 1 email chứa link `/xac-thuc-email?token=...` (hiệu lực 24 giờ, dùng 1 lần).
- `AuthService.authenticate` chặn đăng nhập nếu tài khoản còn 1 token xác thực **chưa dùng và chưa hết hạn** — thông báo riêng, khác với thông báo "tài khoản bị khóa" của admin.
- Bấm vào link trong email → `/xac-thuc-email` tiêu thụ token rồi redirect về `/login` kèm thông báo thành công/thất bại (tái dùng khung alert có sẵn của `login.jsp`, không tạo JSP mới).

## Vì sao không đổi bảng `Users`/procedure đang chạy
- Ban đầu định thêm cột `email_verified_at` vào `Users`, nhưng các procedure `GetAccountById`/`FindAccountByIdentifier` đã chạy sẵn trên DB chính sẽ cần sửa + chạy lại bằng tài khoản admin — thêm 1 bước thủ công nữa ngay sau khi bạn vừa phải tự tay chạy migration trước đó.
- Thay vào đó, trạng thái "đang chờ xác thực" chỉ được suy ra từ **có tồn tại 1 token `EmailVerificationTokens` chưa dùng/chưa hết hạn cho user đó hay không** — một bảng + 2 procedure hoàn toàn mới, độc lập, không đụng tới `Users` hay bất kỳ procedure cũ nào.

## Chống khoá tài khoản vĩnh viễn khi mail lỗi (quan trọng)
- Thứ tự trong `AuthService.registerCustomer`: **gửi email trước, chỉ lưu token nếu gửi thành công**. Nếu Gmail SMTP lỗi (sai cấu hình, mất mạng...), token sẽ không được lưu → tài khoản mới **không bị chặn đăng nhập**, vì chặn đăng nhập mà người dùng chưa từng nhận được link xác thực (và chờ 24 giờ mới tự hết hạn) sẽ là 1 bug tệ hơn không có tính năng này.
- Đây là đánh đổi có chủ đích: khi mail hoạt động bình thường, việc chặn đăng nhập hoạt động đúng như yêu cầu; khi mail lỗi, tính năng tự "tắt" cho riêng tài khoản đó thay vì khoá chết người dùng.

## Database
- `database/petcare_email_verification.sql`: bảng `dbo.EmailVerificationTokens` (idempotent) + `CreateEmailVerificationToken`, `ConsumeEmailVerificationToken` + `GRANT EXECUTE` cho 2 procedure + `GRANT SELECT` trực tiếp trên bảng (vì việc kiểm tra "còn token chờ xác thực không" là 1 câu SELECT thuần, không qua procedure, nên không được hưởng ownership chaining như 2 procedure kia).
- **Chưa áp dụng DB chính** — cần chạy bằng tài khoản db_owner/sysadmin giống `petcare_password_reset.sql`.
- `EmailVerificationDAOImpl.hasPendingVerification`: cố ý **không bao giờ throw** — nếu bảng chưa tồn tại (chưa chạy migration) hoặc DB trục trặc, trả về `false` (không chặn đăng nhập của ai khác). Nhờ vậy việc deploy code này trước khi chạy migration không làm hỏng đăng nhập của các tài khoản đã có từ trước.

## Mail & token
- Dùng lại nguyên `MailUtil`, `AuthService.MailSender` và cặp hàm sinh/băm token (`generateSecureToken`/`sha256Hex`, đổi tên từ `generateResetToken` để dùng chung) đã viết cho tính năng quên mật khẩu — không viết lại logic trùng lặp.
- Hết hạn 24 giờ (dài hơn 15 phút của reset mật khẩu, vì người dùng không nhất thiết mở email ngay sau khi đăng ký).

## Giới hạn đã biết
- Chưa có nút "gửi lại email xác thực" nếu bị lỡ/hết hạn — nếu quá 24h mà chưa bấm link, token tự hết hạn và (do thiết kế fail-open) tài khoản đó sẽ đăng nhập được bình thường luôn, không bị kẹt vĩnh viễn.
- Chưa test gửi mail thật qua Gmail SMTP tự động; test JUnit dùng mail sender giả.

## Test
- `AuthServiceTest`: 6 test mới — gửi mail thành công thì lưu token, mail lỗi thì không lưu token, đăng nhập bị chặn khi còn token chờ, đăng nhập được khi hết/không còn token chờ, xác thực token sai bị từ chối, xác thực token đúng thành công.
- Maven: 93 test, 90 đạt, 3 tích hợp DB bỏ qua; build WAR thành công.
