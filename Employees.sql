use EmployeeManagement;
go

-- selecting all records from Employees table
select * from Employees

-- selecting all employees Named Ahmed with all info about them  

select e.EmployeeName as Name, e.ssn as SNN, c.CityName as City, n.NationalityName as Nationality from Employees e
join Nationality n on e.NationalityId = n.NationalityID join Cities c on c.CityId = e.CityId
where e.EmployeeName = 'ahmed'

-- Calculating the Number of the Employees on our Company

select count(distinct EmployeeId) as 
"Employees Count" from Employees

-- selecting all employees from London

select e.EmployeeName, c.cityName from 
Employees e join Cities c on c.CityId = e.CityId
where c.CityName = 'London'
order by e.EmployeeName;

-- Getting all info about our Employees

select e.EmployeeName as Name, d.DepartmentName as Department, j.JobName, n.NationalityName as Nationality, c.CityName as City,e.salary
from Employees e join Departments d on e.DepartmentId = d.DepartmentId
join Jobs j on j.JobId = e.JobId join 
Nationality n on n.NationalityID = e.NationalityId join
Cities c on c.CityId = e.CityId 
order by e.salary Desc;

update Employees
set salary = 10000
where EmployeeName = 'ahmed'

update Employees
set salary = 15000
where EmployeeName = 'Mark'

update Employees
set salary = 50000
where EmployeeName = 'Johan'

-- renaming a column

exec sp_rename 'Employees.WorkSide', 'WorkSite','Column'

-- Updating WorkSite
update Employees
set WorkSite = (case when EmployeeName = 'Ahmed' then 'Oslo'
					 when EmployeeName = 'Mark' then 'Rome'
					 when EmployeeName = 'Johan' then 'Cairo'
					 end)
where salary > 5000

select EmployeeName, avg(salary) as AVG_Salary, WorkSite from employees
group by WorkSite,EmployeeName

-- Avg Salary by City 
select c.CityName, Avg(e.salary) as "Salary" from Employees e
join Cities c on c.CityId = e.CityId 
group by c.CityName
order by Avg(e.salary) desc

-- selecting top 3 from employees 
select top 3 * from employees  