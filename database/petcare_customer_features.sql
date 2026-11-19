-- =========================================================
-- PetCare - Customer Role Stored Procedures, Grants & Seed Data
-- Incremental migration: safe to re-run on the existing live
-- PetCare database (local SQLEXPRESS or remote SQL Server).
-- Run with a db_owner / sysadmin account.
-- =========================================================
USE [PetCare];
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- ============== 1. PET CRUD STORED PROCEDURES ==============
-- Keeps @medical_notes optional (default NULL) so older 7-parameter callers remain compatible.
CREATE OR ALTER PROCEDURE dbo.CreatePet
    @owner_id INT,
    @name NVARCHAR(100),
    @species NVARCHAR(50),
    @breed NVARCHAR(100) = NULL,
    @weight_kg DECIMAL(5,2) = NULL,
    @birth_date DATE = NULL,
    @pet_id INT OUTPUT,
    @medical_notes NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET @pet_id = NULL;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE user_id = @owner_id AND role = 'CUSTOMER' AND is_active = 1)
            THROW 51060, 'Owner must be an active customer account.', 1;
        INSERT INTO dbo.Pets(owner_id, name, species, breed, weight_kg, birth_date, medical_notes)
        VALUES (@owner_id, @name, @species, NULLIF(LTRIM(RTRIM(@breed)), N''), @weight_kg, @birth_date, NULLIF(LTRIM(RTRIM(@medical_notes)), N''));
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

CREATE OR ALTER PROCEDURE dbo.UpdatePet
    @pet_id INT,
    @owner_id INT,
    @name NVARCHAR(100),
    @species NVARCHAR(50),
    @breed NVARCHAR(100) = NULL,
    @weight_kg DECIMAL(5,2) = NULL,
    @birth_date DATE = NULL,
    @medical_notes NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE user_id = @owner_id AND role = 'CUSTOMER' AND is_active = 1)
            THROW 51060, 'Owner must be an active customer account.', 1;
        IF NOT EXISTS (SELECT 1 FROM dbo.Pets WHERE pet_id = @pet_id AND owner_id = @owner_id)
            THROW 51061, 'Pet does not exist or does not belong to this customer.', 1;

        UPDATE dbo.Pets
        SET name = @name,
            species = @species,
            breed = NULLIF(LTRIM(RTRIM(@breed)), N''),
            weight_kg = @weight_kg,
            birth_date = @birth_date,
            medical_notes = NULLIF(LTRIM(RTRIM(@medical_notes)), N'')
        WHERE pet_id = @pet_id AND owner_id = @owner_id;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE dbo.DeletePet
    @pet_id INT,
    @owner_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NOT EXISTS (SELECT 1 FROM dbo.Pets WHERE pet_id = @pet_id AND owner_id = @owner_id)
            THROW 51061, 'Pet does not exist or does not belong to this customer.', 1;
        IF EXISTS (SELECT 1 FROM dbo.Appointments WHERE pet_id = @pet_id)
            THROW 51062, 'Cannot delete a pet that already has appointments.', 1;

        DELETE FROM dbo.Pets WHERE pet_id = @pet_id AND owner_id = @owner_id;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH
END;
GO

-- ============== 2. STAFF LOOKUP PROCEDURE ==============
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

-- ============== 3. NOTIFICATIONS PROCEDURES ==============
CREATE OR ALTER PROCEDURE dbo.CreateNotification
    @user_id INT,
    @appointment_id INT = NULL,
    @type VARCHAR(20),
    @channel VARCHAR(10),
    @content NVARCHAR(500),
    @status VARCHAR(10) = 'SENT',
    @notification_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET @notification_id = NULL;
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO dbo.Notifications(user_id, appointment_id, type, channel, content, status)
        VALUES (@user_id, @appointment_id, @type, @channel, @content, ISNULL(@status, 'SENT'));
        SET @notification_id = CONVERT(INT, SCOPE_IDENTITY());
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        SET @notification_id = NULL;
        THROW;
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE dbo.ListUserNotifications
    @user_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT notification_id, user_id, appointment_id, type, channel, content, status, created_at
    FROM dbo.Notifications
    WHERE user_id = @user_id
    ORDER BY created_at DESC, notification_id DESC;
END;
GO

-- ============== 4. PERMISSIONS FOR APP ROLES & BACKEND LOGIN ==============
DECLARE @principal SYSNAME;
DECLARE principal_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT name FROM (VALUES (N'petcare_booking_app'), (N'petcare_payment_app'), (N'petcare_admin_app'), (N'petcare_backend')) p(name)
    WHERE DATABASE_PRINCIPAL_ID(name) IS NOT NULL;

OPEN principal_cursor;
FETCH NEXT FROM principal_cursor INTO @principal;
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @sql NVARCHAR(MAX) =
        N'GRANT SELECT ON dbo.Users TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT SELECT ON dbo.Pets TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT SELECT ON dbo.Services TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT SELECT ON dbo.Combos TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT SELECT ON dbo.ComboServices TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT SELECT ON dbo.StaffSkills TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT SELECT ON dbo.Shifts TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT SELECT ON dbo.BusinessHours TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT SELECT ON dbo.Rooms TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT SELECT ON dbo.Appointments TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT SELECT ON dbo.AppointmentServices TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT SELECT ON dbo.BoardingDetails TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT SELECT ON dbo.Payments TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT SELECT ON dbo.Reviews TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT SELECT ON dbo.Notifications TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT EXECUTE ON dbo.CreatePet TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT EXECUTE ON dbo.UpdatePet TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT EXECUTE ON dbo.DeletePet TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT EXECUTE ON dbo.ListActiveStaffForService TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT EXECUTE ON dbo.CreateNotification TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT EXECUTE ON dbo.ListUserNotifications TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT EXECUTE ON dbo.BookServiceAppointment TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT EXECUTE ON dbo.BookBoardingAppointment TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT EXECUTE ON dbo.SetAppointmentStatus TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT EXECUTE ON dbo.SubmitReview TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT EXECUTE, REFERENCES ON TYPE::dbo.ServiceBookingItems TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT EXECUTE ON dbo.RecordPayment TO ' + QUOTENAME(@principal) + N';' +
        N'GRANT EXECUTE ON dbo.SetPaymentStatus TO ' + QUOTENAME(@principal) + N';';
    EXEC sys.sp_executesql @sql;
    FETCH NEXT FROM principal_cursor INTO @principal;
END;
CLOSE principal_cursor;
DEALLOCATE principal_cursor;
GO

-- ============== 5. IDEMPOTENT DEMO SEED DATA FOR FULL CUSTOMER FLOWS ==============
IF NOT EXISTS (SELECT 1 FROM dbo.BusinessHours)
BEGIN
    INSERT INTO dbo.BusinessHours(day_of_week, open_time, close_time, is_closed) VALUES
    (0,'08:00','20:30',0),
    (1,'08:00','20:30',0),
    (2,'08:00','20:30',0),
    (3,'08:00','20:30',0),
    (4,'08:00','20:30',0),
    (5,'08:00','20:30',0),
    (6,'08:00','20:30',0);
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Services WHERE name = N'Grooming & Tắm sấy')
    INSERT INTO dbo.Services(name, description, category, duration_minutes, price, is_active)
    VALUES (N'Grooming & Tắm sấy', N'Làm sạch sâu với sữa tắm thảo mộc hữu cơ, sấy phồng và xịt dưỡng tinh dầu.', 'GROOMING', 45, 150000, 1);

IF NOT EXISTS (SELECT 1 FROM dbo.Services WHERE name = N'Cắt tỉa tạo kiểu chuẩn Salon')
    INSERT INTO dbo.Services(name, description, category, duration_minutes, price, is_active)
    VALUES (N'Cắt tỉa tạo kiểu chuẩn Salon', N'Tạo form dáng theo yêu cầu (Teddy Bear, Bichon, Corgi...) bởi Master Groomer.', 'GROOMING', 90, 280000, 1);

IF NOT EXISTS (SELECT 1 FROM dbo.Services WHERE name = N'Spa thảo dược & Chăm sóc da')
    INSERT INTO dbo.Services(name, description, category, duration_minutes, price, is_active)
    VALUES (N'Spa thảo dược & Chăm sóc da', N'Ủ bùn khoáng và tinh chất Collagen giúp dịu da nhạy cảm, phục hồi lông mượt.', 'GROOMING', 60, 350000, 1);

IF NOT EXISTS (SELECT 1 FROM dbo.Services WHERE name = N'Vệ sinh tai & cắt mài móng')
    INSERT INTO dbo.Services(name, description, category, duration_minutes, price, is_active)
    VALUES (N'Vệ sinh tai & cắt mài móng', N'Nhổ lông tai êm ái, làm sạch ống tai thảo dược, cắt mài nhẵn móng và vệ sinh bàn chân.', 'GROOMING', 30, 120000, 1);

IF NOT EXISTS (SELECT 1 FROM dbo.Services WHERE name = N'Khám sức khỏe tổng quát')
    INSERT INTO dbo.Services(name, description, category, duration_minutes, price, is_active)
    VALUES (N'Khám sức khỏe tổng quát', N'Tầm soát da lông, tai, răng miệng, cân nặng và tư vấn chế độ dinh dưỡng cho bé.', 'MEDICAL', 30, 180000, 1);

IF NOT EXISTS (SELECT 1 FROM dbo.Services WHERE name = N'Tiêm phòng vaccine định kỳ')
    INSERT INTO dbo.Services(name, description, category, duration_minutes, price, is_active)
    VALUES (N'Tiêm phòng vaccine định kỳ', N'Tiêm vaccine phòng bệnh tiêu chuẩn theo phác đồ thú y và theo dõi sau tiêm.', 'VACCINATION', 30, 250000, 1);
GO

-- Seed Combos + ComboServices
DECLARE @svcBath INT = (SELECT TOP 1 service_id FROM dbo.Services WHERE name = N'Grooming & Tắm sấy');
DECLARE @svcCut INT = (SELECT TOP 1 service_id FROM dbo.Services WHERE name = N'Cắt tỉa tạo kiểu chuẩn Salon');
DECLARE @svcHygiene INT = (SELECT TOP 1 service_id FROM dbo.Services WHERE name = N'Vệ sinh tai & cắt mài móng');
DECLARE @svcExam INT = (SELECT TOP 1 service_id FROM dbo.Services WHERE name = N'Khám sức khỏe tổng quát');
DECLARE @svcVac INT = (SELECT TOP 1 service_id FROM dbo.Services WHERE name = N'Tiêm phòng vaccine định kỳ');

IF @svcBath IS NOT NULL AND @svcHygiene IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM dbo.Combos WHERE name = N'Combo Tắm Sấy & Vệ Sinh Toàn Diện')
BEGIN
    INSERT INTO dbo.Combos(name, description, price, is_active)
    VALUES (N'Combo Tắm Sấy & Vệ Sinh Toàn Diện', N'Gồm Grooming & Tắm sấy thảo mộc kết hợp Vệ sinh tai & cắt mài móng tiết kiệm 50.000đ.', 220000, 1);
    DECLARE @c1 INT = CONVERT(INT, SCOPE_IDENTITY());
    INSERT INTO dbo.ComboServices(combo_id, service_id) VALUES (@c1, @svcBath), (@c1, @svcHygiene);
END;

IF @svcBath IS NOT NULL AND @svcCut IS NOT NULL AND @svcHygiene IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM dbo.Combos WHERE name = N'Combo Spa & Cắt Tỉa Chuẩn Salon')
BEGIN
    INSERT INTO dbo.Combos(name, description, price, is_active)
    VALUES (N'Combo Spa & Cắt Tỉa Chuẩn Salon', N'Trọn gói Tắm sấy thảo mộc, Cắt tỉa tạo kiểu và Vệ sinh tai móng ưu đãi.', 490000, 1);
    DECLARE @c2 INT = CONVERT(INT, SCOPE_IDENTITY());
    INSERT INTO dbo.ComboServices(combo_id, service_id) VALUES (@c2, @svcBath), (@c2, @svcCut), (@c2, @svcHygiene);
END;

IF @svcExam IS NOT NULL AND @svcVac IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM dbo.Combos WHERE name = N'Combo Khám & Tiêm Phòng Định Kỳ')
BEGIN
    INSERT INTO dbo.Combos(name, description, price, is_active)
    VALUES (N'Combo Khám & Tiêm Phòng Định Kỳ', N'Kiểm tra sức khỏe tổng quát kết hợp tiêm phòng vaccine định kỳ an toàn.', 380000, 1);
    DECLARE @c3 INT = CONVERT(INT, SCOPE_IDENTITY());
    INSERT INTO dbo.ComboServices(combo_id, service_id) VALUES (@c3, @svcExam), (@c3, @svcVac);
END;
GO

-- Seed Boarding Rooms
IF NOT EXISTS (SELECT 1 FROM dbo.Rooms WHERE room_code = N'STD-01')
    INSERT INTO dbo.Rooms(room_code, room_type, daily_rate, status) VALUES (N'STD-01', N'Phòng Tiêu chuẩn (Chó/Mèo < 8kg)', 200000, 'AVAILABLE');
IF NOT EXISTS (SELECT 1 FROM dbo.Rooms WHERE room_code = N'STD-02')
    INSERT INTO dbo.Rooms(room_code, room_type, daily_rate, status) VALUES (N'STD-02', N'Phòng Tiêu chuẩn (Chó/Mèo < 8kg)', 200000, 'AVAILABLE');
IF NOT EXISTS (SELECT 1 FROM dbo.Rooms WHERE room_code = N'DLX-01')
    INSERT INTO dbo.Rooms(room_code, room_type, daily_rate, status) VALUES (N'DLX-01', N'Phòng Deluxe (Chó cỡ trung 8-20kg)', 320000, 'AVAILABLE');
IF NOT EXISTS (SELECT 1 FROM dbo.Rooms WHERE room_code = N'VIP-01')
    INSERT INTO dbo.Rooms(room_code, room_type, daily_rate, status) VALUES (N'VIP-01', N'Phòng VIP Camera 24/7 (Mọi kích cỡ)', 480000, 'AVAILABLE');
GO

-- Ensure active STAFF members have skills for all active non-boarding services and shifts for the next 14 days
DECLARE @staffId INT;
DECLARE staff_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT user_id FROM dbo.Users WHERE role = 'STAFF' AND is_active = 1;

OPEN staff_cursor;
FETCH NEXT FROM staff_cursor INTO @staffId;
WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO dbo.StaffSkills(staff_id, service_id)
    SELECT @staffId, s.service_id
    FROM dbo.Services s
    WHERE s.is_active = 1 AND s.category <> 'BOARDING'
      AND NOT EXISTS (SELECT 1 FROM dbo.StaffSkills sk WHERE sk.staff_id = @staffId AND sk.service_id = s.service_id);

    DECLARE @d INT = 0;
    WHILE @d < 14
    BEGIN
        DECLARE @workDate DATE = DATEADD(DAY, @d, CAST(SYSDATETIME() AS DATE));
        IF NOT EXISTS (SELECT 1 FROM dbo.Shifts WHERE staff_id = @staffId AND work_date = @workDate)
        BEGIN
            INSERT INTO dbo.Shifts(staff_id, work_date, start_time, end_time)
            VALUES (@staffId, @workDate, '08:00', '20:00');
        END;
        SET @d = @d + 1;
    END;

    FETCH NEXT FROM staff_cursor INTO @staffId;
END;
CLOSE staff_cursor;
DEALLOCATE staff_cursor;
GO
