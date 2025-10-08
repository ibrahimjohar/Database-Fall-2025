--having
--whenever we have to apply filtering on the aggregate function, we use 'having'

--find avg price of brands that have atleast 20 phones
select brand_name,
count(*) as n,
round(avg(price),2) as avg_price
from smartphones
group by brand_name
having count(*) > 20
order by avg_price desc;

--1. find the avg rating of smartphone brands which have more than 20 phones
select brand_name,
count(*) as n,
round(avg(rating)) as avg_rating
from smartphones
group by brand_name
having count(*) > 20
order by avg_rating desc;

-- 2. Find the top 3 brands with the highest avg ram that has a refresh rate of at least 90 Hz 
--    and fast charging available and don't consider brands that have less than 10 phones
select brand_name, 
avg(ram_capacity) as avg_ram
from smartphones
where refresh_rate > 90 and fast_charging_available = 1
group by brand_name
having count(*) > 10
order by avg_ram desc;

select brand_name, avg_ram
from (
    select brand_name, round(avg(ram_capacity),2) as avg_ram
    from smartphones
    where refresh_rate > 90 and fast_charging_available = 1
    group by brand_name
    having count(*) > 10
    order by avg_ram desc
)
where rownum <= 3;

-- 3.Find the avg price of all the phone brands with avg rating of 70 
-----and num_phones more than 10 among all 5g enabled phones 
select brand_name, 
round(avg(price),2) as avg_price
from smartphones
where has_5g = 'True'
group by brand_name
having avg(rating) > 70 and count(*) > 10
order by avg_price desc;

--top 5 batsmen in IPL who've scored the most runs
select batter, sum(batsman_runs) as runs
from ipl
group by batter
order by runs desc;

select batter, runs
from(
    select batter, sum(batsman_runs) as runs
    from ipl
    group by batter
    order by runs desc
)
where rownum <= 5;
