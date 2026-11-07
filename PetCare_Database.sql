/* =========================================================================
   PETCARE SMART APPOINTMENT - DATABASE SCHEMA RÚT GỌN (SQL Server / T-SQL)
   Đã tối ưu từ 30 bảng xuống 12 bảng cốt lõi bằng cách:
   1. Gộp roles + employees vào users (dùng cột role: CUSTOMER / STAFF / ADMIN)
   2. Gộp pet_status_logs vào pets (lưu trạng thái + lý do/người đổi gần nhất)
   3. Gộp reviews (quan hệ 1-1) và thông tin điều chỉnh D vào appointments
   4. Gộp các bảng lịch sử/sự cố/liên hệ/thông báo rời rạc (status_logs,
      reschedules, leave_impacts, closure_items, contact_attempts, outbox...)
      thành 1 bảng sự kiện chung: appointment_logs
   5. Gộp khóa chống lặp (idempotency_key) trực tiếp lên bảng giao dịch
   ========================================================================= */

SET NOCOUNT ON;
GO

IF DB_ID('PetCareDB') IS NULL
BEGIN
    CREATE DATABASE PetCareDB;
END
GO
USE PetCareDB;
GO

/* =========================================================================
   1. NGƯỜI DÙNG & NHÂN VIÊN (Gộp roles + users + employees)
   ========================================================================= */
CREATE TABLE users (
    id              BIGINT IDENTITY(1,1)    NOT NULL,
    role            VARCHAR(20)             NOT NULL CONSTRAINT DF_users_role DEFAULT ('CUSTOMER'),
    full_name       NVARCHAR(150)           NOT NULL,
    email           VARCHAR(255)            NULL,
    phone           VARCHAR(20)             NULL,
    password_hash   VARCHAR(255)            NOT NULL,
    status          VARCHAR(20)             NOT NULL CONSTRAINT DF_users_status DEFAULT ('ACTIVE'),
    created_at      DATETIME2(3)            NOT NULL CONSTRAINT DF_users_created_at DEFAULT SYSUTCDATETIME(),
    row_version     ROWVERSION,
    CONSTRAINT PK_users PRIMARY KEY (id),
    CONSTRAINT CK_users_role CHECK (role IN ('CUSTOMER', 'STAFF', 'ADMIN')),
    CONSTRAINT CK_users_status CHECK (status IN ('ACTIVE', 'INACTIVE', 'LOCKED'))
);
GO
CREATE UNIQUE INDEX UX_users_email ON users(email) WHERE email IS NOT NULL;
GO
CREATE UNIQUE INDEX UX_users_phone ON users(phone) WHERE phone IS NOT NULL;
GO

/* =========================================================================
   2. THÚ CƯNG (Gộp pets + pet_status_logs)
   ========================================================================= */
CREATE TABLE pets (
    id                  BIGINT IDENTITY(1,1)    NOT NULL,
    customer_id         BIGINT                  NOT NULL,
    name                NVARCHAR(100)           NOT NULL,
    species             NVARCHAR(50)            NULL,
    breed               NVARCHAR(100)           NULL,
    birth_date          DATE                    NULL,
    weight_kg           DECIMAL(6,2)            NULL,
    note                NVARCHAR(500)           NULL,
    status              VARCHAR(20)             NOT NULL CONSTRAINT DF_pets_status DEFAULT ('ACTIVE'),
    status_reason       NVARCHAR(500)           NULL,
    status_changed_by   BIGINT                  NULL,
    status_changed_at   DATETIME2(3)            NULL,
    created_at          DATETIME2(3)            NOT NULL CONSTRAINT DF_pets_created_at DEFAULT SYSUTCDATETIME(),
    row_version         ROWVERSION,
    CONSTRAINT PK_pets PRIMARY KEY (id),
    CONSTRAINT FK_pets_customer FOREIGN KEY (customer_id) REFERENCES users(id),
    CONSTRAINT FK_pets_changedby FOREIGN KEY (status_changed_by) REFERENCES users(id),
    CONSTRAINT CK_pets_status CHECK (status IN ('ACTIVE', 'INACTIVE')),
    CONSTRAINT UQ_pets_id_customer UNIQUE (id, customer_id)
);
GO
CREATE INDEX IX_pets_customer ON pets(customer_id);
GO

/* =========================================================================
   3. DỊCH VỤ (services)
   ========================================================================= */
CREATE TABLE services (
    id                  INT IDENTITY(1,1)       NOT NULL,
    name                NVARCHAR(150)           NOT NULL,
    description         NVARCHAR(500)           NULL,
    base_price          DECIMAL(12,2)           NOT NULL,
    duration_minutes    INT                     NOT NULL,
    buffer_minutes      INT                     NOT NULL CONSTRAINT DF_services_buffer DEFAULT (0),
    status              VARCHAR(20)             NOT NULL CONSTRAINT DF_services_status DEFAULT ('ACTIVE'),
    created_at          DATETIME2(3)            NOT NULL CONSTRAINT DF_services_created_at DEFAULT SYSUTCDATETIME(),
    row_version         ROWVERSION,
    CONSTRAINT PK_services PRIMARY KEY (id),
    CONSTRAINT CK_services_status CHECK (status IN ('ACTIVE', 'INACTIVE')),
    CONSTRAINT CK_services_price CHECK (base_price >= 0),
    CONSTRAINT CK_services_duration CHECK (duration_minutes > 0 AND buffer_minutes >= 0)
);
GO

/* =========================================================================
   4. KỸ NĂNG NHÂN VIÊN (employee_services)
   ========================================================================= */
CREATE TABLE employee_services (
    employee_id     BIGINT      NOT NULL,
    service_id      INT         NOT NULL,
    CONSTRAINT PK_employee_services PRIMARY KEY (employee_id, service_id),
    CONSTRAINT FK_empsvc_employee FOREIGN KEY (employee_id) REFERENCES users(id),
    CONSTRAINT FK_empsvc_service FOREIGN KEY (service_id) REFERENCES services(id)
);
GO

/* =========================================================================
   5. CA LÀM VIỆC & NGHỈ PHÉP NHÂN VIÊN (employee_schedules)
   ========================================================================= */
CREATE TABLE employee_schedules (
    id              BIGINT IDENTITY(1,1)    NOT NULL,
    employee_id     BIGINT                  NOT NULL,
    work_date       DATE                    NOT NULL,
    start_time      TIME(0)                 NOT NULL,
    end_time        TIME(0)                 NOT NULL,
    is_off          BIT                     NOT NULL CONSTRAINT DF_empsched_isoff DEFAULT (0),
    leave_reason    NVARCHAR(500)           NULL,
    row_version     ROWVERSION,
    CONSTRAINT PK_employee_schedules PRIMARY KEY (id),
    CONSTRAINT FK_empsched_employee FOREIGN KEY (employee_id) REFERENCES users(id),
    CONSTRAINT CK_empsched_time CHECK (end_time > start_time)
);
GO
CREATE UNIQUE INDEX UX_empsched_employee_date ON employee_schedules(employee_id, work_date);
GO

/* =========================================================================
   6. GIỜ MỞ CỬA CỐ ĐỊNH (business_hours)
   ========================================================================= */
CREATE TABLE business_hours (
    id              INT IDENTITY(1,1)       NOT NULL,
    day_of_week     TINYINT                 NOT NULL,   -- 0=CN .. 6=Thứ Bảy
    open_time       TIME(0)                 NULL,
    close_time      TIME(0)                 NULL,
    is_closed       BIT                     NOT NULL CONSTRAINT DF_bizhours_closed DEFAULT (0),
    CONSTRAINT PK_business_hours PRIMARY KEY (id),
    CONSTRAINT UQ_bizhours_dow UNIQUE (day_of_week),
    CONSTRAINT CK_bizhours_dow CHECK (day_of_week BETWEEN 0 AND 6)
);
GO

/* =========================================================================
   7. ĐÓNG CỬA ĐỘT XUẤT (business_closures)
   ========================================================================= */
CREATE TABLE business_closures (
    id                  BIGINT IDENTITY(1,1)    NOT NULL,
    start_at            DATETIME2(3)            NOT NULL,
    end_at              DATETIME2(3)            NOT NULL,
    reason              NVARCHAR(500)           NOT NULL,
    version_no          INT                     NOT NULL CONSTRAINT DF_closure_version DEFAULT (1),
    status              VARCHAR(20)             NOT NULL CONSTRAINT DF_closure_status DEFAULT ('ACTIVE'),
    superseded_by_id    BIGINT                  NULL,
    created_by          BIGINT                  NOT NULL,
    created_at          DATETIME2(3)            NOT NULL CONSTRAINT DF_closure_created_at DEFAULT SYSUTCDATETIME(),
    row_version         ROWVERSION,
    CONSTRAINT PK_business_closures PRIMARY KEY (id),
    CONSTRAINT FK_closure_createdby FOREIGN KEY (created_by) REFERENCES users(id),
    CONSTRAINT FK_closure_superseded FOREIGN KEY (superseded_by_id) REFERENCES business_closures(id),
    CONSTRAINT CK_closure_status CHECK (status IN ('ACTIVE', 'AMENDED', 'CANCELLED')),
    CONSTRAINT CK_closure_time CHECK (end_at > start_at)
);
GO

/* =========================================================================
   8. LỊCH HẸN TRUNG TÂM (Gộp appointments + reviews + điều chỉnh D + idempotency)
   ========================================================================= */
CREATE TABLE appointments (
    id                      BIGINT IDENTITY(1,1)    NOT NULL,
    customer_id             BIGINT                  NOT NULL,
    pet_id                  BIGINT                  NOT NULL,
    employee_id             BIGINT                  NULL,
    employee_name_snapshot  NVARCHAR(150)           NULL,
    status                  VARCHAR(20)             NOT NULL,

    -- Thời gian hẹn & giữ chỗ
    start_at                DATETIME2(3)            NOT NULL,
    end_at                  DATETIME2(3)            NOT NULL,
    hold_expires_at         DATETIME2(3)            NULL,
    actual_completed_at     DATETIME2(3)            NULL,

    -- Tài chính chốt D & điều chỉnh gần nhất
    d_amount                DECIMAL(12,2)           NULL,
    d_adjust_reason         NVARCHAR(500)           NULL,
    d_adjusted_by           BIGINT                  NULL,
    d_adjusted_at           DATETIME2(3)            NULL,

    -- Đánh giá của khách hàng (1 lịch hẹn tối đa 1 đánh giá)
    rating                  TINYINT                 NULL,
    review_comment          NVARCHAR(1000)          NULL,
    reviewed_at             DATETIME2(3)            NULL,

    -- Liên kết đặt lại & chống lặp thao tác (idempotency)
    rebooked_from_id        BIGINT                  NULL,
    idempotency_key         VARCHAR(100)            NULL,
    note                    NVARCHAR(500)           NULL,
    created_by              BIGINT                  NOT NULL,
    created_at              DATETIME2(3)            NOT NULL CONSTRAINT DF_appt_created_at DEFAULT SYSUTCDATETIME(),
    row_version             ROWVERSION,

    CONSTRAINT PK_appointments PRIMARY KEY (id),
    CONSTRAINT FK_appt_customer FOREIGN KEY (customer_id) REFERENCES users(id),
    CONSTRAINT FK_appt_pet_customer FOREIGN KEY (pet_id, customer_id) REFERENCES pets(id, customer_id),
    CONSTRAINT FK_appt_employee FOREIGN KEY (employee_id) REFERENCES users(id),
    CONSTRAINT FK_appt_createdby FOREIGN KEY (created_by) REFERENCES users(id),
    CONSTRAINT FK_appt_adjustedby FOREIGN KEY (d_adjusted_by) REFERENCES users(id),
    CONSTRAINT FK_appt_rebooked FOREIGN KEY (rebooked_from_id) REFERENCES appointments(id),

    CONSTRAINT CK_appt_status CHECK (status IN (
        'PENDING','CONFIRMED','CHECKED_IN','IN_PROGRESS','COMPLETED',
        'INTERRUPTED','UNFULFILLED','CANCELLED','REJECTED','EXPIRED'
    )),
    CONSTRAINT CK_appt_time CHECK (end_at > start_at),
    CONSTRAINT CK_appt_damount CHECK (d_amount IS NULL OR d_amount >= 0),
    CONSTRAINT CK_appt_terminal_damount CHECK (
        (status IN ('COMPLETED','INTERRUPTED','UNFULFILLED') AND d_amount IS NOT NULL)
        OR (status NOT IN ('COMPLETED','INTERRUPTED','UNFULFILLED') AND d_amount IS NULL)
    ),
    CONSTRAINT CK_appt_unfulfilled_zero CHECK (status <> 'UNFULFILLED' OR d_amount = 0),
    CONSTRAINT CK_appt_rating CHECK (rating IS NULL OR rating BETWEEN 1 AND 5)
);
GO
CREATE INDEX IX_appt_employee_time ON appointments(employee_id, start_at, end_at) INCLUDE (status);
GO
CREATE INDEX IX_appt_customer_status ON appointments(customer_id, status);
GO
CREATE UNIQUE INDEX UX_appt_idemkey ON appointments(customer_id, idempotency_key) WHERE idempotency_key IS NOT NULL;
GO

/* =========================================================================
   9. CHI TIẾT DỊCH VỤ TRONG LỊCH HẸN (appointment_details)
   ========================================================================= */
CREATE TABLE appointment_details (
    id                      BIGINT IDENTITY(1,1)    NOT NULL,
    appointment_id          BIGINT                  NOT NULL,
    service_id              INT                     NOT NULL,
    service_name            NVARCHAR(150)           NOT NULL,
    unit_price              DECIMAL(12,2)           NOT NULL,
    duration_minutes        INT                     NOT NULL,
    buffer_minutes          INT                     NOT NULL,
    quantity                INT                     NOT NULL CONSTRAINT DF_apptdtl_qty DEFAULT (1),
    subtotal                DECIMAL(12,2)           NOT NULL,
    actual_amount           DECIMAL(12,2)           NULL,
    actual_amount_reason    NVARCHAR(500)           NULL,
    CONSTRAINT PK_appointment_details PRIMARY KEY (id),
    CONSTRAINT FK_apptdtl_appt FOREIGN KEY (appointment_id) REFERENCES appointments(id),
    CONSTRAINT FK_apptdtl_service FOREIGN KEY (service_id) REFERENCES services(id),
    CONSTRAINT CK_apptdtl_qty CHECK (quantity > 0),
    CONSTRAINT CK_apptdtl_subtotal CHECK (subtotal = unit_price * quantity),
    CONSTRAINT CK_apptdtl_actual_cap CHECK (actual_amount IS NULL OR (actual_amount >= 0 AND actual_amount <= subtotal))
);
GO
CREATE INDEX IX_apptdtl_appt ON appointment_details(appointment_id);
GO

/* =========================================================================
   10. PHỤ THU PHÁT SINH (surcharges)
   ========================================================================= */
CREATE TABLE surcharges (
    id                          BIGINT IDENTITY(1,1)    NOT NULL,
    appointment_id              BIGINT                  NOT NULL,
    version_no                  INT                     NOT NULL CONSTRAINT DF_surcharge_version DEFAULT (1),
    content                     NVARCHAR(500)           NOT NULL,
    amount                      DECIMAL(12,2)           NOT NULL,
    reason                      NVARCHAR(500)           NOT NULL,
    status                      VARCHAR(20)             NOT NULL,
    created_by                  BIGINT                  NOT NULL,
    created_at                  DATETIME2(3)            NOT NULL CONSTRAINT DF_surcharge_created_at DEFAULT SYSUTCDATETIME(),

    -- Đồng ý của khách & duyệt của Admin
    customer_consent_method     NVARCHAR(100)           NULL,
    customer_consent_content    NVARCHAR(500)           NULL,
    customer_consent_at         DATETIME2(3)            NULL,
    approved_by                 BIGINT                  NULL,
    approved_at                 DATETIME2(3)            NULL,
    decline_or_cancel_reason    NVARCHAR(500)           NULL,

    -- Số tiền thực thu khi INTERRUPTED & kéo dài thời lượng
    actual_amount               DECIMAL(12,2)           NULL,
    actual_amount_reason        NVARCHAR(500)           NULL,
    extends_duration            BIT                     NOT NULL CONSTRAINT DF_surcharge_extends DEFAULT (0),
    old_end_at_snapshot         DATETIME2(3)            NULL,
    new_end_at_snapshot         DATETIME2(3)            NULL,
    superseded_by_id            BIGINT                  NULL,
    row_version                 ROWVERSION,

    CONSTRAINT PK_surcharges PRIMARY KEY (id),
    CONSTRAINT FK_surcharge_appt FOREIGN KEY (appointment_id) REFERENCES appointments(id),
    CONSTRAINT FK_surcharge_createdby FOREIGN KEY (created_by) REFERENCES users(id),
    CONSTRAINT FK_surcharge_approvedby FOREIGN KEY (approved_by) REFERENCES users(id),
    CONSTRAINT FK_surcharge_superseded FOREIGN KEY (superseded_by_id) REFERENCES surcharges(id),
    CONSTRAINT CK_surcharge_status CHECK (status IN (
        'WAITING_CUSTOMER','WAITING_ADMIN','APPROVED','DECLINED',
        'REJECTED','WITHDRAWN','CANCELLED','CLOSED'
    )),
    CONSTRAINT CK_surcharge_amount CHECK (amount > 0),
    CONSTRAINT CK_surcharge_actual CHECK (actual_amount IS NULL OR (actual_amount >= 0 AND actual_amount <= amount))
);
GO
CREATE INDEX IX_surcharge_appt_status ON surcharges(appointment_id, status);
GO

/* =========================================================================
   11. THANH TOÁN (payments)
   ========================================================================= */
CREATE TABLE payments (
    id                      BIGINT IDENTITY(1,1)    NOT NULL,
    appointment_id          BIGINT                  NOT NULL,
    amount                  DECIMAL(12,2)           NOT NULL,
    method                  VARCHAR(30)             NOT NULL,   -- CASH / CARD / TRANSFER
    status                  VARCHAR(20)             NOT NULL,   -- SUCCESS / VOID
    paid_at                 DATETIME2(3)            NOT NULL CONSTRAINT DF_payments_paid_at DEFAULT SYSUTCDATETIME(),
    recorded_by             BIGINT                  NOT NULL,
    recorded_during_status  VARCHAR(20)             NULL,
    void_reason             NVARCHAR(500)           NULL,
    voided_by               BIGINT                  NULL,
    voided_at               DATETIME2(3)            NULL,
    idempotency_key         VARCHAR(100)            NULL,
    row_version             ROWVERSION,

    CONSTRAINT PK_payments PRIMARY KEY (id),
    CONSTRAINT FK_payments_appt FOREIGN KEY (appointment_id) REFERENCES appointments(id),
    CONSTRAINT FK_payments_recordedby FOREIGN KEY (recorded_by) REFERENCES users(id),
    CONSTRAINT FK_payments_voidedby FOREIGN KEY (voided_by) REFERENCES users(id),
    CONSTRAINT CK_payments_status CHECK (status IN ('SUCCESS', 'VOID')),
    CONSTRAINT CK_payments_amount CHECK (amount > 0),
    CONSTRAINT CK_payments_void CHECK (
        status = 'SUCCESS'
        OR (status = 'VOID' AND voided_by IS NOT NULL AND voided_at IS NOT NULL AND LEN(LTRIM(RTRIM(ISNULL(void_reason, '')))) > 0)
    )
);
GO
CREATE INDEX IX_payments_appt ON payments(appointment_id, status);
GO
CREATE UNIQUE INDEX UX_payments_idemkey ON payments(idempotency_key) WHERE idempotency_key IS NOT NULL;
GO

/* =========================================================================
   12. NHẬT KÝ SỰ KIỆN, SỰ CỐ & THÔNG BÁO (appointment_logs)
   Gộp chung:
   - STATUS_CHANGE   : Đổi trạng thái lịch hẹn (thay appointment_status_logs)
   - RESCHEDULE      : Đổi giờ / đổi nhân viên (thay appointment_reschedules)
   - D_ADJUSTMENT    : Lịch sử điều chỉnh D (thay appointment_adjustments + lines)
   - LEAVE_IMPACT    : Lịch bị ảnh hưởng do NV nghỉ + liên hệ khách (thay employee_leave_*)
   - CLOSURE_IMPACT  : Lịch bị ảnh hưởng do đóng cửa + lô xử lý (thay closure_batch_*)
   - NOTIFICATION    : Hàng đợi gửi thông báo & retry (thay notification_outbox + attempts)
   ========================================================================= */
CREATE TABLE appointment_logs (
    id                  BIGINT IDENTITY(1,1)    NOT NULL,
    appointment_id      BIGINT                  NULL,       -- NULL nếu là thông báo tổng hợp nhiều lịch
    closure_id          BIGINT                  NULL,       -- Gắn với sự kiện đóng cửa (nếu có)
    log_type            VARCHAR(30)             NOT NULL,
    status              VARCHAR(30)             NULL,       -- Trạng thái xử lý sự cố / outbox (QUEUED, SENT, UNRESOLVED...)
    old_value           NVARCHAR(500)           NULL,       -- Trạng thái cũ / giờ cũ / D cũ
    new_value           NVARCHAR(500)           NULL,       -- Trạng thái mới / giờ mới / D mới
    reason              NVARCHAR(500)           NULL,
    payload_json        NVARCHAR(MAX)           NULL,       -- Chi tiết JSON (bằng chứng đồng ý, các lần gọi khách, dòng điều chỉnh...)
    attempt_count       INT                     NOT NULL CONSTRAINT DF_apptlog_attempts DEFAULT (0),
    next_attempt_at     DATETIME2(3)            NULL,
    actor_id            BIGINT                  NULL,       -- Người thực hiện hoặc người nhận
    created_at          DATETIME2(3)            NOT NULL CONSTRAINT DF_apptlog_created_at DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_appointment_logs PRIMARY KEY (id),
    CONSTRAINT FK_apptlog_appt FOREIGN KEY (appointment_id) REFERENCES appointments(id),
    CONSTRAINT FK_apptlog_closure FOREIGN KEY (closure_id) REFERENCES business_closures(id),
    CONSTRAINT FK_apptlog_actor FOREIGN KEY (actor_id) REFERENCES users(id),
    CONSTRAINT CK_apptlog_type CHECK (log_type IN (
        'STATUS_CHANGE', 'RESCHEDULE', 'D_ADJUSTMENT',
        'LEAVE_IMPACT', 'CLOSURE_IMPACT', 'NOTIFICATION'
    ))
);
GO
CREATE INDEX IX_apptlog_appt_type ON appointment_logs(appointment_id, log_type, created_at);
GO
CREATE INDEX IX_apptlog_queue ON appointment_logs(log_type, status, next_attempt_at)
    WHERE status IN ('QUEUED', 'RETRY_WAIT', 'UNRESOLVED', 'PENDING');
GO

/* =========================================================================
   VIEW TÍNH CÔNG NỢ TỰ ĐỘNG (vw_appointment_financials)
   ========================================================================= */
CREATE OR ALTER VIEW vw_appointment_financials AS
SELECT
    a.id                            AS appointment_id,
    a.status                        AS appointment_status,
    a.d_amount                      AS d_amount,
    ISNULL(b.b_amount, 0)           AS b_amount,
    ISNULL(b.service_actual, 0)     AS service_actual_total,
    ISNULL(s.s_amount, 0)           AS s_amount,
    ISNULL(s.surcharge_actual, 0)   AS surcharge_actual_total,
    ISNULL(p.p_amount, 0)           AS p_amount,
    CASE
        WHEN a.d_amount IS NULL THEN 'NOT_FINALIZED'
        WHEN a.d_amount = 0 AND ISNULL(p.p_amount, 0) = 0 THEN 'NO_CHARGE'
        WHEN ISNULL(p.p_amount, 0) > a.d_amount THEN 'OVERPAID'
        WHEN ISNULL(p.p_amount, 0) = 0 THEN 'UNPAID'
        WHEN ISNULL(p.p_amount, 0) < a.d_amount THEN 'PARTIAL'
        ELSE 'PAID'
    END AS debt_label,
    CASE WHEN a.d_amount IS NOT NULL AND a.d_amount > ISNULL(p.p_amount, 0)
         THEN a.d_amount - ISNULL(p.p_amount, 0) ELSE 0 END AS r_amount,
    CASE WHEN a.d_amount IS NOT NULL AND ISNULL(p.p_amount, 0) > a.d_amount
         THEN ISNULL(p.p_amount, 0) - a.d_amount ELSE 0 END AS o_amount
FROM appointments a
LEFT JOIN (
    SELECT appointment_id,
           SUM(subtotal) AS b_amount,
           SUM(ISNULL(actual_amount, subtotal)) AS service_actual
    FROM appointment_details
    GROUP BY appointment_id
) b ON b.appointment_id = a.id
LEFT JOIN (
    SELECT appointment_id,
           SUM(amount) AS s_amount,
           SUM(ISNULL(actual_amount, amount)) AS surcharge_actual
    FROM surcharges
    WHERE status = 'APPROVED'
    GROUP BY appointment_id
) s ON s.appointment_id = a.id
LEFT JOIN (
    SELECT appointment_id, SUM(amount) AS p_amount
    FROM payments
    WHERE status = 'SUCCESS'
    GROUP BY appointment_id
) p ON p.appointment_id = a.id;
GO

/* =========================================================================
   STORED PROCEDURES CHỐNG RACE CONDITION (Đặt lịch & Thanh toán)
   ========================================================================= */
CREATE OR ALTER PROCEDURE dbo.sp_BookAppointment
    @customer_id        BIGINT,
    @pet_id             BIGINT,
    @employee_id        BIGINT,
    @start_at           DATETIME2(3),
    @end_at             DATETIME2(3),
    @created_by         BIGINT,
    @hold_minutes       INT = 15,
    @new_appointment_id BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Khóa theo nhân viên + ngày để chặn cả trường hợp 2 khung giờ lệch đầu nhưng giao nhau
    DECLARE @lockres VARCHAR(200) =
        'empday:' + CAST(@employee_id AS VARCHAR(20)) + ':' + CONVERT(VARCHAR(10), @start_at, 120);
    DECLARE @lockrc INT;
    SET @new_appointment_id = NULL;

    BEGIN TRANSACTION;
    BEGIN TRY
        EXEC @lockrc = sp_getapplock
            @Resource    = @lockres,
            @LockMode    = 'Exclusive',
            @LockOwner   = 'Transaction',
            @LockTimeout = 5000;

        IF @lockrc < 0
        BEGIN
            ROLLBACK TRANSACTION;
            THROW 50001, N'Không thể giữ khóa khung giờ, vui lòng thử lại.', 1;
        END

        IF EXISTS (
            SELECT 1 FROM dbo.appointments
            WHERE employee_id = @employee_id
              AND status IN ('PENDING','CONFIRMED','CHECKED_IN','IN_PROGRESS')
              AND start_at < @end_at AND end_at > @start_at
        )
        BEGIN
            ROLLBACK TRANSACTION;
            THROW 50002, N'Khung giờ này đã được đặt cho nhân viên này.', 1;
        END

        INSERT INTO dbo.appointments
            (customer_id, pet_id, employee_id, status, start_at, end_at, hold_expires_at, created_by)
        VALUES
            (@customer_id, @pet_id, @employee_id, 'PENDING', @start_at, @end_at,
             DATEADD(MINUTE, @hold_minutes, SYSUTCDATETIME()), @created_by);

        SET @new_appointment_id = SCOPE_IDENTITY();
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_RecordPayment
    @appointment_id BIGINT,
    @method         VARCHAR(30),
    @recorded_by    BIGINT,
    @paid_amount    DECIMAL(12,2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @d DECIMAL(12,2), @p DECIMAL(12,2), @r DECIMAL(12,2);
    DECLARE @appt_status VARCHAR(20);
    SET @paid_amount = 0;

    BEGIN TRANSACTION;
    BEGIN TRY
        SELECT @d = d_amount, @appt_status = status
        FROM dbo.appointments WITH (UPDLOCK, HOLDLOCK)
        WHERE id = @appointment_id;

        IF @d IS NULL
        BEGIN
            ROLLBACK TRANSACTION;
            THROW 50003, N'Không tìm thấy lịch hẹn hoặc khoản phải thu D chưa được chốt.', 1;
        END

        SELECT @p = ISNULL(SUM(amount), 0)
        FROM dbo.payments
        WHERE appointment_id = @appointment_id AND status = 'SUCCESS';

        SET @r = @d - @p;
        IF @r <= 0
        BEGIN
            COMMIT TRANSACTION;
            RETURN;
        END

        INSERT INTO dbo.payments
            (appointment_id, amount, method, status, paid_at, recorded_by, recorded_during_status)
        VALUES
            (@appointment_id, @r, @method, 'SUCCESS', SYSUTCDATETIME(), @recorded_by, @appt_status);

        SET @paid_amount = @r;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

/* =========================================================================
   DỮ LIỆU MẪU (SEED DATA) ĐỂ TEST NGAY
   ========================================================================= */
INSERT INTO users (role, full_name, email, phone, password_hash) VALUES
('ADMIN',    N'Quản Trị Viên',     'admin@petcare.vn', '0901000001', 'hashed_pw_123'),
('STAFF',    N'Nguyễn Văn Minh',   'minh@petcare.vn',  '0901000002', 'hashed_pw_123'),
('STAFF',    N'Trần Thị Lan',      'lan@petcare.vn',   '0901000003', 'hashed_pw_123'),
('CUSTOMER', N'Lê Hoàng Nam',      'nam@gmail.com',    '0909111222', 'hashed_pw_123');
GO

INSERT INTO pets (customer_id, name, species, breed, weight_kg, note) VALUES
(4, N'Milo', N'Chó', N'Poodle', 4.5, N'Hiền, hơi sợ máy sấy to');
GO

INSERT INTO services (name, description, base_price, duration_minutes, buffer_minutes) VALUES
(N'Tắm & Vệ sinh cơ bản', N'Tắm khử mùi, sấy khô, vệ sinh tai và cắt móng', 150000, 45, 15),
(N'Cắt tỉa lông tạo kiểu', N'Tắm + cắt tỉa tạo kiểu toàn thân',              300000, 90, 15),
(N'Ủ dưỡng & Trị ve rận', N'Tắm thuốc đặc trị ve rận và dưỡng lông',         220000, 60, 15);
GO

INSERT INTO employee_services (employee_id, service_id) VALUES
(2, 1), (2, 2), (2, 3),
(3, 1), (3, 3);
GO

INSERT INTO business_hours (day_of_week, open_time, close_time, is_closed) VALUES
(0, '08:00', '20:00', 0),
(1, '08:00', '20:00', 0),
(2, '08:00', '20:00', 0),
(3, '08:00', '20:00', 0),
(4, '08:00', '20:00', 0),
(5, '08:00', '20:00', 0),
(6, '08:00', '20:00', 0);
GO
