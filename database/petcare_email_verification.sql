-- =========================================================
-- PetCare - Email verification tokens (Gmail SMTP "xác thực
-- email khi đăng ký"). Incremental migration: safe to re-run
-- on the existing live PetCare database. Run with a db_owner
-- / sysadmin account, NOT petcare_backend.
-- =========================================================
USE [PetCare];
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.EmailVerificationTokens', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.EmailVerificationTokens (
        token_id    INT IDENTITY(1,1) PRIMARY KEY,
        user_id     INT NOT NULL REFERENCES dbo.Users(user_id),
        token_hash  CHAR(64) NOT NULL UNIQUE,  -- SHA-256 hex of the raw token mailed to the user
        expires_at  DATETIME2 NOT NULL,
        used_at     DATETIME2 NULL,
        created_at  DATETIME2 NOT NULL DEFAULT SYSDATETIME()
    );
    CREATE INDEX IX_EmailVerificationTokens_UserId ON dbo.EmailVerificationTokens(user_id);
END
GO

-- Invalidates any still-usable tokens for the user, then issues a fresh one.
CREATE OR ALTER PROCEDURE dbo.CreateEmailVerificationToken
    @user_id INT,
    @token_hash CHAR(64),
    @expires_at DATETIME2
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE user_id = @user_id)
            THROW 51071, 'Account does not exist.', 1;
        DELETE FROM dbo.EmailVerificationTokens WHERE user_id = @user_id AND used_at IS NULL;
        INSERT INTO dbo.EmailVerificationTokens(user_id, token_hash, expires_at)
        VALUES (@user_id, @token_hash, @expires_at);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH
END;
GO

-- Atomically validates and marks a token used; returns @user_id = NULL when
-- the token is unknown, already used, or expired so the caller can reject it.
CREATE OR ALTER PROCEDURE dbo.ConsumeEmailVerificationToken
    @token_hash CHAR(64),
    @user_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET @user_id = NULL;
    BEGIN TRY
        BEGIN TRANSACTION;
        SELECT @user_id = user_id FROM dbo.EmailVerificationTokens WITH (UPDLOCK, HOLDLOCK)
        WHERE token_hash = @token_hash AND used_at IS NULL AND expires_at > SYSDATETIME();
        IF @user_id IS NOT NULL
            UPDATE dbo.EmailVerificationTokens SET used_at = SYSDATETIME() WHERE token_hash = @token_hash;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        SET @user_id = NULL;
        THROW;
    END CATCH
END;
GO

GRANT EXECUTE ON dbo.CreateEmailVerificationToken  TO petcare_admin_app;
GRANT EXECUTE ON dbo.ConsumeEmailVerificationToken TO petcare_admin_app;
-- Login checks whether a pending token exists with a plain SELECT (no
-- procedure, so this needs a direct table grant unlike the two above).
GRANT SELECT ON dbo.EmailVerificationTokens TO petcare_admin_app;
GO
