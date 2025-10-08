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

-- 2.group smartphones by whether they have an NFC and get the average proce and rating
select has_nfc, round(avg(price),2) as avg_price, round(avg(rating),2) as avg_rating
from smartphones
group by has_nfc;
--True	55262.22	82.73
--False	17294.79	75.5
select has_5g, round(avg(price),2) as avg_price, round(avg(rating),2) as avg_rating
from smartphones
group by has_5g;
--True	43200.49	82.19
--False	18916.53	73.31

-- 3.group smartphones by the extended memory available and get the average price
select extended_memory_available, 
round(avg(price),2) as avg_price,
round(avg(rating),2) as avg_rating
from smartphones
group by extended_memory_available;
--1	18953.88	76
--0	55681.2	   82.44


-- 4.group smartphones by the brand & processor brand and get the count of models
----and the average primary camera resolution (rear)

select brand_name, processor_brand, count(*) as num_phones,
round(avg(primary_camera_rear),2) as avg_camera_resolution
from smartphones
group by brand_name, processor_brand
order by num_phones desc;
--xiaomi	snapdragon	67	67.78
--samsung	exynos	    50	48.08
--vivo	    snapdragon	48	45.32
--apple	    bionic	    45	20.93

-- 5.find top 5 most costly phone brands
select brand_name, avg_price
from (
    select brand_name, round(avg(price),2) as avg_price
    from smartphones
    group by brand_name
    order by avg_price desc
)
where rownum <= 5;

-- 6.which brand makes the smallest screen smartphone
select brand_name, avg_screen_size
from (
    select brand_name, avg_screen_size, rownum as rn
    from (
        select brand_name, round(avg(screen_size),2) as avg_screen_size
        from smartphones
        group by brand_name
        order by avg_screen_size asc
    )
)
where rn = 1;
--duoqin	3.54
