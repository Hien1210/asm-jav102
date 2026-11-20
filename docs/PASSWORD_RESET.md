# Quên mật khẩu qua Gmail SMTP — 20/11/2026

## Phạm vi
- Link "Quên mật khẩu?" trên `login.jsp` trước đây trỏ về chính `/login` (chết). Nay trỏ tới `/quen-mat-khau`.
- Luồng: `/quen-mat-khau` (GET form, POST gửi email reset) → email chứa link `/dat-lai-mat-khau?token=...` → `/dat-lai-mat-khau` (GET hiện form mật khẩu mới nếu có token, POST đặt mật khẩu mới).
- Phản hồi của `/quen-mat-khau` luôn là 1 thông điệp chung chung dù định danh có tồn tại hay không (chống user-enumeration qua email/SĐT).

## Token
- Token thật: 32 byte `SecureRandom`, Base64 URL-safe, gửi qua email. Chỉ lưu **SHA-256 hash** của token trong DB (`dbo.PasswordResetTokens.token_hash`), không bao giờ lưu token gốc — giống cách không lưu mật khẩu gốc.
- Hết hạn sau 15 phút (`AuthService.RESET_TOKEN_VALID_MINUTES`). Dùng 1 lần — `dbo.ConsumePasswordResetToken` đánh dấu `used_at` cùng transaction với việc đọc, tránh race khi submit 2 lần.
- Mỗi lần yêu cầu mới sẽ xoá các token chưa dùng còn lại của user đó (`dbo.CreatePasswordResetToken`), nên chỉ có 1 link reset còn hiệu lực tại một thời điểm.

## Database
- `database/petcare_password_reset.sql`: bảng `dbo.PasswordResetTokens` (idempotent `IF OBJECT_ID... IS NULL`) + 2 stored procedure (`CreatePasswordResetToken`, `ConsumePasswordResetToken`) + GRANT cho role `petcare_admin_app`.
- **Chưa áp dụng lên DB chính** — giống `admin_catalog.sql`, cần chạy thủ công trên SQL Server trước khi tính năng hoạt động thật.
- DAO (`PasswordResetDAOImpl`) có fallback SQL thuần nếu procedure chưa tồn tại (lỗi 2812/229), theo đúng pattern 2 tầng của các DAO cũ hơn. **Không** có tầng fallback PowerShell/SQL Express cục bộ (tầng 3) — theo đúng tiền lệ của các DAO admin mới nhất (`AdminCatalogDAO`, `AdminOperationsDAO`) cũng không có tầng này.

## Mail
- `MailUtil.send(to, subject, htmlBody)`: Jakarta Mail (`jakarta.mail-api` 2.1.3 + `angus-mail` 2.0.3) qua Gmail SMTP (`smtp.gmail.com:587`, STARTTLS, App Password — không dùng mật khẩu Gmail thật).
- Cấu hình: placeholder an toàn trong `src/main/resources/application.properties` (`mail.smtp.*`), giá trị thật trong `application-local.properties` (git-ignored).
- `AuthService` không gọi `MailUtil` trực tiếp mà qua interface nội bộ `AuthService.MailSender` (mặc định = `MailUtil::send`), để test có thể tiêm 1 mail sender giả — tránh test thật sự gửi email/gọi mạng.
- Gửi mail lỗi (SMTP down, sai cấu hình...) bị nuốt lặng lẽ trong `requestPasswordReset` — token vẫn đã lưu, không làm lộ việc định danh có tồn tại hay không qua lỗi khác nhau.

## Giới hạn đã biết
- Chưa có rate-limit cho việc spam yêu cầu reset (có thể bị lạm dụng để gửi nhiều email tới cùng 1 địa chỉ). Chưa làm vì ngoài phạm vi yêu cầu ban đầu.
- Chưa test gửi mail thật qua Gmail SMTP trong môi trường tự động (cần mạng + App Password thật); đã test qua JUnit với mail sender giả (không gọi mạng) và các nhánh validate/token.
- Migration SQL chưa chạy trên DB chính — cần người quản trị DB chạy `database/petcare_password_reset.sql` trước khi dùng thật.

## Test
- `AuthServiceTest`: 5 test mới — không tạo token khi định danh không tồn tại, tạo token khi định danh hợp lệ (mail sender giả), từ chối token sai/hết hạn, đặt lại mật khẩu thành công với token hợp lệ, từ chối mật khẩu mới quá ngắn.
- Maven: 87 test, 84 đạt, 3 tích hợp DB bỏ qua (môi trường không có DB QA); build WAR thành công.
