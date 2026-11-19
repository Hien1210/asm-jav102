-- =========================================================
-- PetCare - Booking support procedures + demo seed data.
-- Incremental migration: safe to re-run on the existing live
-- PetCare database. Requires a DB-owner/sysadmin login, same
-- as database/petcare_accounts.sql.
-- =========================================================
USE [PetCare];
GO

-- Reuses the petcare_admin_app role created by petcare_accounts.sql
-- (petcare_backend is already a member of it).
CREATE OR ALTER PROCEDURE dbo.CreatePet
    @owner_id INT,
    @name NVARCHAR(100),
    @species NVARCHAR(50),
    @breed NVARCHAR(100) = NULL,
    @weight_kg DECIMAL(5,2) = NULL,
    @birth_date DATE = NULL,
    @pet_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET @pet_id = NULL;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE user_id = @owner_id AND role = 'CUSTOMER' AND is_active = 1)
            THROW 51060, 'Owner must be an active customer account.', 1;
        INSERT INTO dbo.Pets(owner_id, name, species, breed, weight_kg, birth_date)
        VALUES (@owner_id, @name, @species, @breed, @weight_kg, @birth_date);
        SET @pet_id = CONVERT(INT, SCOPE_IDENTITY());
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        SET @pet_id = NULL;
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE dbo.ListActiveStaffForService
    @service_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.user_id, u.full_name
    FROM dbo.Users u
    JOIN dbo.StaffSkills sk ON sk.staff_id = u.user_id
    WHERE sk.service_id = @service_id AND u.role = 'STAFF' AND u.is_active = 1
    ORDER BY u.full_name;
END;
GO

GRANT EXECUTE ON dbo.CreatePet                 TO petcare_admin_app;
GRANT EXECUTE ON dbo.ListActiveStaffForService TO petcare_admin_app;
GO

-- ============== Demo seed data (safe to skip if already present) ==============
-- Needed so a real booking can be tested: opening hours, a bookable service,
-- a staff member skilled in it, and shifts covering the next two weeks.
IF NOT EXISTS (SELECT 1 FROM dbo.BusinessHours)
BEGIN
    INSERT INTO dbo.BusinessHours(day_of_week, open_time, close_time, is_closed) VALUES
    (0,'08:00','20:30',0), (1,'08:00','20:30',0), (2,'08:00','20:30',0), (3,'08:00','20:30',0),
    (4,'08:00','20:30',0), (5,'08:00','20:30',0), (6,'08:00','20:30',0);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Services WHERE name = N'Grooming & Tắm sấy')
    INSERT INTO dbo.Services(name, description, category, duration_minutes, price, is_active)
    VALUES (N'Grooming & Tắm sấy', N'Làm sạch sâu với sữa tắm thảo mộc, sấy phồng và xịt dưỡng.', 'GROOMING', 45, 150000, 1);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE email = N'staff.demo@petcare.vn')
BEGIN
    DECLARE @staff_id INT, @service_id INT, @d INT = 0;
    INSERT INTO dbo.Users(full_name, email, phone, password_hash, role, is_active)
    VALUES (N'Nhân viên Grooming Demo', N'staff.demo@petcare.vn', N'0900000099',
            N'$2a$12$lc9clEQv3.3JvgzAmXRshOxSlxCnCahbl4UB60deL.PnVrPsc4RhG', 'STAFF', 1);
    SET @staff_id = CONVERT(INT, SCOPE_IDENTITY());
    SELECT @service_id = service_id FROM dbo.Services WHERE name = N'Grooming & Tắm sấy';

    INSERT INTO dbo.StaffSkills(staff_id, service_id) VALUES (@staff_id, @service_id);

    WHILE @d < 14
    BEGIN
        INSERT INTO dbo.Shifts(staff_id, work_date, start_time, end_time)
        VALUES (@staff_id, DATEADD(DAY, @d, CAST(SYSDATETIME() AS DATE)), '08:00', '20:00');
        SET @d = @d + 1;
    END;
END
GO
