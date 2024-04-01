use Olympics;
go

-- How many olympics games have been held?
select count(distinct Games) as num_of_events from athlete_events

-- List down all Olympics games held so far
select distinct year,season,city from athlete_events
order by year

-- Mention the total no of nations who participated in each olympics game?
select games, count(distinct NOC) as num_of_countries
from athlete_events 
group by games
order by games;

-- Which year saw the highest and lowest no of countries participating in olympics
select top 1 
	w1.games_count, 
	w2.games_count 
from
	(select games + '-' +cast(count(distinct NOC) as varchar(12)) as games_count
	from athlete_events
	group by  games) as w1,
	(select games + '-' +cast(count(distinct NOC) as varchar(12)) as games_count
	from athlete_events
	group by  games) as w2
ORDER BY
    w1.games_count, w2.games_count desc;

-- Which nation has participated in all of the olympic games?

with tot_tours 
as( select count(distinct games) as total_games from athlete_events),
countries
as(select games,nr.region as country 
from athlete_events ae join noc_regions nr 
on ae.noc=nr.noc
group by games,nr.region),
participated 
as(select country,count(1) as total_participated_game from countries
group by country)

select p.* from participated p 
join tot_tours tt on tt.total_games = p.total_participated_game
order by 1;

-- Identify the Countries which played in all summer olympics
with total_games
as(select count(distinct games) as total_summer_games from athlete_events
where games like '%Summer'),
countries 
as(select games,nr.region as country from athlete_events ae
join noc_regions nr on nr.NOC = ae.NOC
group by games,nr.region
having ae.games like '%Summer'),
participated
as(select country,count(1) as Total_Participation from countries c
group by country)

select p.* ,tg.total_summer_games from participated p
join total_games tg on tg.total_summer_games = p.Total_Participation 
order by 1;


-- Identify the sport which was played in all summer olympics
with total_games
as(select count(distinct games) as total_summer_games from athlete_events
where games like '%Summer'),
sports 
as(select games,Sport from athlete_events
group by games,sport
having games like '%Summer'),
participated
as(select sport,count(1) as Total from sports s
group by sport)

select p.* ,tg.total_summer_games from participated p
join total_games tg on tg.total_summer_games = p.Total 
order by 1 desc;

-- Which Sports were just played only once in the olympics
with sports as(
select sport from athlete_events
group by sport, games)
select distinct Sport,count(1) as Total_occurrences from sports
group by sport
having count(1) = (select min(cnt) from (select count(*) as cnt from sports group by sport) as subquery)


--  Fetch the total no of sports played in each olympic games
select games,count (distinct sport) as 'Number of Sports' from athlete_events
group by games
order by games asc;


-- Fetch oldest athletes to win a gold medal
select name,age,sex,team,games,city,sport,event,medal from athlete_events
where medal='gold' and age = (select max(age) from athlete_events where medal='gold');


-- Find the Ratio of male and female athletes participated in all olympic games
with counts as (select sex , count(sex) as 'Count' from athlete_events
group by sex)
select cast(cast((select counts.count  from counts where counts.Sex = 'F')as decimal(10,2)) / cast((select counts.Count
from counts where counts.Sex = 'M')as decimal(10,2)) as decimal(10,2)) as 'Female:Male';


-- Fetch the top 5 athletes who have won the most gold medals
select top 10 name,team,count(medal) as total_medal_no from athlete_events
where medal = 'gold'
group by name,team
order by count(medal) desc;

-- Fetch the top 5 athletes who have won the most medals (gold/silver/bronze)
with t1 as 
(select name,team,count(1) as Total_Medals_no from athlete_events
where medal in ('gold','silver','bronze')
group by name,team),
t2 as 
(select * , DENSE_RANK() over(order by Total_medals_no desc)as rnk from t1)
select name,team,total_medals_no from t2
where rnk <= 5
order by Total_Medals_no desc


-- List down total gold, silver and bronze medals won by each country
with t1 as 
(select b.region ,count(Medal) as Gold from athlete_events a
join noc_regions b
on a.NOC= b.NOC
where medal = 'gold'
group by b.region
),
t2 as 
(select b.region ,count(Medal) as Silver from athlete_events a
join noc_regions b
on a.NOC= b.NOC
where medal = 'silver'
group by b.region
),
t3 as 
(select b.region ,count(Medal) as Bronze from athlete_events a
join noc_regions b
on a.NOC= b.NOC
where medal = 'bronze'
group by b.region
)
select t1.*,t2.Silver,t3.Bronze from t1 join t2 
on t1.region=t2.region join t3 
on t1.region = t3.region
order by t1.gold desc;

-- List down total gold, silver and bronze medals won by each country corresponding to each olympic games
with t1 as 
(select a.Games,b.region ,count(Medal) as Gold from athlete_events a
join noc_regions b
on a.NOC= b.NOC
where medal = 'gold'
group by a.Games,b.region
),
t2 as 
(select a.Games,b.region ,count(Medal) as Silver from athlete_events a
join noc_regions b
on a.NOC= b.NOC
where medal = 'silver'
group by a.Games,b.region
),
t3 as 
(select a.Games,b.region ,count(Medal) as Bronze from athlete_events a
join noc_regions b
on a.NOC= b.NOC
where medal = 'bronze'
group by a.Games,b.region
)
select t1.*,t2.Silver,t3.Bronze from t1 join t2 
on t1.Games=t2.Games join t3 
on t1.Games = t3.Games
order by t1.Games;


-- Identify which country won the most gold, most silver and most bronze medals in each olympic games

with temp
as(select substring(games, 1, charindex('-', games) - 1) as games
    	 	, substring(games, charindex('-', games)+2,len(games)) as country
,coalesce(gold,0) as Gold,coalesce(silver,0) as Silver,coalesce(bronze,0) as Bronze
from (select concat(games,' - ',nr.region)as games,Medal,count(1) as Total_medals from athlete_events ae join noc_regions nr
on nr.NOC = ae.NOC
where Medal <> 'NA'
group by games,nr.region,Medal)as subquery
PIVOT (
    SUM(total_medals)
    FOR medal IN ([Bronze], [Gold], [Silver])
) AS pivot_table)
select distinct games,
 concat(first_value(country) over(partition by games order by gold desc)
    			, ' - '
    			, first_value(gold) over(partition by games order by gold desc)) as Max_Gold
				, concat(first_value(country) over(partition by games order by silver desc)
    			, ' - '
    			, first_value(silver) over(partition by games order by silver desc)) as Max_Silver
    			, concat(first_value(country) over(partition by games order by bronze desc)
    			, ' - '
    			, first_value(bronze) over(partition by games order by bronze desc)) as Max_Bronze
from temp
order by games;


-- Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games

WITH temp AS (
    SELECT 
        SUBSTRING(games, 1, CHARINDEX('-', games) - 1) AS games,
        SUBSTRING(games, CHARINDEX('-', games) + 2, LEN(games)) AS country,
        COALESCE(Gold, 0) AS Gold,
        COALESCE(Silver, 0) AS Silver,
        COALESCE(Bronze, 0) AS Bronze
    FROM (
        SELECT 
            CONCAT(games, ' - ', nr.region) AS games,
            Medal,
            COUNT(1) AS Total_medals 
        FROM 
            athlete_events ae 
            JOIN noc_regions nr ON nr.NOC = ae.NOC
        WHERE 
            Medal <> 'NA'
        GROUP BY 
            games, 
            nr.region, 
            Medal
    ) AS subquery
    PIVOT (
        SUM(Total_medals)
        FOR Medal IN ([Bronze], [Gold], [Silver])
    ) AS pivot_table
),
tot_medals AS (
    SELECT 
        games, 
        nr.region AS country, 
        COUNT(1) AS total_medals
    FROM 
        athlete_events ae 
        JOIN noc_regions nr ON nr.noc = ae.noc
    WHERE 
        Medal <> 'NA'
    GROUP BY 
        games, 
        nr.region
)
SELECT 
    distinct t.games,
    CONCAT(FIRST_VALUE(t.country) OVER (PARTITION BY t.games ORDER BY Gold DESC), ' - ', FIRST_VALUE(Gold) OVER (PARTITION BY t.games ORDER BY Gold DESC)) AS Max_Gold,
    CONCAT(FIRST_VALUE(t.country) OVER (PARTITION BY t.games ORDER BY Silver DESC), ' - ', FIRST_VALUE(Silver) OVER (PARTITION BY t.games ORDER BY Silver DESC)) AS Max_Silver,
    CONCAT(FIRST_VALUE(t.country) OVER (PARTITION BY t.games ORDER BY Bronze DESC), ' - ', FIRST_VALUE(Bronze) OVER (PARTITION BY t.games ORDER BY Bronze DESC)) AS Max_Bronze,
	CONCAT(FIRST_VALUE(tm.country) OVER (PARTITION BY tm.games ORDER BY Bronze DESC), ' - ', FIRST_VALUE(tm.total_medals) OVER (PARTITION BY tm.games ORDER BY Bronze DESC)) AS Max_Medals
from temp t
    join tot_medals tm on tm.games = t.games and tm.country = t.country
    order by games;


-- In which Sport/event, Russia has won highest medals
with t1 as
        	(select sport, count(1) as total_medals
        	from athlete_events
        	where medal <> 'NA'
        	and team = 'Russia'
        	group by sport),
        t2 as
        	(select *, rank() over(order by total_medals desc) as rnk
        	from t1)
    select sport, total_medals
    from t2
    where rnk = 1;

-- Break down all olympic games where india won medal for Hockey and how many medals in each olympic games
 
 select team, sport, games, count(1) as total_medals
    from athlete_events
    where medal <> 'NA'
    and team = 'Russia' and sport = 'Athletics'
    group by team, sport, games
    order by total_medals desc;


