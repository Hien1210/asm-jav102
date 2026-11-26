-- Disposable fixture only. Never run on PetCare or any other non-QA database.
IF DB_NAME() NOT LIKE N'PetCareOperationsQA[_]%'
    THROW 51200, 'Operations fixture requires a disposable QA database.', 1;

INSERT dbo.Users(full_name,email,phone,password_hash,role,is_active) VALUES
(N'Ops Admin',N'ops-admin@petcare.test',N'0901000001',N'$2a$12$qLe67BZDZTzjw6fvEVfAcOs.05XjpDI2u1iT25JWLQQuZrBLZE2Yi','ADMIN',1),
(N'Ops Staff',N'ops-staff@petcare.test',N'0901000002',N'$2a$12$qLe67BZDZTzjw6fvEVfAcOs.05XjpDI2u1iT25JWLQQuZrBLZE2Yi','STAFF',1),
(N'Ops Customer',N'ops-customer@petcare.test',N'0901000003',N'$2a$12$qLe67BZDZTzjw6fvEVfAcOs.05XjpDI2u1iT25JWLQQuZrBLZE2Yi','CUSTOMER',1);
INSERT dbo.Pets(owner_id,name,species) VALUES(3,N'Ops Miu',N'Mèo'),(3,N'Ops Milo',N'Chó');
INSERT dbo.Services(name,category,duration_minutes,price) VALUES(N'Ops Bath','GROOMING',30,150000),(N'Ops Trim','GROOMING',30,100000);
INSERT dbo.StaffSkills(staff_id,service_id) VALUES(2,1),(2,2);
INSERT dbo.BusinessHours(day_of_week,open_time,close_time,is_closed)
VALUES(0,'08:00','18:00',0),(1,'08:00','18:00',0),(2,'08:00','18:00',0),(3,'08:00','18:00',0),(4,'08:00','18:00',0),(5,'08:00','18:00',0),(6,'08:00','18:00',0);
INSERT dbo.Shifts(staff_id,work_date,start_time,end_time) VALUES(2,'20990601','08:00','18:00');
INSERT dbo.Rooms(room_code,daily_rate,status) VALUES(N'OPS-01',100000,'AVAILABLE');

DECLARE @items dbo.ServiceBookingItems, @aid INT, @pid INT, @original INT, @key UNIQUEIDENTIFIER;
INSERT @items VALUES(1,2,'2099-06-01T09:00:00','2099-06-01T09:30:00'),(2,2,'2099-06-01T10:00:00','2099-06-01T10:30:00');
EXEC dbo.BookServiceAppointment @customer_id=3,@pet_id=1,@items=@items,@appointment_id=@aid OUTPUT;
IF @aid<>1 THROW 51201, 'Fixture must start on an empty database.', 1;
DELETE @items;
INSERT @items VALUES(1,2,'2099-06-01T11:00:00','2099-06-01T11:30:00');
EXEC dbo.BookServiceAppointment @customer_id=3,@pet_id=2,@items=@items,@appointment_id=@aid OUTPUT;
EXEC dbo.BookBoardingAppointment @customer_id=3,@pet_id=2,@room_id=1,@check_in_date='20990602',@check_out_date='20990604',@appointment_id=@aid OUTPUT;

SET @key=NEWID();
EXEC dbo.RecordPayment @appointment_id=1,@amount=200000,@method='CASH',@payment_key=@key,@payment_id=@original OUTPUT;
EXEC dbo.SetPaymentStatus @payment_id=@original,@status='PAID';
SET @key=NEWID();
EXEC dbo.RecordPayment @appointment_id=2,@amount=150000,@method='CASH',@payment_key=@key,@payment_id=@pid OUTPUT;
EXEC dbo.SetPaymentStatus @payment_id=@pid,@status='PAID';
SET @key=NEWID();
EXEC dbo.RecordPayment @appointment_id=1,@amount=50000,@method='CASH',@payment_key=@key,@payment_id=@pid OUTPUT,@payment_type='REFUND',@original_payment_id=@original;
EXEC dbo.SetPaymentStatus @payment_id=@pid,@status='PAID';
-- These two attempts must not enter collected revenue.
SET @key=NEWID();
EXEC dbo.RecordPayment @appointment_id=1,@amount=10000,@method='CASH',@payment_key=@key,@payment_id=@pid OUTPUT;
SET @key=NEWID();
EXEC dbo.RecordPayment @appointment_id=1,@amount=1000,@method='CASH',@payment_key=@key,@payment_id=@pid OUTPUT;
EXEC dbo.SetPaymentStatus @payment_id=@pid,@status='FAILED';
