-- =========================================================
-- PetCare - Account management procedures (admin backend).
-- Incremental migration: safe to re-run on the existing live
-- PetCare database (unlike petcare.sql, which only installs
-- into an empty database).
-- =========================================================
USE [PetCare];
GO

-- Dedicated role for the account-management (admin) backend connection.
-- Mutations go through procedures only, matching the existing
-- petcare_booking_app / petcare_payment_app pattern.
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'petcare_admin_app' AND type = 'R')
    EXEC(N'CREATE ROLE petcare_admin_app AUTHORIZATION dbo;');
GO
DENY INSERT, UPDATE, DELETE ON SCHEMA::dbo TO petcare_admin_app;
GO

CREATE OR ALTER PROCEDURE dbo.FindAccountByIdentifier
    @identifier NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT user_id, full_name, email, phone, password_hash, role, is_active, created_at
    FROM dbo.Users
    WHERE email = @identifier OR phone = @identifier;
END;
GO

CREATE OR ALTER PROCEDURE dbo.ListAccounts
AS
BEGIN
    SET NOCOUNT ON;
    SELECT user_id, full_name, email, phone, role, is_active, created_at
    FROM dbo.Users
    ORDER BY user_id;
END;
GO

CREATE OR ALTER PROCEDURE dbo.GetAccountById
    @user_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT user_id, full_name, email, phone, role, is_active, created_at
    FROM dbo.Users
    WHERE user_id = @user_id;
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
    SET XACT_ABORT ON;
    SET @user_id = NULL;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF EXISTS (SELECT 1 FROM dbo.Users WHERE email = @email)
            THROW 51050, 'Email already registered.', 1;
        INSERT INTO dbo.Users(full_name, email, phone, password_hash, role, is_active)
        VALUES (@full_name, @email, @phone, @password_hash, @role, 1);
        SET @user_id = CONVERT(INT, SCOPE_IDENTITY());
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        SET @user_id = NULL;
        THROW;
    END CATCH
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
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE user_id = @user_id)
            THROW 51051, 'Account does not exist.', 1;
        IF EXISTS (SELECT 1 FROM dbo.Users WHERE email = @email AND user_id <> @user_id)
            THROW 51050, 'Email already registered.', 1;
        UPDATE dbo.Users
        SET full_name = @full_name, email = @email, phone = @phone, role = @role
        WHERE user_id = @user_id;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE dbo.SetAccountActive
    @user_id INT,
    @is_active BIT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE user_id = @user_id)
            THROW 51051, 'Account does not exist.', 1;
        UPDATE dbo.Users SET is_active = @is_active WHERE user_id = @user_id;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE dbo.ResetAccountPassword
    @user_id INT,
    @password_hash NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE user_id = @user_id)
            THROW 51051, 'Account does not exist.', 1;
        UPDATE dbo.Users SET password_hash = @password_hash WHERE user_id = @user_id;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH
END;
GO

GRANT EXECUTE ON dbo.FindAccountByIdentifier TO petcare_admin_app;
GRANT EXECUTE ON dbo.ListAccounts         TO petcare_admin_app;
GRANT EXECUTE ON dbo.GetAccountById       TO petcare_admin_app;
GRANT EXECUTE ON dbo.CreateAccount        TO petcare_admin_app;
GRANT EXECUTE ON dbo.UpdateAccount        TO petcare_admin_app;
GRANT EXECUTE ON dbo.SetAccountActive     TO petcare_admin_app;
GRANT EXECUTE ON dbo.ResetAccountPassword TO petcare_admin_app;
GO

-- The app currently connects as a single login (petcare_backend) for every
-- feature, so it also needs this role to run account management and login.
IF NOT EXISTS (
    SELECT 1 FROM sys.database_role_members rm
    JOIN sys.database_principals r ON r.principal_id = rm.role_principal_id
    JOIN sys.database_principals m ON m.principal_id = rm.member_principal_id
    WHERE r.name = N'petcare_admin_app' AND m.name = N'petcare_backend')
    ALTER ROLE petcare_admin_app ADD MEMBER petcare_backend;
GO
