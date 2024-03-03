-- Creating our Data Base
create database EmployeeManagement
on(
name = Management_data,
filename = 'C:\\Program Files\\Microsoft SQL Server\\MSSQL16.MSSQLSERVER\\MSSQL\\DATA\\ManagementData.mdf',
size = 10,
maxsize = 100,
filegrowth = 40)
log on(
name = Management_log,
filename = 'C:\\Program Files\\Microsoft SQL Server\\MSSQL16.MSSQLSERVER\\MSSQL\\DATA\\ManagementData.log',
size = 10,
maxsize = 60,
filegrowth = 10)
go

use EmployeeManagement
go

-- Creating our Tables
create table Departments
(
DepartmentId int identity(1,1),
DepartmentName nvarchar(30) not null,
constraint dep_pk primary key (DepartmentId)
)
create table Cities
(
CityId int identity(1,1),
CityName nvarchar(30) not null,
constraint city_pk primary key (CityId)
)
create table Nationality(
NationalityID int identity(1,1),
NationalityName nvarchar(30) not null
constraint nat_pk primary key(NationalityId)
)
create table Jobs
(
JobId int identity(1,1),
JobName nvarchar(30) not null,
constraint job_pk primary key (JobId)
)
create table Employees
(
EmployeeId int identity(1,1),
EmployeeName nvarchar(30) not null,
HiringDate datetime,
salary numeric(7,2),
DepartmentId int,
JobId int,
NationalityId int,
DateofBirth datetime,
WorkSide nvarchar(30),
ssn int not null,
CityId int,
constraint dep_fk foreign key (DepartmentId)
references Departments (DepartmentId),
constraint job_fk foreign key (JobId)
references Jobs (JobId),
constraint city_fk foreign key(CityId)
references Cities (CityId),
constraint nat_fk foreign key(NationalityId)
references Nationality (NationalityId)
);

insert into Cities(CityName)
values
	('London'),
	('Paris'),
	('Milano');

insert into Departments(DepartmentName)
values
	('Marketing'),
	('Promoting'),
	('Accounting');

insert into Jobs(JobName)
values
	('Data Analyst'),
	('Data Scientist'),
	('Software Engineer');

insert into Nationality(NationalityName)
values
	('English'),
	('French'),
	('Italian');

insert into Employees(EmployeeName,DepartmentId,JobId,NationalityId,ssn,CityId)
values
	('ahmed',2,1,1,12565,1),
	('Mark',1,2,1,21611,2),
	('Johan',3,3,1,1515,2);


select EmployeeName,DepartmentId,JobId,NationalityId,ssn,CityId from Employees
where CityId = 2;