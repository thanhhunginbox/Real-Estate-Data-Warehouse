create database DW_Apartment

use DW_Apartment

use DBG

create table Dim_Investor (
	investor_id int IDENTITY (1,1) primary key,
	investor_name nvarchar(300)
)

create table Dim_Project (
	project_id int IDENTITY (1,1) primary key,
	project_name nvarchar(300)
)

create table Dim_Direction (
	direction_id int IDENTITY (1,1) primary key,
	direction nvarchar(255)
)

create table Dim_Time (
	date_id int IDENTITY (0,1) primary key,
	D smalldatetime,
	M int,
	Y int
)

create table Dim_Ward (
	ward_id int IDENTITY (1,1) primary key,
	ward_name nvarchar(255),
	district_id int
)

create table Dim_District (
	district_id int IDENTITY (1,1) primary key,
	district_name nvarchar(255)
)

create table Fact_Apartment (
	apartment_id int primary key,
	project_id int,
	investor_id int,
	square_m2 int,
	bedrooms int,
	bathrooms int,
	main_direction_id int,
	balcony_direction_id int,
	ward_id int,
	price int,
	date_id int
)


alter table Dim_Ward add constraint FK_KEY_WARD_TO_DISTRICT FOREIGN KEY (district_id) REFERENCES Dim_district (district_id)

alter table Fact_Apartment add constraint FK_KEY_FACT_TO_DIRECTION FOREIGN KEY (main_direction_id) references Dim_Direction (direction_id)

alter table Fact_Apartment add constraint FK_KEY_FACT_BAL_TO_DIRECTION FOREIGN KEY (balcony_direction_id) references Dim_Direction (direction_id)

alter table Fact_Apartment add constraint FK_KEY_FACT_TO_PROJECT FOREIGN KEY (project_id) references Dim_Project (project_id)

alter table Fact_Apartment add constraint FK_KEY_FACT_TO_INVESTOR FOREIGN KEY (investor_id) references Dim_Investor (investor_id)

alter table Fact_Apartment add constraint FK_KEY_FACT_TO_WARD FOREIGN KEY (ward_id) references Dim_Ward (ward_id)

alter table Fact_Apartment add constraint FK_KEY_FACT_TO_TIME FOREIGN KEY (date_id) references Dim_Time (date_id)

select distinct a.ward, b.district_id
from [DBG].[dbo].[Apartment] a , [DW_Apartment].[dbo].[Dim_District] b
where a.district = b.district_name



select A.apartment_id, A.project_id, A.investor_id, A.square, A.bedrooms, A.bathrooms,
		A.main_direction_id, B.direction_id as balcony_direction_id, A.ward_id, A.price, A.date_id
from (
select	 t1.id as apartment_id, t2.project_id, t3.investor_id, t1.square, t1.bedrooms, t1.bathrooms,
		t4.direction_id as main_direction_id, t5.ward_id, t1.price, t6.date_id, t1.balcony
from [DBG].[dbo].[Apartment] as t1, 
	[DW_Apartment].[dbo].[Dim_Project] as t2,
	[DW_Apartment].[dbo].[Dim_Investor] as t3,
	[DW_Apartment].[dbo].[Dim_Direction] as t4,
	[DW_Apartment].[dbo].[Dim_Ward] as t5,
	[DW_Apartment].[dbo].[Dim_Time] as t6
where t1.project = t2.project_name 
	and t1.investor = t3.investor_name 
	and t1.direction = t4.direction
	and t1.ward = t5.ward_name
	and t1.date_time = t6.D) as A,  [DW_Apartment].[dbo].[Dim_Direction] as B
	where A.balcony = B.direction