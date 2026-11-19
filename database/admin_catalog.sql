-- Administration catalog migration. No data reset, trigger disabling, or direct write grants.
USE PetCare;
GO
IF DATABASE_PRINCIPAL_ID(N'petcare_admin_app') IS NULL CREATE ROLE petcare_admin_app;
GO
CREATE OR ALTER PROCEDURE dbo.AdminSaveServices
    @id INT,
    @name NVARCHAR(100),
    @description NVARCHAR(500),
    @category VARCHAR(20),
    @duration_minutes INT,
    @price DECIMAL(10,2),
    @is_active BIT,
    @saved_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_PADDING ON;
    SET ANSI_WARNINGS ON;
    SET ARITHABORT ON;
    SET CONCAT_NULL_YIELDS_NULL ON;
    SET NUMERIC_ROUNDABORT OFF;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.AcquirePetCareLock;
        IF @id IS NULL
        BEGIN
            INSERT dbo.Services (name,description,category,duration_minutes,price,is_active) VALUES (@name,@description,@category,@duration_minutes,@price,@is_active);
            SET @saved_id=CONVERT(INT,SCOPE_IDENTITY());
        END
        ELSE
        BEGIN
            UPDATE dbo.Services SET name=@name,description=@description,category=@category,duration_minutes=@duration_minutes,price=@price,is_active=@is_active WHERE service_id=@id;
            IF @@ROWCOUNT=0 THROW 51101, 'Admin record does not exist.', 1;
            SET @saved_id=@id;
        END;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE()<>0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO
GRANT EXECUTE ON dbo.AdminSaveServices TO petcare_admin_app;
GO
CREATE OR ALTER PROCEDURE dbo.AdminDeleteServices @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.AcquirePetCareLock;
        DELETE dbo.Services WHERE service_id=@id;
        IF @@ROWCOUNT=0 THROW 51101, 'Admin record does not exist.', 1;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE()<>0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO
GRANT EXECUTE ON dbo.AdminDeleteServices TO petcare_admin_app;
GRANT SELECT ON dbo.Services TO petcare_admin_app;
GO
CREATE OR ALTER PROCEDURE dbo.AdminSaveCombos
    @id INT,
    @name NVARCHAR(100),
    @description NVARCHAR(500),
    @price DECIMAL(10,2),
    @is_active BIT,
    @saved_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_PADDING ON;
    SET ANSI_WARNINGS ON;
    SET ARITHABORT ON;
    SET CONCAT_NULL_YIELDS_NULL ON;
    SET NUMERIC_ROUNDABORT OFF;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.AcquirePetCareLock;
        IF @id IS NULL
        BEGIN
            INSERT dbo.Combos (name,description,price,is_active) VALUES (@name,@description,@price,@is_active);
            SET @saved_id=CONVERT(INT,SCOPE_IDENTITY());
        END
        ELSE
        BEGIN
            UPDATE dbo.Combos SET name=@name,description=@description,price=@price,is_active=@is_active WHERE combo_id=@id;
            IF @@ROWCOUNT=0 THROW 51101, 'Admin record does not exist.', 1;
            SET @saved_id=@id;
        END;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE()<>0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO
GRANT EXECUTE ON dbo.AdminSaveCombos TO petcare_admin_app;
GO
CREATE OR ALTER PROCEDURE dbo.AdminDeleteCombos @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.AcquirePetCareLock;
        DELETE dbo.ComboServices WHERE combo_id=@id;
        DELETE dbo.Combos WHERE combo_id=@id;
        IF @@ROWCOUNT=0 THROW 51101, 'Admin record does not exist.', 1;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE()<>0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO
GRANT EXECUTE ON dbo.AdminDeleteCombos TO petcare_admin_app;
GRANT SELECT ON dbo.Combos TO petcare_admin_app;
GO
CREATE OR ALTER PROCEDURE dbo.AdminSaveRooms
    @id INT,
    @room_code NVARCHAR(20),
    @room_type NVARCHAR(50),
    @daily_rate DECIMAL(10,2),
    @status VARCHAR(20),
    @saved_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_PADDING ON;
    SET ANSI_WARNINGS ON;
    SET ARITHABORT ON;
    SET CONCAT_NULL_YIELDS_NULL ON;
    SET NUMERIC_ROUNDABORT OFF;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.AcquirePetCareLock;
        IF @id IS NULL
        BEGIN
            INSERT dbo.Rooms (room_code,room_type,daily_rate,status) VALUES (@room_code,@room_type,@daily_rate,@status);
            SET @saved_id=CONVERT(INT,SCOPE_IDENTITY());
        END
        ELSE
        BEGIN
            UPDATE dbo.Rooms SET room_code=@room_code,room_type=@room_type,daily_rate=@daily_rate,status=@status WHERE room_id=@id;
            IF @@ROWCOUNT=0 THROW 51101, 'Admin record does not exist.', 1;
            SET @saved_id=@id;
        END;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE()<>0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO
GRANT EXECUTE ON dbo.AdminSaveRooms TO petcare_admin_app;
GO
CREATE OR ALTER PROCEDURE dbo.AdminDeleteRooms @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.AcquirePetCareLock;
        DELETE dbo.Rooms WHERE room_id=@id;
        IF @@ROWCOUNT=0 THROW 51101, 'Admin record does not exist.', 1;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE()<>0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO
GRANT EXECUTE ON dbo.AdminDeleteRooms TO petcare_admin_app;
GRANT SELECT ON dbo.Rooms TO petcare_admin_app;
GO
CREATE OR ALTER PROCEDURE dbo.AdminSaveShifts
    @id INT,
    @staff_id INT,
    @work_date DATE,
    @start_time TIME,
    @end_time TIME,
    @saved_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_PADDING ON;
    SET ANSI_WARNINGS ON;
    SET ARITHABORT ON;
    SET CONCAT_NULL_YIELDS_NULL ON;
    SET NUMERIC_ROUNDABORT OFF;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.AcquirePetCareLock;
        IF @id IS NULL
        BEGIN
            INSERT dbo.Shifts (staff_id,work_date,start_time,end_time) VALUES (@staff_id,@work_date,@start_time,@end_time);
            SET @saved_id=CONVERT(INT,SCOPE_IDENTITY());
        END
        ELSE
        BEGIN
            UPDATE dbo.Shifts SET staff_id=@staff_id,work_date=@work_date,start_time=@start_time,end_time=@end_time WHERE shift_id=@id;
            IF @@ROWCOUNT=0 THROW 51101, 'Admin record does not exist.', 1;
            SET @saved_id=@id;
        END;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE()<>0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO
GRANT EXECUTE ON dbo.AdminSaveShifts TO petcare_admin_app;
GO
CREATE OR ALTER PROCEDURE dbo.AdminDeleteShifts @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.AcquirePetCareLock;
        DELETE dbo.Shifts WHERE shift_id=@id;
        IF @@ROWCOUNT=0 THROW 51101, 'Admin record does not exist.', 1;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE()<>0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO
GRANT EXECUTE ON dbo.AdminDeleteShifts TO petcare_admin_app;
GRANT SELECT ON dbo.Shifts TO petcare_admin_app;
GO
CREATE OR ALTER PROCEDURE dbo.AdminSavePets
    @id INT,
    @owner_id INT,
    @name NVARCHAR(100),
    @species NVARCHAR(50),
    @breed NVARCHAR(100),
    @weight_kg DECIMAL(5,2),
    @birth_date DATE,
    @medical_notes NVARCHAR(MAX),
    @saved_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_PADDING ON;
    SET ANSI_WARNINGS ON;
    SET ARITHABORT ON;
    SET CONCAT_NULL_YIELDS_NULL ON;
    SET NUMERIC_ROUNDABORT OFF;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.AcquirePetCareLock;
        IF @id IS NULL
        BEGIN
            INSERT dbo.Pets (owner_id,name,species,breed,weight_kg,birth_date,medical_notes) VALUES (@owner_id,@name,@species,@breed,@weight_kg,@birth_date,@medical_notes);
            SET @saved_id=CONVERT(INT,SCOPE_IDENTITY());
        END
        ELSE
        BEGIN
            UPDATE dbo.Pets SET owner_id=@owner_id,name=@name,species=@species,breed=@breed,weight_kg=@weight_kg,birth_date=@birth_date,medical_notes=@medical_notes WHERE pet_id=@id;
            IF @@ROWCOUNT=0 THROW 51101, 'Admin record does not exist.', 1;
            SET @saved_id=@id;
        END;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE()<>0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO
GRANT EXECUTE ON dbo.AdminSavePets TO petcare_admin_app;
GO
CREATE OR ALTER PROCEDURE dbo.AdminDeletePets @id INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.AcquirePetCareLock;
        DELETE dbo.Pets WHERE pet_id=@id;
        IF @@ROWCOUNT=0 THROW 51101, 'Admin record does not exist.', 1;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE()<>0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO
GRANT EXECUTE ON dbo.AdminDeletePets TO petcare_admin_app;
GRANT SELECT ON dbo.Pets TO petcare_admin_app;
GO
CREATE OR ALTER PROCEDURE dbo.AdminSetComboServices @combo_id INT, @service_ids NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.AcquirePetCareLock;
        IF ISJSON(@service_ids)<>1 THROW 51102, 'Invalid service list.', 1;
        IF NOT EXISTS(SELECT 1 FROM OPENJSON(@service_ids)) THROW 51102, 'Combo requires services.', 1;
        IF EXISTS(SELECT 1 FROM OPENJSON(@service_ids) j LEFT JOIN dbo.Services s ON s.service_id=TRY_CONVERT(INT,j.value)
                  WHERE s.service_id IS NULL OR s.category='BOARDING' OR s.is_active=0)
            THROW 51102, 'Combo requires active non-boarding services.', 1;
        DELETE dbo.ComboServices WHERE combo_id=@combo_id;
        INSERT dbo.ComboServices(combo_id,service_id)
            SELECT @combo_id,CONVERT(INT,value) FROM OPENJSON(@service_ids);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE()<>0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO
GRANT EXECUTE ON dbo.AdminSetComboServices TO petcare_admin_app;
GRANT SELECT ON dbo.ComboServices TO petcare_admin_app;
GRANT SELECT ON dbo.Users TO petcare_admin_app;
GO
