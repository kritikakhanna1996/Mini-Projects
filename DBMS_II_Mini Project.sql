# DBMS II - MINI PROJECT 

# Tasks to be performed:

CREATE SCHEMA IF NOT EXISTS ICC_Test_Cricket;

# 1.Import the csv file to a table in the database.

use icc_test_cricket;
select * from `icc test batting figures`;


# 2.Remove the column 'Player Profile' from the table.

alter table `icc test batting figures` drop column `Player Profile`;
select * from `icc test batting figures`;


# 3.Extract the country name and player names from the given data and store it in seperate columns for further usage.

create table icc_tbf_1 as
select *,substring_index(player,'(',1) as Player_Name,
if(replace(substring_index(player,'(',-1),')','') like '%/%', substring_index(replace(substring_index(player,'(',-1),')',''),'/',-1),
replace(substring_index(player,'(',-1),')','') ) as Country_Name 
from `icc test batting figures` ;

select * from icc_tbf_1 ;


# 4.From the column 'Span' extract the start_year and end_year and store them in seperate columns for further usage.

create table icc_tbf_2 as
select *, substring(span,1,4) Start_Year, substring(span,6,9) End_Year from icc_tbf_1 ;

select * from icc_tbf_2;


# 5. The column 'HS' has the highest score scored by the player so far in any given match. 
# The column also has details if the player had completed the match in a NOT OUT status. 
# Extract the data and store the highest runs and the NOT OUT status in different columns.

create table icc_tbf_3 as
select *,substring_index(HS,'*',1) as Highest_Score, if(HS like '%*','Not Out','Out') as Not_Out_Status
from icc_tbf_2;

select * from icc_tbf_3;


# 6. Using the data given, considering the players who were active in the year of 2019, 
# create a set of batting order of best 6 players using the selection criteria of those 
# who have a good average score across all matches for India.

select row_number() over() Batting_Order, Player_Name, Country_Name, Avg,Start_Year,End_Year
from icc_tbf_3
where (Start_Year<='2019' and End_Year>='2019') and Country_Name='India'
order by avg desc
limit 6;


# 7. Using the data given, considering the players who were active in the year of 2019, 
# create a set of batting order of best 6 players using the selection criteria of those 
# who have highest number of 100s across all matches for India.

select row_number() over() Batting_Order, Player_Name, Country_Name,`100`,Start_Year,End_Year
from icc_tbf_3
where (Start_Year<='2019' and End_Year>='2019') and Country_Name='India'
order by `100` desc
limit 6; 


# 8. Using the data given, considering the players who were active in the year of 2019, 
# create a set of batting order of best 6 players using 2 selection criterias of your own for India.

select row_number() over() Batting_Order,Player_Name,Country_Name,Start_Year,End_Year,`100`,`50`
from icc_tbf_3
where (Start_Year<='2019' and End_Year>='2019') and (Country_Name='India') and `50`>10
order by `100` desc
limit 6; 


# 9.Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given, 
# considering the players who were active in the year of 2019, create a set of batting order 
# of best 6 players using the selection criteria of those who have a good average score across all matches for South Africa.

create or replace view Batting_Order_GoodAvgScorers_SA as
select *
from icc_tbf_3
where (Start_Year<='2019' and End_Year>='2019') and (Country_Name='SA')
order by Avg desc
limit 6; 

select row_number() over() as Batting_Order,
Player_Name,Country_Name,Start_Year,End_Year,Avg 
from Batting_Order_GoodAvgScorers_SA;


# 10.Create a View named ‘Batting_Order_HighestCenturyScorers_SA’ Using the data given, 
# considering the players who were active in the year of 2019, create a set of batting order 
# of best 6 players using the selection criteria of those who have highest number of 100s across all matches for South Africa.

create or replace view Batting_Order_HighestCenturyScorers_SA as
select *
from icc_tbf_3
where (Start_Year<='2019' and End_Year>='2019') and (Country_Name='SA')
order by `100` desc
limit 6;

select row_number() over() as Batting_Order,
Player_Name,Country_Name,Start_Year,End_Year,`100`
from Batting_Order_HighestCenturyScorers_SA;