-- :ON ERROR EXIT

USE master;
GO
IF DB_ID(N'PetCare') IS NULL
    EXEC(N'CREATE DATABASE [PetCare]');
GO
USE [PetCare];
GO

-- PetCare corrected schema v2 (SQL Server 2016 SP1+).
-- FRESH EMPTY DATABASE ONLY. Not an ALTER/migration script; never drops data.
-- Run with sqlcmd -b (stop on error), or a runner that stops/rolls back on any batch error.
-- Dates/times are local business time consistently. No overnight service/shift.
SET NOCOUNT ON;
SET XACT_ABORT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
IF EXISTS (SELECT 1 FROM sys.tables WHERE is_ms_shipped = 0)
    THROW 51000, 'Install only into an empty database.', 1;
BEGIN TRANSACTION;
GO
-- =========================================================
-- PetCare Smart Appointment - Database Schema
-- DBMS: SQL Server (T-SQL)
-- =========================================================

-- ============== 1. USERS & ROLES ==============
CREATE TABLE dbo.Users (
    user_id         INT IDENTITY(1,1) PRIMARY KEY,
    full_name       NVARCHAR(100)   NOT NULL,
    email           NVARCHAR(100)   NOT NULL UNIQUE,
    phone           NVARCHAR(20),
    password_hash   NVARCHAR(255)   NOT NULL,
    role            VARCHAR(20)     NOT NULL
                    CHECK (role IN ('CUSTOMER','STAFF','ADMIN')),
    is_active       BIT             NOT NULL DEFAULT 1,
    created_at      DATETIME2       NOT NULL DEFAULT SYSDATETIME()
);

-- ============== 2. PETS ==============
CREATE TABLE dbo.Pets (
    pet_id          INT IDENTITY(1,1) PRIMARY KEY,
    owner_id        INT             NOT NULL REFERENCES dbo.Users(user_id),
    name            NVARCHAR(100)   NOT NULL,
    species         NVARCHAR(50)    NOT NULL,   -- chó, mèo, ...
    breed           NVARCHAR(100),
    weight_kg       DECIMAL(5,2) CHECK (weight_kg > 0),
    birth_date      DATE,
    medical_notes   NVARCHAR(MAX),              -- lịch sử khám tóm tắt
    created_at      DATETIME2       NOT NULL DEFAULT SYSDATETIME()
);

-- ============== 3. SERVICES ==============
CREATE TABLE dbo.Services (
    service_id      INT IDENTITY(1,1) PRIMARY KEY,
    name            NVARCHAR(100)   NOT NULL,
    description     NVARCHAR(500),
    category        VARCHAR(20)     NOT NULL
                    CHECK (category IN ('GROOMING','MEDICAL','VACCINATION','BOARDING','OTHER')),
    duration_minutes INT            NOT NULL DEFAULT 30 CHECK (duration_minutes > 0),  -- không dùng cho BOARDING
    price           DECIMAL(10,2)   NOT NULL CHECK (price >= 0),
    is_active       BIT             NOT NULL DEFAULT 1
);

-- ============== 4. COMBOS (gói nhiều dịch vụ) ==============
CREATE TABLE dbo.Combos (
    combo_id        INT IDENTITY(1,1) PRIMARY KEY,
    name            NVARCHAR(100)   NOT NULL,
    description     NVARCHAR(500),
    price           DECIMAL(10,2)   NOT NULL CHECK (price >= 0),   -- giá gói (thường rẻ hơn tổng lẻ)
    is_active       BIT             NOT NULL DEFAULT 1
);

CREATE TABLE dbo.ComboServices (
    combo_id        INT             NOT NULL REFERENCES dbo.Combos(combo_id),
    service_id      INT             NOT NULL REFERENCES dbo.Services(service_id),
    PRIMARY KEY (combo_id, service_id)
);

-- ============== 5. STAFF SKILLS (many-to-many) ==============
CREATE TABLE dbo.StaffSkills (
    staff_id        INT             NOT NULL REFERENCES dbo.Users(user_id),
    service_id      INT             NOT NULL REFERENCES dbo.Services(service_id),
    PRIMARY KEY (staff_id, service_id)
);

-- ============== 6. SHIFTS (ca làm việc) ==============
CREATE TABLE dbo.Shifts (
    shift_id        INT IDENTITY(1,1) PRIMARY KEY,
    staff_id        INT             NOT NULL REFERENCES dbo.Users(user_id),
    work_date       DATE            NOT NULL,
    start_time      TIME            NOT NULL,
    end_time        TIME            NOT NULL,
    CONSTRAINT CK_Shift_Time CHECK (start_time < end_time)
);

-- ============== 7. BUSINESS HOURS ==============
CREATE TABLE dbo.BusinessHours (
    day_of_week     TINYINT         PRIMARY KEY CHECK (day_of_week BETWEEN 0 AND 6),  -- 0=CN ... 6=Thứ 7
    open_time       TIME,
    close_time      TIME,
    is_closed       BIT             NOT NULL DEFAULT 0,
    CONSTRAINT CK_BusinessHours_Time CHECK (
        (is_closed = 1 AND open_time IS NULL AND close_time IS NULL) OR
        (is_closed = 0 AND open_time IS NOT NULL AND close_time IS NOT NULL AND open_time < close_time))
);

-- ============== 8. ROOMS (cho boarding) ==============
CREATE TABLE dbo.Rooms (
    room_id         INT IDENTITY(1,1) PRIMARY KEY,
    room_code       NVARCHAR(20)    NOT NULL UNIQUE,
    room_type       NVARCHAR(50),               -- size/loài phù hợp
    daily_rate      DECIMAL(10,2)   NOT NULL CHECK (daily_rate >= 0),
    status          VARCHAR(20)     NOT NULL DEFAULT 'AVAILABLE'
                    CHECK (status IN ('AVAILABLE','OCCUPIED','MAINTENANCE'))
);

-- ============== 9. APPOINTMENTS (bảng gốc) ==============
CREATE TABLE dbo.Appointments (
    appointment_id  INT IDENTITY(1,1) PRIMARY KEY,
    customer_id     INT             NOT NULL REFERENCES dbo.Users(user_id),
    pet_id          INT             NOT NULL REFERENCES dbo.Pets(pet_id),
    appointment_type VARCHAR(10)    NOT NULL
                    CHECK (appointment_type IN ('SERVICE','BOARDING')),
    combo_id        INT             NULL REFERENCES dbo.Combos(combo_id),  -- NULL nếu đặt lẻ, không qua combo
    status          VARCHAR(20)     NOT NULL DEFAULT 'DRAFT'
                    CHECK (status IN ('DRAFT','PENDING','CONFIRMED','CHECKED_IN',
                                       'IN_PROGRESS','COMPLETED','CANCELLED','NO_SHOW')),
    cancel_reason   NVARCHAR(255),
    created_at      DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
    updated_at      DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
    subtotal_amount DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (subtotal_amount >= 0),
    combo_price_at_booking DECIMAL(10,2) NULL CHECK (combo_price_at_booking >= 0),
    adjustment_amount DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (adjustment_amount >= 0),
    total_amount AS CONVERT(DECIMAL(12,2), subtotal_amount + adjustment_amount) PERSISTED,
    CONSTRAINT CK_Appointments_Combo CHECK (
       (combo_id IS NULL AND combo_price_at_booking IS NULL) OR
       (combo_id IS NOT NULL AND combo_price_at_booking IS NOT NULL AND appointment_type = 'SERVICE')),
    CONSTRAINT CK_Appointments_CancelReason CHECK (
       status <> 'CANCELLED' OR (cancel_reason IS NOT NULL AND LEN(LTRIM(RTRIM(cancel_reason))) > 0)),
    CONSTRAINT UQ_Appointments_Customer UNIQUE (appointment_id, customer_id)
);

-- ============== 10. APPOINTMENT SERVICES (1 lịch hẹn - nhiều dịch vụ) ==============
-- Mỗi dòng = 1 dịch vụ trong lịch hẹn, có thể khác nhân viên/khung giờ nhau.
CREATE TABLE dbo.AppointmentServices (
    appointment_id  INT             NOT NULL REFERENCES dbo.Appointments(appointment_id),
    service_id      INT             NOT NULL REFERENCES dbo.Services(service_id),
    staff_id        INT             NOT NULL REFERENCES dbo.Users(user_id),
    scheduled_start DATETIME2       NOT NULL,
    scheduled_end   DATETIME2       NOT NULL,
    price_at_booking DECIMAL(10,2)  NOT NULL CHECK (price_at_booking >= 0),   -- giá tại thời điểm đặt (phòng khi giá dịch vụ đổi sau này)
    line_status     VARCHAR(20)     NOT NULL DEFAULT 'PENDING'
                    CHECK (line_status IN ('PENDING','IN_PROGRESS','COMPLETED','CANCELLED')),
    PRIMARY KEY (appointment_id, service_id),
    CONSTRAINT CK_AppointmentServices_Time CHECK (scheduled_start < scheduled_end),
    CONSTRAINT FK_AppointmentServices_Skill FOREIGN KEY (staff_id, service_id)
        REFERENCES dbo.StaffSkills(staff_id, service_id)
);

-- ============== 11. BOARDING DETAILS (1-1, khi type=BOARDING) ==============
CREATE TABLE dbo.BoardingDetails (
    appointment_id  INT             PRIMARY KEY REFERENCES dbo.Appointments(appointment_id),
    room_id         INT             NOT NULL REFERENCES dbo.Rooms(room_id),
    check_in_date   DATE            NOT NULL,
    check_out_date  DATE            NOT NULL,
    daily_rate_at_booking DECIMAL(10,2) NOT NULL CHECK (daily_rate_at_booking >= 0),
    actual_check_in DATETIME2,
    actual_check_out DATETIME2,
    CONSTRAINT CK_Boarding_Actual CHECK (actual_check_out IS NULL OR
        (actual_check_in IS NOT NULL AND actual_check_in < actual_check_out)),
    CONSTRAINT CK_Boarding_Date CHECK (check_in_date < check_out_date)
);

-- ============== 12. PAYMENTS ==============
-- Multiple immutable charge/refund attempts per appointment; settlement limits enforced below.
CREATE TABLE dbo.Payments (
    payment_id      INT IDENTITY(1,1) PRIMARY KEY,
    appointment_id  INT             NOT NULL REFERENCES dbo.Appointments(appointment_id),
    amount          DECIMAL(12,2)   NOT NULL CHECK (amount > 0),
    method          VARCHAR(10)     NOT NULL CHECK (method IN ('CASH','ONLINE')),
    status          VARCHAR(10)     NOT NULL DEFAULT 'PENDING'
                    CHECK (status IN ('PENDING','PAID','FAILED')),
    transaction_ref NVARCHAR(100),              -- mã giao dịch cổng thanh toán
    paid_at         DATETIME2,
    payment_key UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID() UNIQUE,
    payment_type VARCHAR(6) NOT NULL DEFAULT 'CHARGE' CHECK (payment_type IN ('CHARGE','REFUND')),
    original_payment_id INT NULL REFERENCES dbo.Payments(payment_id),
    CONSTRAINT CK_Payments_Refund CHECK (
        (payment_type = 'CHARGE' AND original_payment_id IS NULL) OR
        (payment_type = 'REFUND' AND original_payment_id IS NOT NULL)),
    CONSTRAINT CK_Payments_PaidAt CHECK (
        (status = 'PAID' AND paid_at IS NOT NULL) OR (status <> 'PAID' AND paid_at IS NULL)),
    CONSTRAINT CK_Payments_OnlineRef CHECK (
        method <> 'ONLINE' OR (transaction_ref IS NOT NULL AND LEN(LTRIM(RTRIM(transaction_ref))) > 0))
);

-- ============== 13. REVIEWS ==============
CREATE TABLE dbo.Reviews (
    review_id       INT IDENTITY(1,1) PRIMARY KEY,
    appointment_id  INT             NOT NULL REFERENCES dbo.Appointments(appointment_id) UNIQUE,
    customer_id     INT             NOT NULL REFERENCES dbo.Users(user_id),
    CONSTRAINT FK_Reviews_AppointmentCustomer FOREIGN KEY (appointment_id, customer_id)
        REFERENCES dbo.Appointments(appointment_id, customer_id),
    rating          TINYINT         NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment         NVARCHAR(1000),
    created_at      DATETIME2       NOT NULL DEFAULT SYSDATETIME()
);

-- ============== 14. NOTIFICATIONS ==============
CREATE TABLE dbo.Notifications (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id         INT             NOT NULL REFERENCES dbo.Users(user_id),
    appointment_id  INT             NULL REFERENCES dbo.Appointments(appointment_id),
    type            VARCHAR(20)     NOT NULL
                    CHECK (type IN ('REMINDER','CONFIRMATION','CANCELLATION','OTHER')),
    channel         VARCHAR(10)     NOT NULL CHECK (channel IN ('EMAIL','SMS','PUSH')),
    content         NVARCHAR(500),
    status          VARCHAR(10)     NOT NULL DEFAULT 'PENDING'
                    CHECK (status IN ('PENDING','SENT','FAILED')),
    created_at      DATETIME2       NOT NULL DEFAULT SYSDATETIME()
);

-- ============== INDEXES GỢI Ý ==============
CREATE INDEX IX_Pets_Owner ON dbo.Pets(owner_id);
CREATE INDEX IX_Appointments_Customer ON dbo.Appointments(customer_id);
CREATE INDEX IX_Appointments_Status ON dbo.Appointments(status);
CREATE INDEX IX_ApptServices_Staff_Time ON dbo.AppointmentServices(staff_id, scheduled_start);
CREATE INDEX IX_ApptServices_Appointment ON dbo.AppointmentServices(appointment_id);
CREATE INDEX IX_Shifts_Staff_Date ON dbo.Shifts(staff_id, work_date);
CREATE INDEX IX_Boarding_Room_Date ON dbo.BoardingDetails(room_id, check_in_date, check_out_date);

ALTER TABLE dbo.Pets ADD CONSTRAINT UQ_Pets_Owner UNIQUE(pet_id, owner_id);
ALTER TABLE dbo.Appointments ADD CONSTRAINT FK_Appointments_PetOwner
    FOREIGN KEY(pet_id, customer_id) REFERENCES dbo.Pets(pet_id, owner_id);
CREATE UNIQUE INDEX UX_Payments_TransactionRef ON dbo.Payments(transaction_ref) WHERE transaction_ref IS NOT NULL;
CREATE INDEX IX_Payments_Appointment ON dbo.Payments(appointment_id, payment_type, status);
CREATE INDEX IX_Appointments_Pet ON dbo.Appointments(pet_id, status);
GO
CREATE TYPE dbo.ServiceBookingItems AS TABLE (
    service_id INT NOT NULL PRIMARY KEY,
    staff_id INT NOT NULL,
    scheduled_start DATETIME2 NOT NULL,
    scheduled_end DATETIME2 NOT NULL,
    CHECK (scheduled_start < scheduled_end)
);
GO
CREATE PROCEDURE dbo.AcquirePetCareLock
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @result INT;
    EXEC @result = sys.sp_getapplock @Resource = N'PetCare:integrity:v2',
        @LockMode = 'Exclusive', @LockOwner = 'Transaction', @LockTimeout = 10000;
    IF @result < 0 THROW 51001, 'Booking is busy. Retry the entire transaction.', 1;
END;
GO
-- One shared validator also runs after master-data edits, not only child inserts.
-- Coarse locking is intentional for a small deployment; no external calls in these transactions.
CREATE PROCEDURE dbo.AssertPetCareIntegrity
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    EXEC dbo.AcquirePetCareLock;

    IF EXISTS (SELECT 1 FROM dbo.Pets p JOIN dbo.Users u ON u.user_id=p.owner_id WHERE u.role <> 'CUSTOMER')
        THROW 51002, 'Pet owner must have CUSTOMER role.', 1;
    IF EXISTS (SELECT 1 FROM dbo.StaffSkills s JOIN dbo.Users u ON u.user_id=s.staff_id WHERE u.role <> 'STAFF')
       OR EXISTS (SELECT 1 FROM dbo.Shifts s JOIN dbo.Users u ON u.user_id=s.staff_id WHERE u.role <> 'STAFF')
        THROW 51003, 'Skills and shifts require STAFF role.', 1;
    IF EXISTS (SELECT 1 FROM dbo.Shifts a JOIN dbo.Shifts b ON a.staff_id=b.staff_id
        AND a.work_date=b.work_date AND a.shift_id<b.shift_id
        AND a.start_time<b.end_time AND b.start_time<a.end_time)
        THROW 51004, 'Staff shifts overlap.', 1;

    IF EXISTS (SELECT 1 FROM dbo.AppointmentServices s JOIN dbo.Appointments a ON a.appointment_id=s.appointment_id
        WHERE a.appointment_type <> 'SERVICE')
       OR EXISTS (SELECT 1 FROM dbo.BoardingDetails b JOIN dbo.Appointments a ON a.appointment_id=b.appointment_id
        WHERE a.appointment_type <> 'BOARDING')
        THROW 51005, 'Detail table does not match appointment type.', 1;

    IF EXISTS (SELECT 1 FROM dbo.Appointments a WHERE a.status <> 'DRAFT' AND
        ((a.appointment_type='SERVICE' AND NOT EXISTS
            (SELECT 1 FROM dbo.AppointmentServices s WHERE s.appointment_id=a.appointment_id)) OR
         (a.appointment_type='BOARDING' AND NOT EXISTS
            (SELECT 1 FROM dbo.BoardingDetails b WHERE b.appointment_id=a.appointment_id))))
        THROW 51006, 'Published appointment requires its details.', 1;

    IF EXISTS (SELECT 1 FROM dbo.Appointments a WHERE a.status <> 'DRAFT' AND a.subtotal_amount <>
        CASE WHEN a.appointment_type='BOARDING' THEN
            (SELECT CONVERT(DECIMAL(12,2), DATEDIFF(DAY,b.check_in_date,b.check_out_date)*b.daily_rate_at_booking)
             FROM dbo.BoardingDetails b WHERE b.appointment_id=a.appointment_id)
        WHEN a.combo_id IS NOT NULL THEN a.combo_price_at_booking
        ELSE (SELECT SUM(s.price_at_booking) FROM dbo.AppointmentServices s WHERE s.appointment_id=a.appointment_id) END)
        THROW 51007, 'Subtotal must match the immutable booking quote.', 1;

    IF EXISTS (SELECT 1 FROM dbo.Appointments a JOIN dbo.Users u ON u.user_id=a.customer_id
        WHERE a.status IN ('PENDING','CONFIRMED','CHECKED_IN','IN_PROGRESS') AND u.is_active=0)
        THROW 51008, 'Active appointments require an active customer.', 1;

    IF EXISTS (SELECT 1 FROM dbo.AppointmentServices s JOIN dbo.Appointments a ON a.appointment_id=s.appointment_id
        JOIN dbo.Users u ON u.user_id=s.staff_id
        WHERE a.status IN ('PENDING','CONFIRMED','CHECKED_IN','IN_PROGRESS') AND s.line_status <> 'CANCELLED' AND
        (u.is_active=0 OR CONVERT(DATE,s.scheduled_start)<>CONVERT(DATE,s.scheduled_end) OR
         NOT EXISTS (SELECT 1 FROM dbo.Shifts h WHERE h.staff_id=s.staff_id
             AND h.work_date=CONVERT(DATE,s.scheduled_start)
             AND h.start_time<=CONVERT(TIME,s.scheduled_start) AND h.end_time>=CONVERT(TIME,s.scheduled_end)) OR
         NOT EXISTS (SELECT 1 FROM dbo.BusinessHours h
             WHERE h.day_of_week=((DATEDIFF(DAY,CONVERT(DATE,'19000107',112),CONVERT(DATE,s.scheduled_start))%7)+7)%7
             AND h.is_closed=0 AND h.open_time<=CONVERT(TIME,s.scheduled_start)
             AND h.close_time>=CONVERT(TIME,s.scheduled_end))))
        THROW 51009, 'Service must fit an active staff shift and business hours on one day.', 1;

    IF EXISTS (SELECT 1 FROM dbo.AppointmentServices x JOIN dbo.Appointments ax ON ax.appointment_id=x.appointment_id
        JOIN dbo.AppointmentServices y ON
          (x.appointment_id<y.appointment_id OR (x.appointment_id=y.appointment_id AND x.service_id<y.service_id))
          AND x.scheduled_start<y.scheduled_end AND y.scheduled_start<x.scheduled_end
        JOIN dbo.Appointments ay ON ay.appointment_id=y.appointment_id
        WHERE ax.status IN ('PENDING','CONFIRMED','CHECKED_IN','IN_PROGRESS')
          AND ay.status IN ('PENDING','CONFIRMED','CHECKED_IN','IN_PROGRESS')
          AND x.line_status<>'CANCELLED' AND y.line_status<>'CANCELLED'
          AND (x.staff_id=y.staff_id OR ax.pet_id=ay.pet_id))
        THROW 51010, 'Staff or pet already has an overlapping service.', 1;

    IF EXISTS (SELECT 1 FROM dbo.BoardingDetails b JOIN dbo.Appointments a ON a.appointment_id=b.appointment_id
        JOIN dbo.Rooms r ON r.room_id=b.room_id
        WHERE a.status IN ('PENDING','CONFIRMED','CHECKED_IN','IN_PROGRESS') AND r.status='MAINTENANCE')
        THROW 51011, 'Room under maintenance has an active booking.', 1;
    IF EXISTS (SELECT 1 FROM dbo.BoardingDetails x JOIN dbo.Appointments ax ON ax.appointment_id=x.appointment_id
        JOIN dbo.BoardingDetails y ON x.appointment_id<y.appointment_id
          AND x.check_in_date<y.check_out_date AND y.check_in_date<x.check_out_date
        JOIN dbo.Appointments ay ON ay.appointment_id=y.appointment_id
        WHERE ax.status IN ('PENDING','CONFIRMED','CHECKED_IN','IN_PROGRESS')
          AND ay.status IN ('PENDING','CONFIRMED','CHECKED_IN','IN_PROGRESS')
          AND (x.room_id=y.room_id OR ax.pet_id=ay.pet_id))
        THROW 51012, 'Room or pet already has an overlapping stay.', 1;
    IF EXISTS (SELECT 1 FROM dbo.BoardingDetails b JOIN dbo.Appointments ab ON ab.appointment_id=b.appointment_id
        JOIN dbo.Appointments a ON a.pet_id=ab.pet_id
        JOIN dbo.AppointmentServices s ON s.appointment_id=a.appointment_id
        WHERE ab.status IN ('PENDING','CONFIRMED','CHECKED_IN','IN_PROGRESS')
          AND a.status IN ('PENDING','CONFIRMED','CHECKED_IN','IN_PROGRESS') AND s.line_status<>'CANCELLED'
          AND s.scheduled_start<CONVERT(DATETIME2,b.check_out_date)
          AND s.scheduled_end>CONVERT(DATETIME2,b.check_in_date))
        THROW 51013, 'Pet has overlapping service and boarding appointments.', 1;

    IF EXISTS (SELECT 1 FROM dbo.Appointments a WHERE a.status='COMPLETED' AND
         ((a.appointment_type='SERVICE' AND EXISTS (SELECT 1 FROM dbo.AppointmentServices s
             WHERE s.appointment_id=a.appointment_id AND s.line_status NOT IN ('COMPLETED','CANCELLED'))) OR
          (a.appointment_type='BOARDING' AND EXISTS (SELECT 1 FROM dbo.BoardingDetails b
             WHERE b.appointment_id=a.appointment_id AND (b.actual_check_in IS NULL OR b.actual_check_out IS NULL)))))
        THROW 51014, 'Complete service lines or record boarding check-out first.', 1;
    IF EXISTS (SELECT 1 FROM dbo.Reviews r JOIN dbo.Appointments a ON a.appointment_id=r.appointment_id
        WHERE a.status<>'COMPLETED')
        THROW 51015, 'Only completed appointments can be reviewed.', 1;

    IF EXISTS (SELECT 1 FROM dbo.Payments p JOIN dbo.Appointments a ON a.appointment_id=p.appointment_id
        WHERE p.payment_type='CHARGE' AND a.status='DRAFT')
        THROW 51016, 'Cannot charge a draft appointment.', 1;
    IF EXISTS (SELECT 1 FROM dbo.Payments p LEFT JOIN dbo.Payments original ON original.payment_id=p.original_payment_id
        WHERE p.payment_type='REFUND' AND
        (original.payment_id IS NULL OR original.payment_type<>'CHARGE' OR original.status<>'PAID'
         OR original.appointment_id<>p.appointment_id OR original.method<>p.method OR p.amount>original.amount))
        THROW 51017, 'Refund must reference a paid charge of the same appointment and method.', 1;
    IF EXISTS (SELECT 1 FROM dbo.Payments p JOIN dbo.Appointments a ON a.appointment_id=p.appointment_id
        WHERE p.payment_type='CHARGE' AND p.status IN ('PENDING','PAID')
        GROUP BY p.appointment_id,a.total_amount HAVING SUM(p.amount)>a.total_amount)
        THROW 51018, 'Reserved or captured charges exceed the appointment total.', 1;
    IF EXISTS (SELECT 1 FROM dbo.Payments r JOIN dbo.Payments p ON p.payment_id=r.original_payment_id
        WHERE r.payment_type='REFUND' AND r.status IN ('PENDING','PAID')
        GROUP BY r.original_payment_id,p.amount HAVING SUM(r.amount)>p.amount)
        THROW 51019, 'Reserved or settled refunds exceed the original captured charge.', 1;
END;
GO
CREATE TRIGGER dbo.TR_Appointments_Integrity ON dbo.Appointments AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL(OBJECT_ID('dbo.TR_Appointments_Integrity'),'AFTER','DML')>1 RETURN;
    IF EXISTS (SELECT 1 FROM deleted d LEFT JOIN inserted i ON i.appointment_id=d.appointment_id
        WHERE i.appointment_id IS NULL AND d.status<>'DRAFT')
        THROW 51020, 'Published appointments cannot be deleted.', 1;
    IF EXISTS (SELECT 1 FROM inserted i JOIN deleted d ON d.appointment_id=i.appointment_id
        WHERE d.status<>'DRAFT' AND (i.customer_id<>d.customer_id OR i.pet_id<>d.pet_id
        OR i.appointment_type<>d.appointment_type OR ISNULL(i.combo_id,-1)<>ISNULL(d.combo_id,-1)
        OR ISNULL(i.combo_price_at_booking,-1)<>ISNULL(d.combo_price_at_booking,-1)
        OR i.subtotal_amount<>d.subtotal_amount OR i.adjustment_amount<>d.adjustment_amount))
        THROW 51021, 'Published booking identity and quote are immutable; cancel and rebook.', 1;
    IF EXISTS (SELECT 1 FROM inserted i JOIN deleted d ON d.appointment_id=i.appointment_id
        WHERE i.status<>d.status AND NOT (
            (d.status='DRAFT' AND i.status='PENDING') OR
            (d.status='PENDING' AND i.status IN ('CONFIRMED','CANCELLED','NO_SHOW')) OR
            (d.status='CONFIRMED' AND i.status IN ('CHECKED_IN','CANCELLED','NO_SHOW')) OR
            (d.status='CHECKED_IN' AND i.status IN ('IN_PROGRESS','COMPLETED','CANCELLED')) OR
            (d.status='IN_PROGRESS' AND i.status IN ('COMPLETED','CANCELLED'))))
        THROW 51022, 'Invalid appointment status transition.', 1;
    -- Check membership once when the quote is frozen. Later catalog changes do not rewrite history.
    IF EXISTS (SELECT 1 FROM inserted i JOIN deleted d ON d.appointment_id=i.appointment_id
        WHERE d.status='DRAFT' AND i.status='PENDING' AND i.combo_id IS NOT NULL AND
        (EXISTS (SELECT cs.service_id FROM dbo.ComboServices cs WHERE cs.combo_id=i.combo_id
                 EXCEPT SELECT s.service_id FROM dbo.AppointmentServices s WHERE s.appointment_id=i.appointment_id)
         OR EXISTS (SELECT s.service_id FROM dbo.AppointmentServices s WHERE s.appointment_id=i.appointment_id
                    EXCEPT SELECT cs.service_id FROM dbo.ComboServices cs WHERE cs.combo_id=i.combo_id)))
        THROW 51023, 'Booked service set must exactly match the combo.', 1;
    EXEC dbo.AssertPetCareIntegrity;
    UPDATE a SET updated_at=SYSDATETIME() FROM dbo.Appointments a JOIN inserted i ON i.appointment_id=a.appointment_id;
END;
GO
CREATE TRIGGER dbo.TR_AppointmentServices_Integrity ON dbo.AppointmentServices AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted i LEFT JOIN deleted d
        ON d.appointment_id=i.appointment_id AND d.service_id=i.service_id
        JOIN dbo.Appointments a ON a.appointment_id=i.appointment_id
        WHERE a.status<>'DRAFT' AND (d.appointment_id IS NULL OR i.staff_id<>d.staff_id
        OR i.scheduled_start<>d.scheduled_start OR i.scheduled_end<>d.scheduled_end OR i.price_at_booking<>d.price_at_booking))
       OR EXISTS (SELECT 1 FROM deleted d LEFT JOIN inserted i
        ON d.appointment_id=i.appointment_id AND d.service_id=i.service_id
        JOIN dbo.Appointments a ON a.appointment_id=d.appointment_id
        WHERE a.status<>'DRAFT' AND i.appointment_id IS NULL)
        THROW 51024, 'Published service identity, time and price cannot change.', 1;
    EXEC dbo.AssertPetCareIntegrity;
    UPDATE a SET updated_at=SYSDATETIME() FROM dbo.Appointments a WHERE a.appointment_id IN
        (SELECT appointment_id FROM inserted UNION SELECT appointment_id FROM deleted);
END;
GO
CREATE TRIGGER dbo.TR_BoardingDetails_Integrity ON dbo.BoardingDetails AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted i LEFT JOIN deleted d ON d.appointment_id=i.appointment_id
        JOIN dbo.Appointments a ON a.appointment_id=i.appointment_id WHERE a.status<>'DRAFT' AND
        (d.appointment_id IS NULL OR i.room_id<>d.room_id OR i.check_in_date<>d.check_in_date
         OR i.check_out_date<>d.check_out_date OR i.daily_rate_at_booking<>d.daily_rate_at_booking))
       OR EXISTS (SELECT 1 FROM deleted d LEFT JOIN inserted i ON i.appointment_id=d.appointment_id
        JOIN dbo.Appointments a ON a.appointment_id=d.appointment_id
        WHERE a.status<>'DRAFT' AND i.appointment_id IS NULL)
        THROW 51025, 'Published room, dates and rate cannot change.', 1;
    EXEC dbo.AssertPetCareIntegrity;
    UPDATE a SET updated_at=SYSDATETIME() FROM dbo.Appointments a WHERE a.appointment_id IN
        (SELECT appointment_id FROM inserted UNION SELECT appointment_id FROM deleted);
END;
GO
CREATE TRIGGER dbo.TR_Payments_Integrity ON dbo.Payments AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM deleted d LEFT JOIN inserted i ON i.payment_id=d.payment_id
        WHERE i.payment_id IS NULL OR i.appointment_id<>d.appointment_id OR i.amount<>d.amount
        OR i.method<>d.method OR i.payment_key<>d.payment_key OR i.payment_type<>d.payment_type
        OR ISNULL(i.original_payment_id,-1)<>ISNULL(d.original_payment_id,-1)
        OR ISNULL(i.transaction_ref,N'')<>ISNULL(d.transaction_ref,N'')
        OR (d.status<>'PENDING' AND i.status<>d.status)
        OR (d.paid_at IS NOT NULL AND (i.paid_at IS NULL OR i.paid_at<>d.paid_at)))
        THROW 51026, 'Payment identity is immutable; settled/failed attempts cannot be rewritten.', 1;
    EXEC dbo.AssertPetCareIntegrity;
END;
GO
-- Master-data changes must not invalidate existing active appointments.
DECLARE @table SYSNAME, @ddl NVARCHAR(MAX);
DECLARE validation_tables CURSOR LOCAL FAST_FORWARD FOR
    SELECT name FROM (VALUES ('Users'),('Pets'),('StaffSkills'),('Shifts'),('BusinessHours'),('Rooms'),('Reviews')) t(name);
OPEN validation_tables;
FETCH NEXT FROM validation_tables INTO @table;
WHILE @@FETCH_STATUS=0
BEGIN
    SET @ddl=N'CREATE TRIGGER dbo.'+QUOTENAME('TR_'+@table+'_Integrity')+N' ON dbo.'+QUOTENAME(@table)+
        N' AFTER INSERT,UPDATE,DELETE AS BEGIN SET NOCOUNT ON; EXEC dbo.AssertPetCareIntegrity; END;';
    EXEC sys.sp_executesql @ddl;
    FETCH NEXT FROM validation_tables INTO @table;
END;
CLOSE validation_tables;
DEALLOCATE validation_tables;
GO

CREATE PROCEDURE dbo.BookServiceAppointment
    @customer_id INT,
    @pet_id INT,
    @items dbo.ServiceBookingItems READONLY,
    @combo_id INT = NULL,
    @appointment_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_PADDING ON;
    SET ANSI_WARNINGS ON;
    SET ARITHABORT ON;
    SET CONCAT_NULL_YIELDS_NULL ON;
    SET NUMERIC_ROUNDABORT OFF;
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    SET @appointment_id=NULL;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.AcquirePetCareLock;
        IF NOT EXISTS (SELECT 1 FROM @items) OR (SELECT COUNT(*) FROM @items)>100
            THROW 51030, 'Supply between 1 and 100 distinct services.', 1;
        IF NOT EXISTS (SELECT 1 FROM dbo.Pets p JOIN dbo.Users u ON u.user_id=p.owner_id
            WHERE p.pet_id=@pet_id AND p.owner_id=@customer_id AND u.role='CUSTOMER' AND u.is_active=1)
            THROW 51031, 'Pet must belong to an active customer.', 1;
        IF EXISTS (SELECT 1 FROM @items i LEFT JOIN dbo.Services s ON s.service_id=i.service_id
            LEFT JOIN dbo.StaffSkills k ON k.service_id=i.service_id AND k.staff_id=i.staff_id
            LEFT JOIN dbo.Users u ON u.user_id=i.staff_id
            WHERE s.service_id IS NULL OR s.is_active=0 OR s.category='BOARDING' OR k.staff_id IS NULL
                OR u.role<>'STAFF' OR u.is_active=0
                OR i.scheduled_end<>DATEADD(MINUTE,s.duration_minutes,i.scheduled_start))
            THROW 51032, 'Invalid service, staff skill or configured service duration.', 1;
        DECLARE @combo_price DECIMAL(10,2)=NULL, @subtotal DECIMAL(12,2);
        IF @combo_id IS NOT NULL
        BEGIN
            SELECT @combo_price=price FROM dbo.Combos WHERE combo_id=@combo_id AND is_active=1;
            IF @combo_price IS NULL THROW 51033, 'Combo is missing or inactive.', 1;
            IF EXISTS (SELECT service_id FROM dbo.ComboServices WHERE combo_id=@combo_id EXCEPT SELECT service_id FROM @items)
                OR EXISTS (SELECT service_id FROM @items EXCEPT SELECT service_id FROM dbo.ComboServices WHERE combo_id=@combo_id)
                THROW 51023, 'Booked service set must exactly match the combo.', 1;
            SET @subtotal=@combo_price;
        END
        ELSE
            SELECT @subtotal=SUM(CONVERT(DECIMAL(12,2),s.price)) FROM @items i JOIN dbo.Services s ON s.service_id=i.service_id;
        INSERT dbo.Appointments(customer_id,pet_id,appointment_type,combo_id,status,subtotal_amount,combo_price_at_booking)
            VALUES(@customer_id,@pet_id,'SERVICE',@combo_id,'DRAFT',@subtotal,@combo_price);
        SET @appointment_id=CONVERT(INT,SCOPE_IDENTITY());
        INSERT dbo.AppointmentServices(appointment_id,service_id,staff_id,scheduled_start,scheduled_end,price_at_booking)
            SELECT @appointment_id,i.service_id,i.staff_id,i.scheduled_start,i.scheduled_end,s.price
            FROM @items i JOIN dbo.Services s ON s.service_id=i.service_id;
        UPDATE dbo.Appointments SET status='PENDING' WHERE appointment_id=@appointment_id;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE()<>0 ROLLBACK;
        SET @appointment_id=NULL;
        THROW;
    END CATCH;
END;
GO
CREATE PROCEDURE dbo.BookBoardingAppointment
    @customer_id INT,
    @pet_id INT,
    @room_id INT,
    @check_in_date DATE,
    @check_out_date DATE,
    @appointment_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_PADDING ON;
    SET ANSI_WARNINGS ON;
    SET ARITHABORT ON;
    SET CONCAT_NULL_YIELDS_NULL ON;
    SET NUMERIC_ROUNDABORT OFF;
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    SET @appointment_id=NULL;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.AcquirePetCareLock;
        IF @check_in_date IS NULL OR @check_out_date IS NULL OR @check_in_date>=@check_out_date
            THROW 51034, 'Check-out must be after check-in.', 1;
        IF NOT EXISTS (SELECT 1 FROM dbo.Pets p JOIN dbo.Users u ON u.user_id=p.owner_id
            WHERE p.pet_id=@pet_id AND p.owner_id=@customer_id AND u.role='CUSTOMER' AND u.is_active=1)
            THROW 51031, 'Pet must belong to an active customer.', 1;
        DECLARE @rate DECIMAL(10,2);
        SELECT @rate=daily_rate FROM dbo.Rooms WHERE room_id=@room_id AND status<>'MAINTENANCE';
        IF @rate IS NULL THROW 51035, 'Room does not exist or is under maintenance.', 1;
        INSERT dbo.Appointments(customer_id,pet_id,appointment_type,status,subtotal_amount)
            VALUES(@customer_id,@pet_id,'BOARDING','DRAFT',CONVERT(DECIMAL(12,2),DATEDIFF(DAY,@check_in_date,@check_out_date)*@rate));
        SET @appointment_id=CONVERT(INT,SCOPE_IDENTITY());
        INSERT dbo.BoardingDetails(appointment_id,room_id,check_in_date,check_out_date,daily_rate_at_booking)
            VALUES(@appointment_id,@room_id,@check_in_date,@check_out_date,@rate);
        UPDATE dbo.Appointments SET status='PENDING' WHERE appointment_id=@appointment_id;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE()<>0 ROLLBACK;
        SET @appointment_id=NULL;
        THROW;
    END CATCH;
END;
GO
CREATE PROCEDURE dbo.SetAppointmentStatus
    @appointment_id INT,
    @status VARCHAR(20),
    @cancel_reason NVARCHAR(255)=NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_PADDING ON;
    SET ANSI_WARNINGS ON;
    SET ARITHABORT ON;
    SET CONCAT_NULL_YIELDS_NULL ON;
    SET NUMERIC_ROUNDABORT OFF;
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.AcquirePetCareLock;
        DECLARE @old VARCHAR(20), @type VARCHAR(10), @event_time DATETIME2=SYSDATETIME();
        SELECT @old=status,@type=appointment_type FROM dbo.Appointments WHERE appointment_id=@appointment_id;
        IF @old IS NULL THROW 51036, 'Appointment does not exist.', 1;
        IF @status IS NULL OR @status NOT IN ('CONFIRMED','CHECKED_IN','IN_PROGRESS','COMPLETED','CANCELLED','NO_SHOW')
            THROW 51022, 'Invalid appointment status transition.', 1;
        IF @status='CANCELLED' AND NULLIF(LTRIM(RTRIM(@cancel_reason)),N'') IS NULL
            THROW 51037, 'Cancellation reason is required.', 1;
        IF @status=@old BEGIN COMMIT; RETURN; END;
        -- Check before changing child states, in addition to the parent trigger.
        IF NOT ((@old='PENDING' AND @status IN ('CONFIRMED','CANCELLED','NO_SHOW')) OR
            (@old='CONFIRMED' AND @status IN ('CHECKED_IN','CANCELLED','NO_SHOW')) OR
            (@old='CHECKED_IN' AND @status IN ('IN_PROGRESS','COMPLETED','CANCELLED')) OR
            (@old='IN_PROGRESS' AND @status IN ('COMPLETED','CANCELLED')))
            THROW 51022, 'Invalid appointment status transition.', 1;
        IF @type='SERVICE'
        BEGIN
            IF @status='IN_PROGRESS'
                UPDATE dbo.AppointmentServices SET line_status='IN_PROGRESS'
                    WHERE appointment_id=@appointment_id AND line_status='PENDING';
            IF @status='COMPLETED'
                UPDATE dbo.AppointmentServices SET line_status='COMPLETED'
                    WHERE appointment_id=@appointment_id AND line_status IN ('PENDING','IN_PROGRESS');
            IF @status IN ('CANCELLED','NO_SHOW')
                UPDATE dbo.AppointmentServices SET line_status='CANCELLED'
                    WHERE appointment_id=@appointment_id AND line_status IN ('PENDING','IN_PROGRESS');
        END
        ELSE
        BEGIN
            IF @status='CHECKED_IN'
                UPDATE dbo.BoardingDetails SET actual_check_in=@event_time WHERE appointment_id=@appointment_id;
            IF @status='COMPLETED'
                UPDATE dbo.BoardingDetails SET actual_check_out=@event_time WHERE appointment_id=@appointment_id;
        END;
        UPDATE dbo.Appointments SET status=@status,cancel_reason=CASE WHEN @status='CANCELLED' THEN @cancel_reason ELSE NULL END
            WHERE appointment_id=@appointment_id;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE()<>0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO
-- Payment procedures are granted only to a trusted payment backend role.
-- They record verified cash/provider outcomes; they do not contact a payment provider.
CREATE PROCEDURE dbo.RecordPayment
    @appointment_id INT,
    @amount DECIMAL(12,2),
    @method VARCHAR(10),
    @payment_key UNIQUEIDENTIFIER,
    @payment_id INT OUTPUT,
    @payment_type VARCHAR(6)='CHARGE',
    @original_payment_id INT=NULL,
    @transaction_ref NVARCHAR(100)=NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_PADDING ON;
    SET ANSI_WARNINGS ON;
    SET ARITHABORT ON;
    SET CONCAT_NULL_YIELDS_NULL ON;
    SET NUMERIC_ROUNDABORT OFF;
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    SET @payment_id=NULL;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.AcquirePetCareLock;
        IF @payment_key IS NULL THROW 51038, 'A stable payment idempotency key is required.', 1;
        SELECT @payment_id=payment_id FROM dbo.Payments WHERE payment_key=@payment_key;
        IF @payment_id IS NOT NULL
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_id=@payment_id AND appointment_id=@appointment_id
                AND amount=@amount AND method=@method AND payment_type=@payment_type
                AND ISNULL(original_payment_id,-1)=ISNULL(@original_payment_id,-1)
                AND ISNULL(transaction_ref,N'')=ISNULL(@transaction_ref,N''))
                THROW 51039, 'Idempotency key was already used for a different payment.', 1;
            COMMIT; RETURN;
        END;
        IF NOT EXISTS (SELECT 1 FROM dbo.Appointments WHERE appointment_id=@appointment_id AND status<>'DRAFT')
            THROW 51040, 'A published appointment is required.', 1;
        IF @method='ONLINE' AND NULLIF(LTRIM(RTRIM(@transaction_ref)),N'') IS NULL
            THROW 51041, 'Online payments require a provider transaction reference.', 1;
        INSERT dbo.Payments(appointment_id,amount,method,payment_key,payment_type,original_payment_id,transaction_ref)
            VALUES(@appointment_id,@amount,@method,@payment_key,@payment_type,@original_payment_id,@transaction_ref);
        SET @payment_id=CONVERT(INT,SCOPE_IDENTITY());
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE()<>0 ROLLBACK;
        SET @payment_id=NULL;
        THROW;
    END CATCH;
END;
GO
CREATE PROCEDURE dbo.SetPaymentStatus @payment_id INT,@status VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_PADDING ON;
    SET ANSI_WARNINGS ON;
    SET ARITHABORT ON;
    SET CONCAT_NULL_YIELDS_NULL ON;
    SET NUMERIC_ROUNDABORT OFF;
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.AcquirePetCareLock;
        DECLARE @old VARCHAR(10);
        SELECT @old=status FROM dbo.Payments WHERE payment_id=@payment_id;
        IF @old IS NULL THROW 51042, 'Payment does not exist.', 1;
        IF @status IS NULL OR @status NOT IN ('PAID','FAILED') THROW 51043, 'Invalid payment outcome.', 1;
        IF @old=@status BEGIN COMMIT; RETURN; END;
        IF @old<>'PENDING' THROW 51043, 'Final payment outcomes cannot be changed.', 1;
        UPDATE dbo.Payments SET status=@status,paid_at=CASE WHEN @status='PAID' THEN SYSDATETIME() ELSE NULL END
            WHERE payment_id=@payment_id;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE()<>0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO
CREATE PROCEDURE dbo.SubmitReview
    @appointment_id INT,@customer_id INT,@rating TINYINT,@comment NVARCHAR(1000)=NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_PADDING ON;
    SET ANSI_WARNINGS ON;
    SET ARITHABORT ON;
    SET CONCAT_NULL_YIELDS_NULL ON;
    SET NUMERIC_ROUNDABORT OFF;
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.AcquirePetCareLock;
        IF NOT EXISTS (SELECT 1 FROM dbo.Appointments WHERE appointment_id=@appointment_id
            AND customer_id=@customer_id AND status='COMPLETED')
            THROW 51044, 'Only the appointment customer may review a completed appointment.', 1;
        INSERT dbo.Reviews(appointment_id,customer_id,rating,comment) VALUES(@appointment_id,@customer_id,@rating,@comment);
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE()<>0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO
-- Empty database roles only; no logins/users are created or assigned automatically.
CREATE ROLE petcare_booking_app AUTHORIZATION dbo;
CREATE ROLE petcare_payment_app AUTHORIZATION dbo;
GRANT SELECT, INSERT, UPDATE ON dbo.Users TO petcare_booking_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Pets TO petcare_booking_app;
GRANT SELECT ON dbo.Payments TO petcare_payment_app;
GRANT EXECUTE ON dbo.BookServiceAppointment TO petcare_booking_app;
GRANT EXECUTE ON dbo.BookBoardingAppointment TO petcare_booking_app;
GRANT EXECUTE ON dbo.SetAppointmentStatus TO petcare_booking_app;
GRANT EXECUTE ON dbo.SubmitReview TO petcare_booking_app;
GRANT EXECUTE,REFERENCES ON TYPE::dbo.ServiceBookingItems TO petcare_booking_app;
GRANT EXECUTE ON dbo.RecordPayment TO petcare_payment_app;
GRANT EXECUTE ON dbo.SetPaymentStatus TO petcare_payment_app;
COMMIT;
GO

