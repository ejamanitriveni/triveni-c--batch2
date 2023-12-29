--Triveni Ejamani--
--Car Rental coding challenge--

if exists (select * from sys.databases where name = 'CarRental')
begin
	drop database CarRental;
end;
go
--creation of database
Create database CarRental
use  CarRental

--creation of tables
create table Vehicle (
    vehicleID INT PRIMARY KEY,
    Make VARCHAR(50),
    Model VARCHAR(50),
    Year INT,
    DailyRate DECIMAL(10, 2),
    Status VARCHAR(20),
    PassengerCapacity INT,
    EngineCapacity INT
)

create table Customer (
    customerID INT PRIMARY KEY,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    email VARCHAR(50),
    phoneNumber VARCHAR(20)
)


create table Lease (
    leaseID INT PRIMARY KEY,
    vehicleID INT,
    customerID INT,
    startDate DATE,
    endDate DATE,
    type VARCHAR(20),
    FOREIGN KEY (vehicleID) REFERENCES Vehicle(vehicleID),
    FOREIGN KEY (customerID) REFERENCES Customer(customerID)
);


create table Payment (
    paymentID INT PRIMARY KEY,
    leaseID INT,
    paymentDate DATE,
    amount DECIMAL(10, 2),
    FOREIGN KEY (leaseID) REFERENCES Lease(leaseID)
)


insert into Vehicle (vehicleID, Make, Model, Year, DailyRate, Status, PassengerCapacity, EngineCapacity)
values 
(1, 'Toyota', 'Camry', 2022, 50.00, 1, 4, 1450),
(2, 'Honda', 'Civic', 2023, 45.00, 1, 7, 1500),
(3, 'Ford', 'Focus', 2022, 48.00, 0, 4, 1400),
(4, 'Nissan', 'Altima', 2023, 52.00, 1, 7, 1200),
(5, 'Chevrolet', 'Malibu', 2022, 47.00, 1, 4, 1800),
(6, 'Hyundai', 'Sonata', 2023, 49.00, 0, 7, 1400),
(7, 'BMW', '3 Series', 2023, 60.00, 1, 7, 2499),
(8,'Mercedes','c class',2022,58.00,1,8,2599),
(9,'Audi','A4',2022 ,55.00, 0, 4, 2500),
(10,'Lexus','ES',2023, 54.00, 1, 4, 2500)

insert into Customer values
(1,'John','Doe', 'johndoe@example.com', '555-555-5555'),
(2,'Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
(3, 'Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
(4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
(5, 'David', 'Lee', 'david@example.com', '555-987-6543'),
(6, 'Laura', 'Hall', 'laura@example.com', '555-234-5678'),
(7,'Michael', 'Davis', 'michael@example.com', '555-876-5432'),
(8, 'Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
(9, 'William', 'Taylor', 'william@example.com', '555-321-6547'),
(10, 'Olivia', 'Adams', 'olivia@example.com', '555-765-4321')

 
insert into Lease values
(1, 1, 1, '2023-01-01', '2023-01-05', 'Daily'),
(2, 2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
(3, 3, 3, '2023-03-10', '2023-03-15', 'Daily'),
(4, 4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
(5, 5, 5, '2023-05-05', '2023-05-10', 'Daily'),
(6, 4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
(7, 7, 7, '2023-07-01', '2023-07-10', 'Daily'),
(8, 8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
(9, 3, 3, '2023-09-07', '2023-09-10', 'Daily'),
(10, 10, 10, '2023-10-10', '2023-10-31', 'Monthly')


insert into Payment values 
(1, 1, '2023-01-03', 200.00),
(2, 2, '2023-02-20', 1000.00),
(3, 3, '2023-03-12', 75.00),
(4, 4, '2023-04-25', 900.00),
(5, 5, '2023-05-07', 60.00),
(6,6, '2023-06-18', 1200.00),
(7, 7, '2023-07-03', 40.00),
(8, 8, '2023-08-14', 1100.00),
(9, 9, '2023-09-09', 80.00),
(10, 10, '2023-10-25', 1500.00)

select *from Vehicle
select *from Customer
select *from Lease
select *from Payment

--1.Update the daily rate for a Mercedes car to 68.
update  Vehicle  set DailyRate=68 where Make='Mercedes'

select *from Vehicle


--2. Delete a specific customer and all associated leases and payments.
delete from payment where leaseID in (select leaseID from lease where customerID=4)
delete from lease where customerID=4
delete from Customer where customerID=4

select *from Customer
select *from Lease
select *from Payment



--3. Rename the "paymentDate" column in the Payment table to "transactionDate".

exec sp_rename 'Payment.paymentDate', 'transactionDate' ,'column'
select *from Payment

--4. Find a specific customer by email.
select *from Customer where email='robert@example.com'

--5. Get active leases for a specific customer.

DECLARE @customerID INT
SET @customerID = 3
SELECT * FROM Lease WHERE customerID = @customerID and endDate > GETDATE()
--or--
SELECT * FROM Lease WHERE customerID = 2 and endDate > GETDATE()

--6. Find all payments made by a customer with a specific phone number.
select Customer.*,Payment.* from Payment
join Lease on Payment.LeaseID=Lease.LeaseID
join Customer on Lease.customerID=Customer.customerID
where Customer.phoneNumber='555-432-1098'


--7. Calculate the average daily rate of all available cars.
select avg(DailyRate) as AverageDailyRate from Vehicle where status=1

--8. Find the car with the highest daily rate.
select top 1 make from Vehicle 
order by DailyRate desc
--or--
select make from Vehicle where DailyRate=(select max(DailyRate) from Vehicle)


--9. Retrieve all cars leased by a specific customer
select Vehicle.* from Vehicle
join Lease on Vehicle.vehicleID = Lease.vehicleID
join Customer on Lease.customerID = Customer.customerID
where Customer.customerID = 2


--10. Find the details of the most recent lease.
select top 1 Lease.*, Vehicle.*, Customer.*
from Lease
join Vehicle on Lease.vehicleID = Vehicle.vehicleID
join Customer on Lease.customerID = Customer.customerID
order by Lease.endDate desc
--or---
select top 1 Lease.* from Lease 
order by endDate desc
--or--
select Lease.* from Lease where endDate=(select max(endDate) from Lease )

--11. List all payments made in the year 2023.
select * from Payment where year(transactionDate)='2023'

--12. Retrieve customers who have not made any payments.
	
select Customer.*from Customer
 left  join Lease on Customer.customerID = Lease.customerID
 left  join Payment on Lease.leaseID = Payment.leaseID
where Payment.paymentID is null;


--13. Retrieve Car Details and Their Total Payments.

select Vehicle.*,SUM(Payment.amount) AS totalPayments from Vehicle
left join Lease ON Vehicle.vehicleID = Lease.vehicleID
left join Payment ON Lease.leaseID = Payment.leaseID
group by Vehicle.vehicleID ,Vehicle.make, Vehicle.model, Vehicle.year,
Vehicle.dailyRate, Vehicle.status, Vehicle.passengerCapacity, Vehicle.engineCapacity;



--14. Calculate Total Payments for Each Customer.

select Customer.*, sum(Payment.amount) as TotalPayments from Customer 
left join Lease on Customer.customerID = Lease.customerID
left join Payment on Lease.leaseID = Payment.leaseID
group by Customer.customerID, Customer.firstName, Customer.lastName, Customer.email, Customer.phoneNumber;


--15. List Car Details for Each Lease.

select Lease.*, Vehicle.* from Lease
join Vehicle on Lease.vehicleID= Vehicle.vehicleID

--16. Retrieve Details of Active Leases with Customer and Car Information.
	
select Lease.*,Vehicle .*, Customer.* from Lease 
join Vehicle on Lease.vehicleID = Vehicle.vehicleID
join Customer on Lease.customerID = Customer.customerID
where 
   Lease.endDate >= GETDATE()


--17. Find the Customer Who Has Spent the Most on Leases.
	
select top 1 Customer.customerID,sum(Payment.amount) AS TotalSpentOnLeases from Customer
join Lease on Customer.customerID = Lease.customerID
join Payment on Lease.leaseID = Payment.leaseID
group by Customer.customerID 
order by TotalSpentOnLeases desc

--or--
select C.customerID, SUM(P.amount) [Total Payments] from Customer C
join Lease L on C.customerID = L.customerID
join Payment P on L.leaseID = P.leaseID
group by  C.customerID
having SUM(P.amount) = (
	select top 1 SUM(P.amount) from Customer C
	join Lease L on C.customerID = L.customerID
	join Payment P on L.leaseID = P.leaseID
	group by C.customerID
	order by SUM(P.amount) desc)
	
--18. List All Cars with Their Current Lease Information

select Vehicle.*,Lease.* from Vehicle
left join Lease on Vehicle.vehicleID = Lease.vehicleID
where Lease.endDate >=  GETDATE()




 







