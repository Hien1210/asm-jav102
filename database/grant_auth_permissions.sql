USE [PetCare];
GO

-- =========================================================================
-- CẤP QUYỀN ĐĂNG NHẬP / ĐĂNG KÝ CHO ROLE & USER TRÊN DATABASE PETCARE
-- Chạy script này bằng tài khoản quản trị (sa / Windows Admin) trên SQL Server
-- =========================================================================

-- 1. Gỡ lệnh DENY toàn cục trên SCHEMA::dbo (vì DENY trong SQL Server sẽ chặn mọi lệnh GRANT)
IF DATABASE_PRINCIPAL_ID('petcare_booking_app') IS NOT NULL
BEGIN
    REVOKE INSERT, UPDATE, DELETE ON SCHEMA::dbo FROM petcare_booking_app;
    GRANT SELECT, INSERT, UPDATE ON dbo.Users TO petcare_booking_app;
    GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Pets TO petcare_booking_app;
    GRANT SELECT ON dbo.Services TO petcare_booking_app;
    GRANT SELECT ON dbo.Combos TO petcare_booking_app;
    GRANT SELECT ON dbo.ComboServices TO petcare_booking_app;
    GRANT SELECT ON dbo.BusinessHours TO petcare_booking_app;
    GRANT SELECT ON dbo.Rooms TO petcare_booking_app;
    GRANT SELECT ON dbo.Appointments TO petcare_booking_app;
    GRANT SELECT ON dbo.AppointmentServices TO petcare_booking_app;
    GRANT SELECT ON dbo.BoardingDetails TO petcare_booking_app;
    GRANT SELECT ON dbo.Reviews TO petcare_booking_app;
END;
GO

IF DATABASE_PRINCIPAL_ID('petcare_payment_app') IS NOT NULL
BEGIN
    REVOKE INSERT, UPDATE, DELETE ON SCHEMA::dbo FROM petcare_payment_app;
    GRANT SELECT ON dbo.Payments TO petcare_payment_app;
END;
GO

-- 2. Cấp quyền trực tiếp cho user petcare_backend (nếu đã tạo trong DB)
IF DATABASE_PRINCIPAL_ID('petcare_backend') IS NOT NULL
BEGIN
    REVOKE INSERT, UPDATE, DELETE ON SCHEMA::dbo FROM petcare_backend;
    GRANT SELECT, INSERT, UPDATE ON dbo.Users TO petcare_backend;
    GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Pets TO petcare_backend;
END;
GO

-- 3. Stored Procedures quản lý tài khoản (Đăng ký / Đăng nhập / Quản trị)
CREATE OR ALTER PROCEDURE dbo.FindAccountByIdentifier
    @identifier NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @clean NVARCHAR(100) = LTRIM(RTRIM(ISNULL(@identifier, N'')));
    DECLARE @cleanPhone NVARCHAR(100) = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@clean, N' ', N''), N'-', N''), N'.', N''), N'(', N''), N')', N''), N'+84', N'0');

    SELECT TOP 1 user_id, full_name, email, phone, password_hash, role, is_active, created_at
    FROM dbo.Users
    WHERE (@clean <> N'' AND LOWER(email) = LOWER(@clean))
       OR (@cleanPhone <> N'' AND REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(phone, N''), N' ', N''), N'-', N''), N'.', N''), N'(', N''), N')', N''), N'+84', N'0') = @cleanPhone)
       OR (@clean <> N'' AND phone = @clean);
END;
GO

CREATE OR ALTER PROCEDURE dbo.GetAccountById
    @user_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT user_id, full_name, email, phone, password_hash, role, is_active, created_at
    FROM dbo.Users
    WHERE user_id = @user_id;
END;
GO

CREATE OR ALTER PROCEDURE dbo.ListAccounts
AS
BEGIN
    SET NOCOUNT ON;
    SELECT user_id, full_name, email, phone, password_hash, role, is_active, created_at
    FROM dbo.Users
    ORDER BY created_at DESC;
END;
GO

CREATE OR ALTER PROCEDURE dbo.CreateAccount
    @full_name NVARCHAR(100),
    @email NVARCHAR(100),
    @phone NVARCHAR(20),
    @password_hash NVARCHAR(255),
    @role VARCHAR(20),
    @user_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Users (full_name, email, phone, password_hash, role, is_active)
    VALUES (@full_name, @email, @phone, @password_hash, ISNULL(@role, 'CUSTOMER'), 1);

    SET @user_id = CONVERT(INT, SCOPE_IDENTITY());
END;
GO

CREATE OR ALTER PROCEDURE dbo.UpdateAccount
    @user_id INT,
    @full_name NVARCHAR(100),
    @email NVARCHAR(100),
    @phone NVARCHAR(20),
    @role VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Users
    SET full_name = @full_name,
        email = @email,
        phone = @phone,
        role = @role
    WHERE user_id = @user_id;
END;
GO

CREATE OR ALTER PROCEDURE dbo.SetAccountActive
    @user_id INT,
    @is_active BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Users
    SET is_active = @is_active
    WHERE user_id = @user_id;
END;
GO

CREATE OR ALTER PROCEDURE dbo.ResetAccountPassword
    @user_id INT,
    @password_hash NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Users
    SET password_hash = @password_hash
    WHERE user_id = @user_id;
END;
GO

-- 4. Cấp quyền EXECUTE cho các role và user backend
IF DATABASE_PRINCIPAL_ID('petcare_booking_app') IS NOT NULL
BEGIN
    GRANT EXECUTE ON dbo.FindAccountByIdentifier TO petcare_booking_app;
    GRANT EXECUTE ON dbo.GetAccountById TO petcare_booking_app;
    GRANT EXECUTE ON dbo.ListAccounts TO petcare_booking_app;
    GRANT EXECUTE ON dbo.CreateAccount TO petcare_booking_app;
    GRANT EXECUTE ON dbo.UpdateAccount TO petcare_booking_app;
    GRANT EXECUTE ON dbo.SetAccountActive TO petcare_booking_app;
    GRANT EXECUTE ON dbo.ResetAccountPassword TO petcare_booking_app;
END;
GO

IF DATABASE_PRINCIPAL_ID('petcare_admin_app') IS NOT NULL
BEGIN
    GRANT EXECUTE ON dbo.FindAccountByIdentifier TO petcare_admin_app;
    GRANT EXECUTE ON dbo.GetAccountById TO petcare_admin_app;
    GRANT EXECUTE ON dbo.ListAccounts TO petcare_admin_app;
    GRANT EXECUTE ON dbo.CreateAccount TO petcare_admin_app;
    GRANT EXECUTE ON dbo.UpdateAccount TO petcare_admin_app;
    GRANT EXECUTE ON dbo.SetAccountActive TO petcare_admin_app;
    GRANT EXECUTE ON dbo.ResetAccountPassword TO petcare_admin_app;
END;
GO

IF DATABASE_PRINCIPAL_ID('petcare_backend') IS NOT NULL
BEGIN
    GRANT EXECUTE ON dbo.FindAccountByIdentifier TO petcare_backend;
    GRANT EXECUTE ON dbo.GetAccountById TO petcare_backend;
    GRANT EXECUTE ON dbo.ListAccounts TO petcare_backend;
    GRANT EXECUTE ON dbo.CreateAccount TO petcare_backend;
    GRANT EXECUTE ON dbo.UpdateAccount TO petcare_backend;
    GRANT EXECUTE ON dbo.SetAccountActive TO petcare_backend;
    GRANT EXECUTE ON dbo.ResetAccountPassword TO petcare_backend;
END;
GO

-- 5. Tạo sẵn tài khoản ADMIN và STAFF mẫu (mật khẩu đã mã hóa BCrypt)
--    - Admin: admin@petcare.vn / 0900000001 | Mật khẩu: Admin@123
--    - Staff: staff@petcare.vn / 0900000002 | Mật khẩu: Staff@123
IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE email = N'admin@petcare.vn')
BEGIN
    INSERT INTO dbo.Users (full_name, email, phone, password_hash, role, is_active)
    VALUES (
        N'Quản Trị Viên PetCare',
        N'admin@petcare.vn',
        N'0900000001',
        N'$2a$12$qLe67BZDZTzjw6fvEVfAcOs.05XjpDI2u1iT25JWLQQuZrBLZE2Yi',
        'ADMIN',
        1
    );
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE email = N'staff@petcare.vn')
BEGIN
    INSERT INTO dbo.Users (full_name, email, phone, password_hash, role, is_active)
    VALUES (
        N'Chuyên Viên Grooming',
        N'staff@petcare.vn',
        N'0900000002',
        N'$2a$12$Yq69sM4r.bauw25QvaPvgeonUfIe.HwSLkJdnvS7mfmgid7Y/kSzK',
        'STAFF',
        1
    );
END;
GO
