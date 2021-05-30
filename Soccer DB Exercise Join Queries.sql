
-- Exercise 1

select venue_name, city
from soccer_venue a
join Soccer_city b on a.city_id=b.city_id
join match_mast c on c.venue_id=a.venue_id
where c.play_stage='F';


-- Exercise 2

select match_no, goal_score, country_name
from match_details a
join Soccer_Country b 
on a.team_id=b.country_id
and a.decided_by ='N';

-- Exercise 3

select player_name, Count(goal_id) as Total_goals, country_name
from goal_details a
join player_mast b 
on a.player_id=b.player_id
join soccer_country c 
on b.team_id=c.country_id
and a.goal_schedule ='NT'
group by player_name, country_name
order by count(goal_id) desc;


-- Exercise 4

select top 1 player_name, Count(goal_id) as Total_goals, country_name
from goal_details a
join player_mast b 
on a.player_id=b.player_id
join soccer_country c 
on b.team_id=c.country_id
group by player_name, country_name
order by count(goal_id) desc;

select player_name, country_name, count(goal_id) 
from player_mast pm 
join goal_details gd 
on pm.player_id=gd.player_id 
join soccer_country sc 
on sc.country_id=gd.team_id 
group by player_name, country_name 
having count(goal_id) 
in ( select max(go) 
		from ( select count (goal_id)go from goal_details group by player_id)b);


-- Exercise 5

select player_name, Count(goal_id) as Total_goals, country_name, jersey_no
from goal_details a
join player_mast b 
on a.player_id=b.player_id
join soccer_country c 
on b.team_id=c.country_id
where a.play_stage ='F'
group by player_name, country_name, jersey_no
order by count(goal_id) desc;

-- Exercise 6

select country_name
from soccer_country a
join soccer_city b 
on a.country_id=b.country_id
join soccer_venue c
on b.city_id=c.city_id
group by country_name;


-- Exercise 7

select player_name, country_name, jersey_no, goal_time, play_stage, goal_schedule, goal_half
from Soccer_Country a
join player_mast b 
on a.country_id=b.team_id
join goal_details c
on b.player_id=c.player_id
and c.goal_id=1;


-- Exercise 8

select referee_name, country_name
from Soccer_Country a
join referee_mast b
on a.country_id=b.country_id
join match_mast c
on c.referee_id=b.referee_id
where c.match_no=1
group by referee_name, country_name;

SELECT b.referee_name, c.country_name 
FROM match_mast a
NATURAL JOIN referee_mast b 
NATURAL JOIN soccer_country c
WHERE match_no=1;

-- Exercise 9

select referee_name, country_name
from Soccer_Country a
join referee_mast b
on a.country_id=b.country_id
join match_mast c
on c.referee_id=b.referee_id
where c.play_stage='F'
group by referee_name, country_name;

-- Exercise 10

select ass_ref_name, country_name
from asst_referee_mast a
join Soccer_Country b
on a.country_id=b.country_id
join match_details c
on a.ass_ref_id=c.ass_ref
where c.match_no=1;

-- Exercise 11

select ass_ref_name, country_name
from asst_referee_mast a
join Soccer_Country b
on a.country_id=b.country_id
join match_details c
on a.ass_ref_id=c.ass_ref
where c.play_stage='F';


-- Exercise 12

select city
from Soccer_city a
join soccer_venue b
on a.city_id=b.city_id
join match_mast c
on c.venue_id=b.venue_id
where c.match_no=1;

-- Exercise 13

select venue_name, aud_capacity, audence
from Soccer_city a
join soccer_venue b
on a.city_id=b.city_id
join match_mast c
on c.venue_id=b.venue_id
where c.play_stage='F';

-- Exercise 14

select venue_name, count(match_no) as Number_of_games, city
from soccer_venue a
join Soccer_city b
on a.city_id=b.city_id
join match_mast c
on a.venue_id=c.venue_id
group by venue_name, city;

-- Exercise 15

select top 1 player_name, country_name
from player_booked a
join player_mast b
on a.player_id=b.player_id
join Soccer_Country c
on b.team_id=c.country_id
where a.sent_off='Y'


SELECT match_no, country_name, player_name, 
booking_time as "sent_off_time", play_schedule, jersey_no
FROM player_booked a
JOIN player_mast b
ON a.player_id=b.player_id
JOIN soccer_country c
ON a.team_id=c.country_id
AND  a.sent_off='Y'
AND match_no=(
	SELECT MIN(match_no) 
	from player_booked)
ORDER BY match_no,play_schedule,play_half,booking_time;

-- Exercise 16

select country_name, goal_for
from soccer_team a
join soccer_country b
on a.team_id=b.country_id
where a.goal_for=1
group by country_name, goal_for;



-- Exercise 17

select country_name, count(*) as Total_Yellow_Cards
from Soccer_Country a
join player_booked b
on a.country_id=b.team_id
where b.sent_off is null
group by country_name
order by Total_Yellow_Cards desc;


-- Exercise 18

select venue_name, count(goal_id) as total_goals
from soccer_venue a
join match_mast b
on a.venue_id=b.venue_id
join goal_details c
on b.match_no=c.match_no
group by venue_name
order by total_goals desc;


-- Exercise 19

select match_no
from match_mast
where stop1_sec=0;

SELECT match_details.match_no, soccer_country.country_name 
FROM match_mast
JOIN match_details 
ON match_mast.match_no=match_details.match_no
JOIN soccer_country
ON match_details.team_id=soccer_country.country_id
WHERE stop1_sec=0;


-- Exercise 20

select country_name, goal_agnst
from Soccer_team a
join Soccer_Country b
on a.team_id=b.country_id
group by country_name, goal_agnst
order by goal_agnst desc;

SELECT country_name,goal_agnst
FROM soccer_team 
JOIN soccer_country 
ON soccer_team.team_id=soccer_country.country_id
WHERE goal_agnst=(
SELECT MAX(goal_agnst) 
FROM soccer_team);

-- Exercise 21

select country_name
from Soccer_Country a
join match_details b
on a.country_id=b.team_id
join match_mast c
on c.match_no=b.match_no
where stop2_sec=(
select max(stop2_sec)
from match_mast);


-- Exercise 22

select match_no, country_name
from match_details a
join Soccer_Country b
on a.team_id=b.country_id
where win_lose ='D'
and goal_score =0
and play_stage ='G';

-- Exercise 23

select country_name
from Soccer_Country a
join match_details b
on a.country_id=b.team_id
join match_mast c
on c.match_no=b.match_no
where stop2_sec=(
select max(stop2_sec)
from match_mast
where stop2_sec < 
(select max(stop2_sec)
from match_mast));

-- Exercise 24

select player_name, count(player_gk) as Games_played, country_name
from player_mast a
join match_details b
on a.player_id=b.player_gk
join Soccer_Country c
on b.team_id=c.country_id
group by player_name, country_name
order by country_name, Games_played desc;

-- Exercise 25

select venue_name, count(goal_id) as total_goals
from soccer_venue a
join match_mast b
on a.venue_id=b.venue_id
join goal_details c
on b.match_no=c.match_no
group by venue_name
having count(goal_id)=(
select max(total_goals)
from (
select venue_name, count(goal_id) as total_goals
from soccer_venue a
join match_mast b
on a.venue_id=b.venue_id
join goal_details c
on b.match_no=c.match_no
group by venue_name) gd)
;


SELECT venue_name, count(venue_name)
FROM goal_details
JOIN soccer_country
ON goal_details.team_id=soccer_country.country_id
JOIN match_mast ON goal_details.match_no=match_mast.match_no
JOIN soccer_venue ON match_mast.venue_id=soccer_venue.venue_id
GROUP BY venue_name
HAVING COUNT (venue_name)=( 
SELECT MAX(mycount) 
FROM ( 
SELECT venue_name, COUNT(venue_name) mycount
FROM goal_details
JOIN soccer_country
ON goal_details.team_id=soccer_country.country_id
JOIN match_mast ON goal_details.match_no=match_mast.match_no
JOIN soccer_venue ON match_mast.venue_id=soccer_venue.venue_id
GROUP BY venue_name) gd);

-- Exercise 26

select player_name, country_name, age, dt_of_bir
from player_mast a
join Soccer_Country b
on a.team_id=b.country_id
order by dt_of_bir
offset 0 rows
fetch first 1 row only;


-- Exercise 27

select country_name, match_no
from soccer_country a
join match_details b
on a.country_id=b.team_id
where goal_score = 3
and win_lose ='D'
;

-- Exercise 28

select country_name, team_group, match_played, goal_agnst, group_position
from Soccer_Country a
join Soccer_team b
on a.country_id=b.team_id
where group_position=4
and goal_agnst =4;

-- Exercise 29

select player_name, playing_club, country_name
from player_mast a
join Soccer_Country b
on a.team_id=b.country_id
where playing_club ='Lyon'
AND a.team_id IN (
SELECT b.country_id 
FROM soccer_country b
WHERE b.country_id IN (
SELECT c.team_id 
FROM match_details c 
WHERE c.play_stage='F'));

-- Exercise 30

select country_name, play_stage
from Soccer_Country a
join match_details b
on a.country_id=b.team_id
where play_stage ='S';


-- Exercise 31

select player_name, posi_to_play, age, playing_club, country_name
from player_mast a
join match_captain b
on a.player_id=b.player_captain
join Soccer_Country c
on c.country_id=b.team_id
where match_no in (48, 49);

-- Exercise 32

select match_no, player_name, posi_to_play, age, playing_club, country_name
from player_mast a
join match_captain b
on a.player_id=b.player_captain
join Soccer_Country c
on c.country_id=b.team_id
order by match_no;

-- Exercise 33

select distinct mc.match_no,country_name,pmc.player_name as "Captain", pmd.player_name as "Goal" 
from match_captain mc 
join match_details md 
on mc.team_id=md.team_id 
join player_mast pmc 
on mc.player_captain=pmc.player_id 
join player_mast pmd 
on md.player_gk=pmd.player_id 
join soccer_country sc 
on sc.country_id=mc.team_id 
order by 1


-- Exercise 34

select b.player_name, c.country_name, b.posi_to_play, b.age, b.playing_club
from match_mast a
join player_mast b 
on b.player_id=a.plr_of_match
join soccer_country c
on c.country_id=b.team_id
where a.play_stage = 'F';


-- Exercise 35

select player_name, country_name
from player_mast a
join player_in_out b
on b.player_id=a.player_id
join Soccer_Country c
on c.country_id=a.team_id
where b.play_half = '1' 
and b.in_out = 'I'
and b.play_schedule = 'NT';

-- Exercise 36

select match_no, player_name, country_name
from player_mast a
join match_mast b
on b.plr_of_match=a.player_id
join Soccer_Country c
on c.country_id=a.team_id
order by match_no

-- Exercise 37

select kick_id, player_name, country_name
from player_mast a
join penalty_shootout b
on a.player_id=b.player_id
join Soccer_Country c
on a.team_id=c.country_id
where kick_id = 26;

-- Exercise 38

select match_no, country_name
from penalty_shootout a
join Soccer_Country b
on a.team_id=b.country_id
where match_no = (
select match_no 
from penalty_shootout 
where kick_id = 26)
and country_name <>
(select country_name
from Soccer_Country
where country_id=(
select team_id
from penalty_shootout
where kick_id=26))
group by match_no,
country_name;


-- Exercise 39

select	match_no, 
		country_name,
		player_name,
		jersey_no
	from match_captain a
	join Soccer_Country b
	on a.team_id=b.country_id
	join player_mast c
	on c.player_id=a.player_captain
	and posi_to_play = 'GK'
	order by match_no;

-- Exercise 40

select	count (distinct player_name)
	from match_captain a
	join Soccer_Country b
	on a.team_id=b.country_id
	join player_mast c
	on c.player_id=a.player_captain
	and posi_to_play = 'GK'

-- Exercise 41

select a.player_name, c.country_name, count(b.player_id) as Booked
from player_mast a
join player_booked b
on a.player_id=b.player_id
join Soccer_Country c
on a.team_id=c.country_id
group by a.player_name, c.country_name
order by country_name, Booked desc;

-- Exercise 42


select a.player_name, c.country_name, count(b.player_id) as Booked
from player_mast a
join player_booked b
on a.player_id=b.player_id
join Soccer_Country c
on a.team_id=c.country_id
group by a.player_name, c.country_name
having COUNT(b.player_id)=(							--Kako pridobit najvisje vrednosti s having in inner query-jem
SELECT MAX(mm) FROM (
SELECT COUNT(*) mm 
FROM player_booked 
GROUP BY player_id) inner result)
order by Booked desc;

-- Exercise 43

select  b.country_name, count (distinct a.player_id) as Booked_Players
from player_booked a
join Soccer_Country b
on a.team_id=b.country_id
group by b.country_name
order by Booked_Players desc;

select  b.country_name, count (a.player_id) as Booked_Players
from player_booked a
join Soccer_Country b
on a.team_id=b.country_id
group by b.country_name
order by Booked_Players desc;

-- Exercise 44

select top 1 match_no, count (match_no) as Bookings    --top 1 za prvo ali nizje 
from player_booked a
join Soccer_Country b
on a.team_id=b.country_id
group by match_no
order by Bookings desc

offset 0 rows											--Offset 0 rows stejem od zacetka
fetch first 1 row only;									--fetch first 1 row only izpisem samo prvo vrstico

-- Exercise 45

select match_no, ass_ref_name, country_name
from match_details a
join asst_referee_mast b
on a.ass_ref=b.ass_ref_id
join Soccer_Country c
on c.country_id=a.team_id
order by match_no;

-- Exercise 46


select country_name, count(distinct match_no) as Number
from match_details a
join asst_referee_mast b
on a.ass_ref=b.ass_ref_id
join Soccer_Country c
on c.country_id=b.country_id
group by country_name
order by Number desc;

-- Exercise 47

select country_name, count(distinct match_no) as Number
from match_details a
join asst_referee_mast b
on a.ass_ref=b.ass_ref_id
join Soccer_Country c
on c.country_id=b.country_id
group by country_name
HAVING count(DISTINCT match_no)=
  (SELECT max(mm)
   FROM
     (SELECT count(DISTINCT match_no) mm
	 from match_details a
join asst_referee_mast b
on a.ass_ref=b.ass_ref_id
join Soccer_Country c
on c.country_id=b.country_id
group by country_name) hh)

order by Number desc
offset 0 rows
fetch first 1 row only;

-- Exercise 48

select match_no, referee_name, country_name
from match_mast a
join referee_mast b
on a.referee_id=b.referee_id
join Soccer_Country c
on c.country_id=b.country_id
order by match_no;

-- Exercise 49

select country_name, count (a.referee_id) as Matches_reffed
from match_mast a
join referee_mast b
on a.referee_id=b.referee_id
join Soccer_Country c
on b.country_id=c.country_id
group by country_name
order by Matches_reffed desc;

-- Exercise 50

select country_name, count (match_no) as Matches_reffed
from match_mast a
join referee_mast b
on a.referee_id=b.referee_id
join Soccer_Country c
on b.country_id=c.country_id
group by country_name
HAVING count(DISTINCT match_no)=
  (SELECT max(mm)
   FROM
     (SELECT count(DISTINCT match_no) mm
	from match_mast a
join referee_mast b
on a.referee_id=b.referee_id
join Soccer_Country c
on b.country_id=c.country_id
group by country_name) hh)
order by Matches_reffed desc;

-- Exercise 51

select referee_name, country_name, count(match_no) as TotalMatches
from match_mast a
join referee_mast b
on a.referee_id=b.referee_id
join Soccer_Country c
on b.country_id=c.country_id
group by referee_name, country_name
order by TotalMatches desc;

-- Exercise 52

select referee_name, country_name, count(match_no) as TotalMatches
from match_mast a
join referee_mast b
on a.referee_id=b.referee_id
join Soccer_Country c
on b.country_id=c.country_id
group by referee_name, country_name
having count(match_no)=								--Zaèetek izbora najvišjih vrednosti HAVING CLAUSE
(select max(aa)										--izbor najvisje vrednosti za naslednji querry(tisti zgoraj)
from 
(select count(match_no) aa							--izbor referenciramo nazaj gor v max (aa) v tem primeru
from match_mast a
join referee_mast b
on a.referee_id=b.referee_id
join Soccer_Country c
on b.country_id=c.country_id
group by referee_name, country_name)hh)				--
order by TotalMatches desc;

-- Exercise 53

select referee_name, country_name, venue_name, count(match_no) as TotalMatches
from match_mast a
join referee_mast b
on a.referee_id=b.referee_id
join Soccer_Country c
on b.country_id=c.country_id
join soccer_venue d
on d.venue_id=a.venue_id
group by referee_name, country_name, venue_name
order by TotalMatches desc;


-- Exercise 54

select referee_name, count(a.match_no) as TotalBookings
from match_mast a
join player_booked b
on a.match_no=b.match_no
join referee_mast c
on c.referee_id=a.referee_id
group by referee_name
order by TotalBookings desc;


-- Exercise 55

select referee_name, count(a.match_no) as TotalBookings
from match_mast a
join player_booked b
on a.match_no=b.match_no
join referee_mast c
on c.referee_id=a.referee_id
group by referee_name
having count(a.match_no)=
(select max(aa)
from 
(select count(a.match_no) as aa
from match_mast a
join player_booked b
on a.match_no=b.match_no
join referee_mast c
on c.referee_id=a.referee_id
group by referee_name) hh)
order by TotalBookings desc;

-- Exercise 56

select player_name, country_name, jersey_no
from player_mast a
join Soccer_Country b
on a.team_id=b.country_id
where jersey_no = '10';

-- Exercise 57

select distinct player_name, country_name, posi_to_play
from player_mast a
join goal_details b
on a.player_id=b.player_id
join Soccer_Country c
on a.team_id=c.country_id
where posi_to_play= 'DF';

-- Exercise 58

select distinct player_name, country_name, posi_to_play
from player_mast a
join goal_details b
on a.player_id=b.player_id
join Soccer_Country c
on a.team_id=c.country_id
where goal_type = 'O';

-- Exercise 59

select match_no, country_name, penalty_score
from match_details a
join Soccer_Country b
on a.team_id=b.country_id
where penalty_score is not null;

ali 
where decided_by = 'P';

-- Exercise 60

select country_name, posi_to_play, count (goal_id) as GoalScored
from goal_details a
join player_mast b
on a.player_id=b.player_id
join Soccer_Country c
on a.team_id=c.country_id
group by country_name, posi_to_play
order by GoalScored desc;


-- Exercise 61

select player_name, country_name, time_in_out
from player_mast a
join player_in_out b
on a.player_id=b.player_id
join Soccer_Country c
on a.team_id=c.country_id
where in_out = 'I'
and time_in_out=
(select max(time_in_out)
from player_in_out);