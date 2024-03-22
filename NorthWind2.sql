use Northwind2021;
go


-- Cleaning our data
update Customer
set firstname = 'Martin'
where firstname = 'Mart?n';

update Customer
set lastname = 'Hernandez'
where lastname = 'Hern?ndez';

select distinct ProductName from Product
where ProductName like '%?%'

-- I Can Use Replace with the wild cards also but that's totally fine
update Product
SET ProductName = 'Guaraná Fantástica'
where ProductName = 'Guaran? Fant?stica'


update Product
SET ProductName = (CASE 
                      WHEN ProductName = 'Guaran? Fant?stica' THEN 'Guaraná Fantástica'
                      WHEN ProductName = 'Gumb?r Gummib?rchen' THEN 'Gumbär Gummibärchen'
					  WHEN ProductName = 'Gustaf''s Kn?ckebr?d' THEN 'Gustaf''s Knäckebröd'
					  WHEN ProductName = 'NuNuCa Nu?-Nougat-Creme' THEN 'NuNuCa Nuß-Nougat-Creme'
					  WHEN ProductName = 'Original Frankfurter grüne So?e' THEN 'Original Frankfurter grüne Sore'
					  WHEN ProductName = 'R?d Kaviar' THEN 'Red Kaviar'
					  WHEN ProductName = 'Rh?nbr?u Klosterbier' THEN 'Rhönbräu Klosterbier'
					  WHEN ProductName = 'Gumb?r Gummib?rchen' THEN 'Gumbar Gummibarchen'
                      WHEN ProductName ='Tunnbr?d' THEN 'Tunnbröd'
					  WHEN ProductName = 'Lakkalik??ri' THEN 'Lakkalikööri'
					  WHEN ProductName = 'Wimmers gute Semmelkn?del' THEN 'Wimmers gute Semmelknödel'
                      ELSE ProductName
                      END)

-- select Customers fullnames and the number of orders they made
select firstname + ' ' + lastname as FullName,count(o.OrderNumber) as Number_of_orders from Customer c join 
orders o on c.Id = o.CustomerId
group by firstname + ' ' + lastname
order by Number_of_orders


-- select Customers first name with their corresponding orders (product name, order id)
select firstname  as Name, o.Id as ID, p.productName from Customer c join 
orders o on c.Id = o.CustomerId join OrderItem oi 
on oi.OrderId = o.Id join Product p 
on P.Id = oi.ProductId
order by FirstName;

-- Customer and all the money he paid 
select firstname + ' ' + lastname as FullName, sum(o.TotalAmount) from Customer c join 
orders o on c.Id = o.CustomerId
group by firstname + ' ' + lastname

