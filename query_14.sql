--find the fraction of users, rounded to two decimal places, who accessed Amazon music and upgraded to prime membership within the first 30 days of signing up.

create table users
(
user_id integer,
name varchar(20),
join_date date
);
insert into users
values (1, 'Jon', CAST('2-14-20' AS date)), 
(2, 'Jane', CAST('2-14-20' AS date)), 
(3, 'Jill', CAST('2-15-20' AS date)), 
(4, 'Josh', CAST('2-15-20' AS date)), 
(5, 'Jean', CAST('2-16-20' AS date)), 
(6, 'Justin', CAST('2-17-20' AS date)),
(7, 'Jeremy', CAST('2-18-20' AS date));

create table events
(
user_id integer,
type varchar(10),
access_date date
);

insert into events values
(1, 'Pay', CAST('3-1-20' AS date)), 
(2, 'Music', CAST('3-2-20' AS date)), 
(2, 'P', CAST('3-12-20' AS date)),
(3, 'Music', CAST('3-15-20' AS date)), 
(4, 'Music', CAST('3-15-20' AS date)), 
(1, 'P', CAST('3-16-20' AS date)), 
(3, 'P', CAST('3-22-20' AS date));


--select * from users
--select * from events


with purchased_music as (
select *
from users
where user_id in (select user_id from events where type = 'Music'))
, num_purchased_music as (
select count(user_id) as music_count
from purchased_music)
, num_upgraded_to_prime as (
select count(pm.user_id) as num_prime
from purchased_music pm
inner join events e1 on pm.user_id = e1.user_id
left join events e2 on  pm.user_id = e2.user_id and e1.type < e2.type
where e1.type = 'Music' and e2.type = 'P' and datediff(day, pm.join_date, e2.access_date) <= 30)

select (num_prime * 1.0 / music_count) * 100 as perc_of_music_to_prime
from num_purchased_music, num_upgraded_to_prime

