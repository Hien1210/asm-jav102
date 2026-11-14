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

-- 3. Tạo sẵn tài khoản ADMIN và STAFF mẫu (mật khẩu đã mã hóa BCrypt)
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
