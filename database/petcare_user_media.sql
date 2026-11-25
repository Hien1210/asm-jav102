-- =========================================================
-- PetCare - User Avatar & Banner Media (Cloudinary URLs)
-- Incremental migration: safe to re-run on the existing live
-- PetCare database. Keeps dbo.Users and existing account
-- stored procedures completely untouched.
-- =========================================================
USE [PetCare];
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.UserMedia', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.UserMedia (
        user_id     INT NOT NULL PRIMARY KEY REFERENCES dbo.Users(user_id) ON DELETE CASCADE,
        avatar_url  NVARCHAR(500) NULL,
        banner_url  NVARCHAR(500) NULL,
        updated_at  DATETIME2 NOT NULL DEFAULT SYSDATETIME()
    );
END
GO

CREATE OR ALTER PROCEDURE dbo.GetUserMedia
    @user_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT user_id, avatar_url, banner_url, updated_at
    FROM dbo.UserMedia
    WHERE user_id = @user_id;
END;
GO

CREATE OR ALTER PROCEDURE dbo.UpsertUserAvatar
    @user_id INT,
    @avatar_url NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE user_id = @user_id)
            THROW 51051, 'Account does not exist.', 1;

        IF EXISTS (SELECT 1 FROM dbo.UserMedia WHERE user_id = @user_id)
        BEGIN
            UPDATE dbo.UserMedia
            SET avatar_url = @avatar_url,
                updated_at = SYSDATETIME()
            WHERE user_id = @user_id;
        END
        ELSE
        BEGIN
            INSERT INTO dbo.UserMedia (user_id, avatar_url, updated_at)
            VALUES (@user_id, @avatar_url, SYSDATETIME());
        END
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE dbo.UpsertUserBanner
    @user_id INT,
    @banner_url NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE user_id = @user_id)
            THROW 51051, 'Account does not exist.', 1;

        IF EXISTS (SELECT 1 FROM dbo.UserMedia WHERE user_id = @user_id)
        BEGIN
            UPDATE dbo.UserMedia
            SET banner_url = @banner_url,
                updated_at = SYSDATETIME()
            WHERE user_id = @user_id;
        END
        ELSE
        BEGIN
            INSERT INTO dbo.UserMedia (user_id, banner_url, updated_at)
            VALUES (@user_id, @banner_url, SYSDATETIME());
        END
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH
END;
GO

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'petcare_admin_app')
BEGIN
    GRANT EXECUTE ON dbo.GetUserMedia TO petcare_admin_app;
    GRANT EXECUTE ON dbo.UpsertUserAvatar TO petcare_admin_app;
    GRANT EXECUTE ON dbo.UpsertUserBanner TO petcare_admin_app;
    GRANT SELECT ON dbo.UserMedia TO petcare_admin_app;
END
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'petcare_booking_app')
BEGIN
    GRANT EXECUTE ON dbo.GetUserMedia TO petcare_booking_app;
    GRANT EXECUTE ON dbo.UpsertUserAvatar TO petcare_booking_app;
    GRANT EXECUTE ON dbo.UpsertUserBanner TO petcare_booking_app;
    GRANT SELECT ON dbo.UserMedia TO petcare_booking_app;
END
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'petcare_backend')
BEGIN
    GRANT EXECUTE ON dbo.GetUserMedia TO petcare_backend;
    GRANT EXECUTE ON dbo.UpsertUserAvatar TO petcare_backend;
    GRANT EXECUTE ON dbo.UpsertUserBanner TO petcare_backend;
    GRANT SELECT ON dbo.UserMedia TO petcare_backend;
END
GO
