--grouping
-- 1. group smartphones by brand and get the count, average price
-- max rating, avg screen size and avg battery capacity
select brand_name, count(*) as num_phones,
round(avg(price)) as avg_price,
max(rating) as max_rating,
round(avg(screen_size),2) as avg_screen_size,
round(avg(battery_capacity)) as avg_battery_cap
from smartphones
group by brand_name
order by num_phones desc;

--practicing
select brand_name, num_phones
from (
    select brand_name, count(*) as num_phones
    from smartphones
    group by brand_name
    order by num_phones desc
)
where rownum <= 5;

select brand_name, num_phones
from (
    select brand_name, num_phones, rownum as rn
    from (
        select brand_name, count(*) as num_phones
        from smartphones
        group by brand_name
        order by num_phones desc
    )
)
where rn = 4;
