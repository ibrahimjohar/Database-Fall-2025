--sorting data
-- 1.find top 5 samsung phones with the biggest screen size
select model, screen_size 
from (
    select model, screen_size
    from smartphones
    where brand_name = 'samsung'
    order by screen_size desc
)
where rownum <= 5;

-- 2.sort all the phones in descending order of the number of total cameras
select model, (num_front_cameras + num_rear_cameras) as total_cameras
from smartphones
order by total_cameras desc;

-- 3.sort data on the basis of PPI in decreasing order
select model,
round(sqrt((resolution_width * resolution_width) + (resolution_height * resolution_height)) / screen_size) as ppi
from smartphones
order by ppi desc;

-- 4.find the phone with the 2nd largest battery
select model, battery_capacity 
from (
    select model, battery_capacity, rownum as rn
    from (
        select model, battery_capacity
        from smartphones
        order by battery_capacity desc
    )
)
where rn = 13; --alot of null values in dataset, which is why 13 is the actual 2nd largest battery

select model, battery_capacity
from (
    select model, battery_capacity, rownum as rn
    from (
        select model, battery_capacity
        from smartphones
        order by battery_capacity desc
    )
)
where rn between 13 and 20;

--5. find the name and rating of the worst rated apple phone

--first observe
select * from smartphones;

--check what should be the obv result
select brand_name, model, rating from smartphones
where brand_name = 'apple'
order by rating asc;

--final nested-query
select brand_name, model, rating
from (
    select brand_name, model, rating, rownum as rn
    from (
        select brand_name, model, rating
        from smartphones
        where brand_name = 'apple'
        order by rating asc
    )
)
where rn = 1;
--output: apple	Apple iPhone SE 4	60


-- 6. sort phones alphabetically and then on the basis of rating in desc order
select * from smartphones
order by brand_name asc, rating desc;

-- 7. sort phones alphabetically and then on the basis of rating in asc order
select * from smartphones
order by brand_name asc, rating asc;
