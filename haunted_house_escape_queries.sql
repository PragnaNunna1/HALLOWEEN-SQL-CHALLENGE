-- ROOM1: THE ENTRY WAY
-- Only those who know our(ghosts) favorite number will pass
select name, sum(favorite_number) as sum_fnums from ghosts
where haunting_room = 'Entryway' and name like 'B%'
group by name;

-- ROOM2: THE HALL OF POTRAITS
-- Only the oldest painting reveals the next clue.
SELECT * from portraits
where painted_year = (select min(painted_year) from portraits);

-- ROOM3: THE DINING HALL
-- Everyguest was poisoned. Find all course types where the averagepoison_level > 7.
SELECT course, avg(poison_level) as avg_poison_level from meals
group by course
having avg(poison_level) > 7;


-- ROOM4: THE LIBRARY
-- Return the title and author name for every book written by an 
--author who died before 1900.
SELECT a.name, b.title
from authors a
left join books b on a.author_id = b.author_id
where a.death_year < 1900;

-- ROOM5: THE LABORATORY
-- Only the most successful experimentholds the key to escape.
-- Find the experiment_name of the experiments with highest success_rate.
Select * from experiments
where success_rate = (select max(success_rate) from experiments);

-- ROOM6: THE GRAVEYARD
-- query that returns name,cause_of_death, and a 
-- new column “peacefulness” using: 
-- If cause_of_death = 'old age', then ‘Peaceful’ Otherwise, ‘Tragic’Each
select name, cause_of_death,
	(case when cause_of_death = 'old age' then 'Peaceful' else 'Tragic' end) as peacefulness
from tombstones;

-- ROOM7: THE CLOCK TOWER
-- one chime was louder than the onebefore it. And that’s when the doorcracked open.
with cte as(
select *, lag(volume)over() as pre_volume 
from chimes
order by chime_id)
select chime_id from cte
where volume < pre_volume;

-- ROOM8: THE FINAL DOOR
-- find the door_name that can be opened by the key with highest 
-- average power_level among successful attempts.
with cte as(
SELECT k.key_id, a.lock_id, avg(power_level) as avg_power from keys k
join attempts a on k.key_id = a.key_id
where a.success = 1
group by k.key_id, a.lock_id
order by avg_power desc
limit 1)
select l.door_name from locks l
join cte c on c.lock_id = l.lock_id;