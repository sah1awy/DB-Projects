-- Create Database if not exists
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'sample_data')
CREATE DATABASE [sample_data];
GO

USE [sample_data];
GO

-- Table structure for table `geo`
IF OBJECT_ID(N'dbo.geo', N'U') IS NOT NULL
DROP TABLE dbo.geo;
GO

CREATE TABLE dbo.geo (
  [GeoID] varchar(4) NOT NULL,
  [Geo] nvarchar(MAX),
  [Region] nvarchar(MAX),
  PRIMARY KEY ([GeoID])
);
GO

-- Insert data into `geo` table
INSERT INTO dbo.geo ([GeoID], [Geo], [Region])
VALUES 
('G1', N'India', N'APAC'),
('G2', N'USA', N'Americas'),
('G3', N'Canada', N'Americas'),
('G4', N'New Zealand', N'APAC'),
('G5', N'Australia', N'APAC'),
('G6', N'UK', N'Europe');
GO

-- Table structure for table `people`
IF OBJECT_ID(N'dbo.people', N'U') IS NOT NULL
DROP TABLE dbo.people;
GO

CREATE TABLE dbo.people (
  [Salesperson] nvarchar(MAX),
  [SPID] varchar(6) NOT NULL,
  [Team] nvarchar(MAX),
  [Location] nvarchar(MAX),
  PRIMARY KEY ([SPID])
);
GO

-- Insert data into `people` table
INSERT INTO dbo.people ([Salesperson], [SPID], [Team], [Location])
VALUES 
('Barr Faughny', 'SP01', 'Yummies', 'Hyderabad'),
('Dennison Crosswaite', 'SP02', 'Yummies', 'Hyderabad'),
('Gunar Cockshoot', 'SP03', 'Yummies', 'Hyderabad'),
('Wilone O''Kielt', 'SP04', 'Delish', 'Hyderabad'),
('Gigi Bohling', 'SP05', 'Delish', 'Hyderabad'),
('Curtice Advani', 'SP06', 'Delish', 'Hyderabad'),
('Kaine Padly', 'SP07', 'Delish', 'Hyderabad'),
('Ches Bonnell', 'SP08', '', 'Hyderabad'),
('Andria Kimpton', 'SP09', 'Jucies', 'Hyderabad'),
('Brien Boise', 'SP10', 'Jucies', 'Wellington'),
('Husein Augar', 'SP11', 'Yummies', 'Wellington'),
('Karlen McCaffrey', 'SP12', 'Yummies', 'Wellington'),
('Jan Morforth', 'SP13', 'Delish', 'Wellington'),
('Dotty Strutley', 'SP14', 'Delish', 'Wellington'),
('Kelci Walkden', 'SP15', 'Yummies', 'Wellington'),
('Marney O''Breen', 'SP16', 'Jucies', 'Wellington'),
('Rafaelita Blaksland', 'SP17', '', 'Wellington'),
('Madelene Upcott', 'SP18', 'Jucies', 'Wellington'),
('Beverie Moffet', 'SP19', 'Jucies', 'Seattle'),
('Oby Sorrel', 'SP20', 'Jucies', 'Seattle'),
('Mallorie Waber', 'SP21', '', 'Seattle'),
('Jehu Rudeforth', 'SP22', '', 'Seattle'),
('Van Tuxwell', 'SP23', 'Yummies', 'Seattle'),
('Roddy Speechley', 'SP24', 'Delish', 'Seattle'),
('Camilla Castle', 'SP25', 'Delish', 'Seattle'),
('Janene Hairsine', 'SP26', 'Delish', 'Paris'),
('Niall Selesnick', 'SP27', 'Jucies', 'Paris'),
('Ebonee Roxburgh', 'SP28', '', 'Paris'),
('Zach Polon', 'SP29', 'Yummies', 'Paris'),
('Orton Livick', 'SP30', 'Yummies', 'Paris'),
('Gray Seamon', 'SP31', 'Delish', 'Paris'),
('Benny Karolovsky', 'SP32', 'Jucies', 'Paris'),
('Dyna Doucette', 'SP33', 'Jucies', 'Paris');
GO

-- Table structure for table `products`
IF OBJECT_ID(N'dbo.products', N'U') IS NOT NULL
DROP TABLE dbo.products;
GO

CREATE TABLE dbo.products (
  [PID] varchar(6) NOT NULL,
  [Product] nvarchar(MAX),
  [Category] nvarchar(MAX),
  [Size] nvarchar(MAX),
  [Cost_per_box] decimal(18, 2) DEFAULT NULL,
  PRIMARY KEY ([PID])
);
GO

-- Insert data into `products` table
INSERT INTO dbo.products ([PID], [Product], [Category], [Size], [Cost_per_box])
VALUES 
('P01', N'Milk Bars', N'Bars', N'LARGE', 1.52),
('P02', N'50% Dark Bites', N'Bites', N'LARGE', 2.57),
('P03', N'Almond Choco', N'Bars', N'LARGE', 9.6),
('P04', N'Raspberry Choco', N'Bars', N'LARGE', 4.09),
('P05', N'Mint Chip Choco', N'Bars', N'LARGE', 1.54),
('P06', N'Eclairs', N'Bites', N'LARGE', 2.24),
('P07', N'Drinking Coco', N'Other', N'LARGE', 1.62),
('P08', N'99% Dark & Pure', N'Bars', N'LARGE', 2.47),
('P09', N'Orange Choco', N'Bars', N'LARGE', 7.14),
('P10', N'Spicy Special Slims', N'Bites', N'LARGE', 5.79),
('P11', N'After Nines', N'Bites', N'LARGE', 4.43),
('P12', N'Fruit & Nut Bars', N'Bars', N'LARGE', 1.58),
('P13', N'85% Dark Bars', N'Bars', N'SMALL', 0.64),
('P14', N'White Choc', N'Other', N'SMALL', 0.16),
('P15', N'Baker''s Choco Chips', N'Bars', N'SMALL', 3.4),
('P16', N'Organic Choco Syrup', N'Other', N'SMALL', 1.47),
('P17', N'Caramel Stuffed Bars', N'Bars', N'SMALL', 0.54),
('P18', N'Manuka Honey Choco', N'Other', N'SMALL', 4.75);

CREATE TABLE sales (
    ID int identity(1,1),
	SPID varchar(6) NOT NULL,
    GeoID varchar(4) NOT NULL,
    PID varchar(6) NOT NULL,
    SaleDate datetime DEFAULT NULL,
    Amount int DEFAULT NULL,
    Customers int DEFAULT NULL,
    Boxes int DEFAULT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (SPID) REFERENCES people(SPID),
    FOREIGN KEY (GeoID) REFERENCES geo(GeoID),
    FOREIGN KEY (PID) REFERENCES products(PID)
);

-- Insert multiple values into `sales` table using a single INSERT statement
INSERT INTO sales (SPID, GeoID, PID, SaleDate, Amount, Customers, Boxes)
VALUES 
('SP01', 'G1', 'P01', '2024-01-01', 100, 5, 10),
('SP02', 'G2', 'P02', '2024-01-02', 150, 7, 12),
('SP03', 'G3', 'P03', '2024-01-03', 200, 8, 15),
('SP04', 'G4', 'P04', '2024-01-04', 120, 6, 11),
('SP05', 'G5', 'P05', '2024-01-05', 180, 9, 14),
('SP06', 'G6', 'P06', '2024-01-06', 250, 12, 20),
('SP07', 'G1', 'P07', '2024-01-07', 130, 7, 13),
('SP08', 'G2', 'P08', '2024-01-08', 170, 8, 16),
('SP09', 'G3', 'P09', '2024-01-09', 220, 10, 18),
('SP10', 'G2', 'P10', '2024-01-10', 190, 9, 17),
('SP11', 'G1', 'P11', '2024-01-11', 140, 6, 12),
('SP12', 'G4', 'P12', '2024-01-12', 160, 7, 15),
('SP13', 'G2', 'P13', '2024-01-13', 210, 10, 19),
('SP14', 'G1', 'P14', '2024-01-14', 230, 11, 21),
('SP15', 'G3', 'P15', '2024-01-15', 270, 14, 25),
('SP16', 'G4', 'P16', '2024-01-16', 290, 15, 28),
('SP17', 'G4', 'P17', '2024-01-17', 330, 18, 32),
('SP18', 'G5', 'P18', '2024-01-18', 280, 16, 29),
('SP19', 'G3', 'P02', '2024-01-19', 310, 17, 31),
('SP20', 'G4', 'P04', '2024-01-20', 240, 12, 22),
('SP21', 'G2', 'P03', '2024-01-21', 260, 13, 24),
('SP22', 'G2', 'P16', '2024-01-22', 300, 16, 27),
('SP23', 'G3', 'P16', '2024-01-23', 320, 17, 30),
('SP24', 'G4', 'P12', '2024-01-24', 350, 20, 35),
('SP25', 'G5', 'P13', '2024-01-25', 380, 22, 40),
('SP26', 'G2', 'P16', '2024-01-26', 400, 24, 45),
('SP27', 'G2', 'P11', '2024-01-27', 420, 25, 50),
('SP28', 'G2', 'P12', '2024-01-28', 450, 28, 55),
('SP29', 'G2', 'P11', '2024-01-29', 470, 30, 60),
('SP30', 'G3', 'P04', '2024-01-30', 490, 32, 65),
('SP31', 'G3', 'P06', '2024-01-31', 510, 35, 70),
('SP32', 'G3', 'P08', '2024-02-01', 530, 38, 75),
('SP33', 'G3', 'P09', '2024-02-02', 550, 40, 80),
('SP22', 'G3', 'P09', '2024-02-03', 570, 42, 85),
('SP24', 'G3', 'P05', '2024-02-04', 590, 45, 90),
('SP26', 'G6', 'P06', '2024-02-05', 610, 48, 95),
('SP27', 'G2', 'P07', '2024-02-06', 630, 50, 100),
('SP26', 'G3', 'P08', '2024-02-07', 650, 52, 105),
('SP22', 'G3', 'P09', '2024-02-08', 670, 55, 110),
('SP30', 'G4', 'P04', '2024-02-09', 690, 58, 115),
('SP31', 'G1', 'P01', '2024-02-10', 710, 60, 120),
('SP32', 'G2', 'P02', '2024-02-11', 730, 62, 125),
('SP31', 'G3', 'P04', '2024-02-12', 750, 65, 130),
('SP11', 'G4', 'P04', '2024-02-13', 770, 68, 135),
('SP16', 'G5', 'P11', '2024-02-14', 790, 70, 140),
('SP12', 'G6', 'P12', '2024-02-15', 810, 72, 145),
('SP13', 'G4', 'P16', '2024-02-16', 830, 75, 150),
('SP16', 'G4', 'P14', '2024-02-17', 850, 78, 155),
('SP18', 'G4', 'P16', '2024-02-18', 870, 80, 160),
('SP25', 'G5', 'P15', '2024-02-19', 890, 82, 165);


-- Checking our data
select * from products;
select * from people;
select * from geo;
select * from sales;

-- print details of sales where amounts are > 300 and boxes > 50 
select * from sales
where amount > 300 and Boxes > 50
order by amount desc;

-- How many sales did each of the salespersons have in January 2024
select salesperson, sum(amount) from people p join
sales s on p.SPID = s.SPID
where year(SaleDate) = 2024 and month(SaleDate) = 1
group by salesperson
order by salesperson;



-- Which product sells more boxes Select the Top 3
select top 3 product , sum(boxes) as 'Total Boxes' from products p join sales s
on p.PID = s.PID
group by product
order by [Total Boxes] desc;


-- Which Product sold more boxes in the first 7 days of february 2024
select product , sum(boxes) as 'Total Boxes' from products p join sales s
on p.PID = s.PID
where year(saledate) = 2024 and month(saledate) = 2 and day(saledate) between 1 and 7
group by product
order by [Total Boxes] desc;


--Which sales had under 50 customers & 40 boxes? Did any of them occur in Wednesday?
select *,
case when customers < 50 and boxes < 40 and datepart(WEEKDAY,saledate) = 2 then 'Ok'
else 'Not Ok'
end as 'Result' 
from sales
where customers < 50 and boxes < 40
order by result desc;


