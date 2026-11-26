IF DB_NAME() NOT LIKE N'PetCareStaffQA[_]%'
    THROW 51210, 'Staff UI fixture requires a disposable QA database.', 1;
INSERT dbo.Users(full_name,email,phone,password_hash,role,is_active) VALUES
(N'QA Admin',N'staff-qa-admin@petcare.test',N'0901770201',N'$2a$12$qLe67BZDZTzjw6fvEVfAcOs.05XjpDI2u1iT25JWLQQuZrBLZE2Yi','ADMIN',1),
(N'QA Nhân viên có tên khá dài để kiểm tra giao diện',N'staff-qa@petcare.test',N'0901770202',N'$2a$12$qLe67BZDZTzjw6fvEVfAcOs.05XjpDI2u1iT25JWLQQuZrBLZE2Yi','STAFF',1),
(N'QA Khách " & <b>Thử</b>',N'staff-qa-customer@petcare.test',N'0901770203',N'$2a$12$qLe67BZDZTzjw6fvEVfAcOs.05XjpDI2u1iT25JWLQQuZrBLZE2Yi','CUSTOMER',1),
(N'QA Nhân viên chưa được xếp ca',N'staff-empty@petcare.test',N'0901770204',N'$2a$12$qLe67BZDZTzjw6fvEVfAcOs.05XjpDI2u1iT25JWLQQuZrBLZE2Yi','STAFF',1);
INSERT dbo.Pets(owner_id,name,species) VALUES(3,N'QA Bông & Miu',N'Mèo'),(3,N'QA Lucky',N'Chó');
INSERT dbo.Services(name,category,duration_minutes,price) VALUES
(N'Tắm sấy & chăm sóc bộ lông thảo mộc','GROOMING',30,150000),
(N'Cắt tỉa tạo kiểu theo yêu cầu','GROOMING',30,100000);
INSERT dbo.StaffSkills(staff_id,service_id) VALUES(2,1),(2,2);
INSERT dbo.BusinessHours(day_of_week,open_time,close_time,is_closed)
VALUES(0,'08:00','18:00',0),(1,'08:00','18:00',0),(2,'08:00','18:00',0),(3,'08:00','18:00',0),(4,'08:00','18:00',0),(5,'08:00','18:00',0),(6,'08:00','18:00',0);
DECLARE @day DATE=CONVERT(DATE,DATEADD(DAY,1,SYSDATETIME())),@aid INT,@items dbo.ServiceBookingItems;
INSERT dbo.Shifts(staff_id,work_date,start_time,end_time) VALUES(2,@day,'08:00','18:00');
INSERT @items VALUES(1,2,DATEADD(HOUR,9,CAST(@day AS DATETIME2)),DATEADD(MINUTE,570,CAST(@day AS DATETIME2)));
EXEC dbo.BookServiceAppointment @customer_id=3,@pet_id=1,@items=@items,@appointment_id=@aid OUTPUT;
EXEC dbo.SetAppointmentStatus @appointment_id=@aid,@status='CONFIRMED';
DELETE @items;
INSERT @items VALUES
(1,2,DATEADD(HOUR,11,CAST(@day AS DATETIME2)),DATEADD(MINUTE,690,CAST(@day AS DATETIME2))),
(2,2,DATEADD(HOUR,12,CAST(@day AS DATETIME2)),DATEADD(MINUTE,750,CAST(@day AS DATETIME2)));
EXEC dbo.BookServiceAppointment @customer_id=3,@pet_id=2,@items=@items,@appointment_id=@aid OUTPUT;
EXEC dbo.SetAppointmentStatus @appointment_id=@aid,@status='CONFIRMED';
EXEC dbo.SetAppointmentStatus @appointment_id=@aid,@status='CHECKED_IN';
