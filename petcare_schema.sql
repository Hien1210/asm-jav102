-- =========================================================
-- PetCare Smart Appointment - Database Schema
-- DBMS: SQL Server (T-SQL)
-- =========================================================

-- ============== 1. USERS & ROLES ==============
CREATE TABLE Users (
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
CREATE TABLE Pets (
    pet_id          INT IDENTITY(1,1) PRIMARY KEY,
    owner_id        INT             NOT NULL REFERENCES Users(user_id),
    name            NVARCHAR(100)   NOT NULL,
    species         NVARCHAR(50)    NOT NULL,   -- chó, mèo, ...
    breed           NVARCHAR(100),
    weight_kg       DECIMAL(5,2),
    birth_date      DATE,
    medical_notes   NVARCHAR(MAX),              -- lịch sử khám tóm tắt
    created_at      DATETIME2       NOT NULL DEFAULT SYSDATETIME()
);

-- ============== 3. SERVICES ==============
CREATE TABLE Services (
    service_id      INT IDENTITY(1,1) PRIMARY KEY,
    name            NVARCHAR(100)   NOT NULL,
    description     NVARCHAR(500),
    category        VARCHAR(20)     NOT NULL
                    CHECK (category IN ('GROOMING','MEDICAL','VACCINATION','BOARDING','OTHER')),
    duration_minutes INT            NOT NULL DEFAULT 30,  -- không dùng cho BOARDING
    price           DECIMAL(10,2)   NOT NULL,
    is_active       BIT             NOT NULL DEFAULT 1
);

-- ============== 4. COMBOS (gói nhiều dịch vụ) ==============
CREATE TABLE Combos (
    combo_id        INT IDENTITY(1,1) PRIMARY KEY,
    name            NVARCHAR(100)   NOT NULL,
    description     NVARCHAR(500),
    price           DECIMAL(10,2)   NOT NULL,   -- giá gói (thường rẻ hơn tổng lẻ)
    is_active       BIT             NOT NULL DEFAULT 1
);

CREATE TABLE ComboServices (
    combo_id        INT             NOT NULL REFERENCES Combos(combo_id),
    service_id      INT             NOT NULL REFERENCES Services(service_id),
    PRIMARY KEY (combo_id, service_id)
);

-- ============== 5. STAFF SKILLS (many-to-many) ==============
CREATE TABLE StaffSkills (
    staff_id        INT             NOT NULL REFERENCES Users(user_id),
    service_id      INT             NOT NULL REFERENCES Services(service_id),
    PRIMARY KEY (staff_id, service_id)
);

-- ============== 6. SHIFTS (ca làm việc) ==============
CREATE TABLE Shifts (
    shift_id        INT IDENTITY(1,1) PRIMARY KEY,
    staff_id        INT             NOT NULL REFERENCES Users(user_id),
    work_date       DATE            NOT NULL,
    start_time      TIME            NOT NULL,
    end_time        TIME            NOT NULL,
    CONSTRAINT CK_Shift_Time CHECK (start_time < end_time)
);

-- ============== 7. BUSINESS HOURS ==============
CREATE TABLE BusinessHours (
    day_of_week     TINYINT         PRIMARY KEY,  -- 0=CN ... 6=Thứ 7
    open_time       TIME,
    close_time      TIME,
    is_closed       BIT             NOT NULL DEFAULT 0
);

-- ============== 8. ROOMS (cho boarding) ==============
CREATE TABLE Rooms (
    room_id         INT IDENTITY(1,1) PRIMARY KEY,
    room_code       NVARCHAR(20)    NOT NULL UNIQUE,
    room_type       NVARCHAR(50),               -- size/loài phù hợp
    daily_rate      DECIMAL(10,2)   NOT NULL,
    status          VARCHAR(20)     NOT NULL DEFAULT 'AVAILABLE'
                    CHECK (status IN ('AVAILABLE','OCCUPIED','MAINTENANCE'))
);

-- ============== 9. APPOINTMENTS (bảng gốc) ==============
CREATE TABLE Appointments (
    appointment_id  INT IDENTITY(1,1) PRIMARY KEY,
    customer_id     INT             NOT NULL REFERENCES Users(user_id),
    pet_id          INT             NOT NULL REFERENCES Pets(pet_id),
    appointment_type VARCHAR(10)    NOT NULL
                    CHECK (appointment_type IN ('SERVICE','BOARDING')),
    combo_id        INT             NULL REFERENCES Combos(combo_id),  -- NULL nếu đặt lẻ, không qua combo
    status          VARCHAR(20)     NOT NULL DEFAULT 'PENDING'
                    CHECK (status IN ('PENDING','CONFIRMED','CHECKED_IN',
                                       'IN_PROGRESS','COMPLETED','CANCELLED','NO_SHOW')),
    cancel_reason   NVARCHAR(255),
    created_at      DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
    updated_at      DATETIME2       NOT NULL DEFAULT SYSDATETIME()
);

-- ============== 10. APPOINTMENT SERVICES (1 lịch hẹn - nhiều dịch vụ) ==============
-- Mỗi dòng = 1 dịch vụ trong lịch hẹn, có thể khác nhân viên/khung giờ nhau.
CREATE TABLE AppointmentServices (
    appointment_id  INT             NOT NULL REFERENCES Appointments(appointment_id),
    service_id      INT             NOT NULL REFERENCES Services(service_id),
    staff_id        INT             NOT NULL REFERENCES Users(user_id),
    scheduled_start DATETIME2       NOT NULL,
    scheduled_end   DATETIME2       NOT NULL,
    price_at_booking DECIMAL(10,2)  NOT NULL,   -- giá tại thời điểm đặt (phòng khi giá dịch vụ đổi sau này)
    line_status     VARCHAR(20)     NOT NULL DEFAULT 'PENDING'
                    CHECK (line_status IN ('PENDING','IN_PROGRESS','COMPLETED','CANCELLED')),
    PRIMARY KEY (appointment_id, service_id)
);

-- ============== 11. BOARDING DETAILS (1-1, khi type=BOARDING) ==============
CREATE TABLE BoardingDetails (
    appointment_id  INT             PRIMARY KEY REFERENCES Appointments(appointment_id),
    room_id         INT             NOT NULL REFERENCES Rooms(room_id),
    check_in_date   DATE            NOT NULL,
    check_out_date  DATE            NOT NULL,
    actual_check_in DATETIME2,
    actual_check_out DATETIME2,
    CONSTRAINT CK_Boarding_Date CHECK (check_in_date < check_out_date)
);

-- ============== 12. PAYMENTS ==============
-- 1 payment ứng với toàn bộ Appointment (tổng tiền các dịch vụ/combo trong đó)
CREATE TABLE Payments (
    payment_id      INT IDENTITY(1,1) PRIMARY KEY,
    appointment_id  INT             NOT NULL REFERENCES Appointments(appointment_id),
    amount          DECIMAL(10,2)   NOT NULL,
    method          VARCHAR(10)     NOT NULL CHECK (method IN ('CASH','ONLINE')),
    status          VARCHAR(10)     NOT NULL DEFAULT 'PENDING'
                    CHECK (status IN ('PENDING','PAID','REFUNDED','FAILED')),
    transaction_ref NVARCHAR(100),              -- mã giao dịch cổng thanh toán
    paid_at         DATETIME2
);

-- ============== 13. REVIEWS ==============
CREATE TABLE Reviews (
    review_id       INT IDENTITY(1,1) PRIMARY KEY,
    appointment_id  INT             NOT NULL REFERENCES Appointments(appointment_id) UNIQUE,
    customer_id     INT             NOT NULL REFERENCES Users(user_id),
    rating          TINYINT         NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment         NVARCHAR(1000),
    created_at      DATETIME2       NOT NULL DEFAULT SYSDATETIME()
);

-- ============== 14. NOTIFICATIONS ==============
CREATE TABLE Notifications (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id         INT             NOT NULL REFERENCES Users(user_id),
    appointment_id  INT             NULL REFERENCES Appointments(appointment_id),
    type            VARCHAR(20)     NOT NULL
                    CHECK (type IN ('REMINDER','CONFIRMATION','CANCELLATION','OTHER')),
    channel         VARCHAR(10)     NOT NULL CHECK (channel IN ('EMAIL','SMS','PUSH')),
    content         NVARCHAR(500),
    status          VARCHAR(10)     NOT NULL DEFAULT 'PENDING'
                    CHECK (status IN ('PENDING','SENT','FAILED')),
    created_at      DATETIME2       NOT NULL DEFAULT SYSDATETIME()
);

-- ============== INDEXES GỢI Ý ==============
CREATE INDEX IX_Pets_Owner ON Pets(owner_id);
CREATE INDEX IX_Appointments_Customer ON Appointments(customer_id);
CREATE INDEX IX_Appointments_Status ON Appointments(status);
CREATE INDEX IX_ApptServices_Staff_Time ON AppointmentServices(staff_id, scheduled_start);
CREATE INDEX IX_ApptServices_Appointment ON AppointmentServices(appointment_id);
CREATE INDEX IX_Shifts_Staff_Date ON Shifts(staff_id, work_date);
CREATE INDEX IX_Boarding_Room_Date ON BoardingDetails(room_id, check_in_date, check_out_date);
