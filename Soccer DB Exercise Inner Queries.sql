-- Exercise 1


select match_no, country_name
from Soccer_Country sc
join match_details md on sc.country_id = md.team_id
where md.match_no='1';


-- Exercise 2

select country_name as Winner
from Soccer_Country sc
join match_details md on sc.country_id = md.team_id
where play_stage ='F' 
and win_lose ='W';


--alter

SELECT country_name as Team 
FROM soccer_country 
WHERE country_id in (
SELECT team_id 
FROM match_details 
WHERE play_stage='F' and win_lose='W');

-- Exercise 3

select match_no, play_stage, goal_score, audence
from match_mast
where audence =(
select max(audence) 
from match_mast);


-- Exercise 4

select match_no
from match_details
where team_id in (
select country_id
from Soccer_Country
where country_name in ('Poland','Germany'))
group by match_no
having count(match_no)=2;

-- Exercise 5

select mm.match_no, mm.play_stage, mm.play_date, results, mm.goal_score
from match_mast mm
where mm.match_no 
in(
select match_no 
from match_details md
where md.team_id in(
select country_id
from Soccer_Country sc
where sc.country_name ='Portugal' or sc.country_name ='Hungary')
group by match_no
having count(distinct team_id)=2)


-- Exercise 6

select match_no, country_name, player_name, count(match_no) as Goals_scored
from goal_details gd, player_mast pm, Soccer_Country sc
where gd.player_id=pm.player_id
and gd.team_id=sc.country_id
group by match_no, country_name, player_name

-- Exercise 7

select a.country_name, max(c.audence)
from soccer_country a , goal_details b , match_mast c
where a.country_id=b.team_id 
and b.match_no=c.match_no and c.audence=
(select max(c.audence) 
from match_mast c)
group by a.country_name

SELECT a.country_name, MAX(c.audence)
FROM soccer_country a, goal_details b, match_mast c
WHERE a.country_id=b.team_id AND b.match_no=c.match_no
AND c.audence=
(SELECT MAX(c.audence)
FROM match_mast c)
GROUP BY a.country_name


-- Exercise 8

select player_name from player_mast where 
player_id in( select player_id from goal_details where
goal_time in(select max(goal_time) from goal_details where
match_no in(select match_no from goal_details where
team_id in(select country_id from Soccer_Country where
country_name in ('Portugal', 'Hungary')) 
group by match_no having count(distinct team_id)=2))
and team_id=(select country_id from Soccer_Country
where country_name ='Portugal'))

-- Exercise 9


select match_no, stop2_sec
from match_mast
order by  stop2_sec desc
offset 1 row
fetch next 1 row only

SELECT MAX(stop2_sec) AS "2nd highest stoppage in 2nd half"
FROM match_mast
WHERE stop2_sec < (SELECT MAX(stop2_sec) FROM match_mast)

-- Exercise 10

select a.match_no, c.country_name, a.stop2_sec
from match_mast a, match_details b, Soccer_Country c
where  a.match_no=b.match_no and b.team_id=c.country_id
order by  stop2_sec desc
offset 2 row
fetch next 2 row only

SELECT country_name FROM soccer_country 
WHERE country_id IN(SELECT team_id FROM match_details 
WHERE match_no IN(SELECT match_no FROM match_mast 
WHERE stop2_sec=(SELECT max(stop2_sec) FROM match_mast
WHERE stop2_sec<>(SELECT max(stop2_sec) FROM match_mast))));


-- Exercise 11

select match_no, play_date, stop2_sec
from match_mast
order by  stop2_sec desc
offset 1 row
fetch next 1 row only;

SELECT match_no,play_date,stop2_sec
FROM match_mast a
WHERE (2-1) = (
SELECT COUNT(DISTINCT(b.stop2_sec))
FROM match_mast b
WHERE b.stop2_sec > a.stop2_sec);

-- Exercise 12

select country_name 
from soccer_country a, match_details b
where  a.country_id=b.team_id and b.play_stage='F' and b.win_lose='L';

SELECT country_name
FROM soccer_country
WHERE country_id = (SELECT team_id FROM match_details WHERE play_stage = 'F' AND win_lose = 'L')

-- Exercise 13

select playing_club, count(playing_club)
from player_mast
group by playing_club
having count(playing_club)=(
select max(MyCount)
from ( select playing_club, count(playing_club) MyCount
from player_mast
group by playing_club) pm)


select playing_club,count(player_id) as total from player_mast
group By playing_club
order By total desc
offset 0 rows
fetch First 2 rows only

-- Exercise 14

select top 1 b.match_no, a.player_name, a.jersey_no
from player_mast a, goal_details b
where a.player_id=b.player_id and b.goal_type ='P'

SELECT player_name, jersey_no
FROM player_mast
WHERE player_id = (SELECT player_id FROM goal_details WHERE goal_type = 'P' AND match_no = (SELECT MIN(match_no) FROM goal_details WHERE goal_type = 'P'))

-- Exercise 15

select top 1 b.match_no, a.player_name, a.jersey_no, c.country_name
from player_mast a, goal_details b, Soccer_Country c
where a.player_id=b.player_id and b.team_id=c.country_id and b.goal_type ='P'

SELECT a.player_name,a.jersey_no,d.country_name
FROM player_mast a, goal_details b, goal_details c, soccer_country d
WHERE a.player_id=b.player_id AND a.team_id=d.country_id AND 
a.player_id=(
SELECT b.player_id 
FROM goal_details b
WHERE b.goal_type='P' AND b.match_no=(
SELECT MIN(c.match_no) 
FROM goal_details c
WHERE c.goal_type='P' AND c.play_stage='G'))
GROUP BY player_name,jersey_no,country_name;

select distinct pm.player_name, sc.country_name, pm.jersey_no 
from player_mast pm join goal_details gd 
on pm.player_id=gd.player_id join soccer_country sc 
on sc.country_id=gd.team_id 
where pm.player_id in (select player_id from goal_details 
where match_no in (select min(match_no) from goal_details 
where goal_type='P')and goal_type='P')

-- Exercise 16

select player_name
from player_mast pm, penalty_gk pk, Soccer_Country sc
where pm.team_id=pk.team_id
and sc.country_id=pk.team_id
and player_id = (select player_gk from penalty_gk pk, Soccer_Country sc where country_name ='Italy' and pk.team_id=sc.country_id)

select player_name
from player_mast pm , penalty_gk pk , soccer_country sc
where pm.team_id = pk.team_id
and sc.country_id = pm.team_id
and sc.country_id = pk.team_id
and country_name = 'italy'
and posi_to_play = 'gk'
and player_id = (select player_gk from penalty_gk pk, soccer_country sc
where country_name = 'italy' and pk.team_id = sc.country_id)


-- Exercise 17

select b.country_name, count(goal_id) as Total_goals
from goal_details a, Soccer_Country b
where a.team_id=b.country_id and country_name ='Germany'
group by country_name;

SELECT COUNT(goal_id)
FROM goal_details
WHERE team_id = (SELECT country_id FROM soccer_country WHERE country_name = 'Germany')

-- Exercise 18

select player_name, jersey_no, playing_club
from player_mast pm, Soccer_Country sc
where pm.team_id=sc.country_id
and sc.country_name ='England'
and posi_to_play ='GK';

SELECT player_name, jersey_no, playing_club 
FROM player_mast 
WHERE posi_to_play='GK' AND team_id=(
SELECT country_id 
FROM soccer_country
WHERE country_name='England');

-- Exercise 19

select player_name, jersey_no, posi_to_play, playing_club
from player_mast pm, Soccer_Country sc
where pm.team_id=sc.country_id
and sc.country_name ='England'
and playing_club ='Liverpool';


-- Exercise 20

select player_name, posi_to_play, age, playing_club, goal_time
from player_mast pm, goal_details gd, Soccer_Country sc
where pm.player_id=gd.player_id
and gd.team_id=sc.country_id
and gd.goal_time =(select max(goal_time) from goal_details
where match_no ='50')


-- Exercise 21

select player_name
from player_mast a, match_captain b, match_details c
where a.player_id=b.player_captain
and b.team_id=c.team_id
and c.play_stage='F' and c.win_lose ='W'
group by a.player_name;

SELECT player_name
FROM player_mast
WHERE player_id in (SELECT player_captain FROM match_captain
WHERE team_id in (SELECT team_id FROM match_details WHERE play_stage = 'F' AND win_lose = 'W'))



-- Exercise 22

select count(*) + 11 as Total_Players
from player_in_out
where match_no =(select		match_no from match_mast
where play_stage ='F')
and in_out ='I'
and team_id =(select country_id from Soccer_Country where country_name ='France');

-- Exercise 23

select player_name, jersey_no
from player_mast
where player_id in(
select player_gk 
from match_details 
where play_stage='G' and team_id in(
select country_id 
from Soccer_Country 
where country_name ='Germany')) 



SELECT player_name,jersey_no 
FROM player_mast 
WHERE player_id IN(
SELECT player_gk 
FROM match_details 
WHERE  play_stage='G' and team_id IN(
SELECT country_id 
FROM soccer_country 
WHERE country_name='Germany'));


-- Exercise 24

select country_name
from Soccer_Country
where country_id in(
select team_id 
from match_details 
where play_stage='F' and win_lose='L')

SELECT country_name 
FROM soccer_country 
WHERE country_id=(
SELECT team_id 
FROM match_details 
WHERE play_stage='F' AND win_lose='L')
AND team_id<>(
SELECT country_id 
FROM soccer_country 
WHERE country_name='Portugal'));

-- Exercise 25

SELECT sc.country_name, COUNT(ps.kick_id)
FROM soccer_country AS sc
JOIN penalty_shootout AS ps
ON sc.country_id = ps.team_id
GROUP BY sc.country_name
HAVING COUNT(ps.kick_id) = (SELECT MAX(x.shots) FROM (SELECT COUNT(*) AS shots FROM penalty_shootout GROUP BY team_id) AS x)

SELECT a.country_name, COUNT(b.score_goal) as shots 
FROM soccer_country a, penalty_shootout b
WHERE b.team_id=a.country_id
GROUP BY a.country_name
having COUNT(b.score_goal)=(
SELECT MAX(shots) FROM (
SELECT COUNT(score_goal) shots 
FROM penalty_shootout
GROUP BY team_id) inner_result);

-- Exercise 26

select a.player_name, count(b.score_goal) as shots
from player_mast a, penalty_shootout b
where a.player_id=b.player_id 
group by player_name
having count (b.score_goal)=(
select max(shots) from (
select count(score_goal) as shots
from penalty_shootout
group by player_id) inner_result);



SELECT c.country_name,a.player_name, a.jersey_no,COUNT(b.score_goal) shots 
FROM player_mast a, penalty_shootout b, soccer_country c
WHERE b.player_id=a.player_id
AND b.team_id=c.country_id
GROUP BY c.country_name,a.player_name,a.jersey_no
HAVING COUNT(b.score_goal)=(
SELECT MAX(shots) FROM (
SELECT COUNT(score_goal) shots 
FROM penalty_shootout
GROUP BY player_id) inner_result);


-- Exercise 27

select match_no, count(score_goal) penalties
from penalty_shootout
group by match_no
having count(score_goal)=
(select Max(penalties) 
from 
(select Count(score_goal) penalties
from penalty_shootout
group by match_no) inner_result);


-- Exercise 28

select a.match_no, b.country_name
from penalty_shootout a,
soccer_country b
where b.country_id=a.team_id 
and match_no =(
	select match_no
	from penalty_shootout
	group by match_no
	having count(*)=
		(select Max(shots) 
		from 
		(select count(*) shots
		from penalty_shootout
		group by match_no) inner_result))
group by a.match_no, b.country_name;




-- Exercise 29

select	a.match_no, 
		b.player_name,
		a.kick_no
from	player_mast b,
		penalty_shootout a
where  a.player_id=b.player_id
	and a.kick_no=7
	and a.match_no=
		(select match_no
		from penalty_shootout 
		where team_id=
			(select country_id 
			from Soccer_Country
			where country_name='Portugal')
		group by match_no)
group by 
match_no,player_name,
kick_no



SELECT a.player_id, b.player_name
FROM penalty_shootout a, player_mast b
WHERE a.player_id=b.player_id and kick_no = 7 AND a.team_id IN(SELECT country_id
FROM soccer_country
WHERE country_name IN('Portugal','Poland'))

-- Exercise 30

select  a.match_no, a.play_stage
from match_mast a, penalty_shootout b
where a.match_no=b.match_no
and b.kick_id=27;

SELECT match_no,
       play_stage
FROM match_mast
WHERE match_no=
    (SELECT match_no
     FROM penalty_shootout
     WHERE kick_id=23);


-- Exercise 31

select venue_name
from soccer_venue
where venue_id in(
	select venue_id 
	from match_mast
	where match_no 
	in(select distinct match_no 
	from penalty_shootout
	))
	

	SELECT venue_name
FROM soccer_venue
WHERE venue_id IN
    (SELECT venue_id
     FROM match_mast
     WHERE match_no IN
         (SELECT DISTINCT match_no
          FROM penalty_shootout));

-- Exercise 32

select play_date
from match_mast
where match_no in(
	select match_no
	from penalty_shootout);

-- Exercise 33

select goal_time as Fastest_goal_time_over_5_min
from goal_details
where goal_time >5
order by goal_time asc
offset 0 row
fetch next 1 row only;














