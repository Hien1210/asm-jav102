CREATE OR ALTER PROCEDURE dbo.ConfirmCounterCash
    @payment_id INT,
    @actor_id INT,
    @appointment_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        EXEC dbo.AcquirePetCareLock;

        IF NOT EXISTS (
            SELECT 1 FROM dbo.Users WITH (UPDLOCK, HOLDLOCK)
            WHERE user_id = @actor_id AND is_active = 1 AND role IN ('STAFF', 'ADMIN')
        )
            THROW 51042, 'Invalid cashier.', 1;

        IF NOT EXISTS (
            SELECT 1 FROM dbo.Payments p
            JOIN dbo.Appointments a ON a.appointment_id = p.appointment_id
            WHERE p.payment_id = @payment_id AND p.appointment_id = @appointment_id AND p.method = 'CASH'
              AND p.payment_type = 'CHARGE' AND p.status IN ('PENDING', 'PAID')
              AND a.status NOT IN ('DRAFT', 'CANCELLED', 'NO_SHOW')
        )
            THROW 51042, 'Cash payment is no longer payable.', 1;

        EXEC dbo.SetPaymentStatus @payment_id = @payment_id, @status = 'PAID';
        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH;
END;
GO

IF DATABASE_PRINCIPAL_ID(N'petcare_payment_app') IS NOT NULL
    GRANT EXECUTE ON dbo.ConfirmCounterCash TO petcare_payment_app;
IF DATABASE_PRINCIPAL_ID(N'petcare_backend') IS NOT NULL
    GRANT EXECUTE ON dbo.ConfirmCounterCash TO petcare_backend;
GO
