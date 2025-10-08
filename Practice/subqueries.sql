--subquery
--a subquery is a query within another query.
--its a SELECT statement that is nested inside another 
--SELECT,INSERT,UPDATE, or DELETE statement.
--the subquery is executed first, and its result is then used as a 
--parameter or condition for the outer query

--find the movie with the highest rating

--breaking down the subquery
--first step
select max(score) from movies;
--second step
select * from movies
where score = 9.3;

--corr ver: combining both
select * from movies
where score = (select max(score) from movies);

--inner query always works first, and the output from it is used for the outer query

--types of subqueries
--based on:
----the result it returns
----based on working

--result it returns(returned data)
--1.SCALAR SUBQUERY (e.g., 9.3)
--2.ROW SUBQUERY (e.g., multiple rows(w/categorical data) but ONE COL only)
--3.TABLE SUBQUERY (e.g., multiple rows and multiple cols essentially another table)


--based on working (working)
----independent
----correlated

--INSERT
--SELECT
----WHERE
----SELECT
----FROM
----HAVING
--UPDATE
--DELETE

--independent subquery (scalar subquery)

-- 1.find the movie with highest profit (vs order by)
select * from movies
where (gross - budget) = max_profit;

select max(gross - budget) from movies;

select * from movies
where (gross - budget) = (select max(gross - budget) from movies);

--with order by
select * from movies
order by (gross - budget) desc;

select name, rating from (
    select name, rating, rownum as rn
    from (
        select name, rating
        from movies
        order by (gross-budget) desc
    )
)
where rn = 1;


-- 2.find how many movies have a rating > the avg of all movie ratings 
--(find the count of above average movies)

select * from movies
where score > avg(score);

select avg(score) from movies;

select * from movies
where score > (select avg(score)
                from movies);

--final
select count(*) from movies
where score > (select avg(score)
                from movies);

-- 3.find highest rated movie of the year 2000.
select max(score) from movies
where year = 2000;

select * from movies
where year = 2000 and score = (select max(score) 
                                from movies
                                where year = 2000);
                                
-- 4. find highest rated movie among all movies whose num of votes
-----are > the dataset avg votes

select avg(votes) from movies;

select max(score) from movies
where votes > (select avg(votes) from movies);

--final
select * from movies
where score = (select max(score) from movies
                where votes > (select avg(votes)
                                from movies));

--independent subquery --> row subquery (one column multiple rows)

-- 1. find all the users who never placed an order

select distinct(user_id) from orders_res;

select * from users_res
where user_id NOT IN (select distinct(user_id) 
                        from orders_res);


-- 2. find all movies made by top 3 directors (in terms of total gross income)

select director, sum(gross)
from movies
group by director
order by sum(gross) desc limit 3;

select director, total_gross
from (
    select director, sum(gross) as total_gross
    from movies
    group by director
    order by sum(gross) desc
)
where rownum <=3; --88

select director
from movies
group by director 
order by sum(gross) desc;

select * from movies
where director 
in (select director, total_gross
    from (
        select director, sum(gross) as total_gross
        from movies
        group by director
        order by sum(gross) desc
    )
    where rownum <=3
);

-- 3. find all movies of all those actors whose filmography's avg
---->8.5 (take 25000 votes as cut off)

select star, avg(score) from movies
where votes > 25000
group by star
having avg(score) > 8.5;

select * from movies
where star in (select star from movies
                where votes > 25000
                group by star
                having avg(score) > 8.5
);

--independent subquery - table subquery (multi col multi row)
--1. find the most profitable movie of each year
select year, max(gross - budget)
from movies
group by year;

select * from movies
where (year, gross - budget) in (select year, max(gross - budget)
                                    from movies
                                    group by year);

-- 2.find the highest rated movie of each genre, votes cutoff of 25000

select genre, max(score)
from movies
where votes > 25000
group by genre;

select * from movies
where (genre, score) in (select genre, max(score)
                            from movies
                            where votes > 25000
                            group by genre)
and votes > 25000;


-- 3. find the highest grossing movies of top 5 actor/director combo in terms of
-----total gross income

select star, director, sum(gross), max(gross)
from movies
group by star, director
order by sum(gross) desc;

select star, director, total_gross, max_gross
from (
    select star, director, sum(gross) as total_gross, max(gross) as max_gross
    from movies
    group by star, director
    order by sum(gross) desc

)where rownum <= 5;
--logic correct but doesnt work in oracle 11g
with top_duos as (
        select star, director, total_gross, max_gross
        from (
            select star, director, sum(gross) as total_gross, max(gross) as max_gross
            from movies
            group by star, director
            order by sum(gross) desc
        )where rownum <= 5
)
select * from movies
where (star, director, gross) in (select * from top_duos);

--syntax correct
with top_duos as (
    select star, director, sum(gross) as total_gross, max(gross) as max_gross
    from movies
    group by star, director
    order by sum(gross) desc
)
select *
from movies
where (star, director) in (
        select star, director
        from (
            select star, director
            from top_duos
            where rownum <= 5
        )
);

--correlated subquery
--1. find all the movies that have a rating higher than the avg rating of movies 
----in the same genre
select * from movies
where score > avg(genre)

select avg(score) from movies where genre = ?;

select * from movies m1
where score > (select avg(score) from movies m2 where m2.genre = m1.genre);

-- 2. find the fav food of each customer
select name, f_name, count(*) from users_res t1
join orders_res t2 on t1.user_id = t2.user_id
join order_details_res t3 on t2.order_id = t3.order_id
join food t4 on t3.f_id = t4.f_id
group by t2.user_id, t3.f_id;

with fav_food as (
    select t2.user_id, name, f_name, count(*) as freq
    from users_res t1
    join orders_res t2 on t1.user_id = t2.user_id
    join order_details_res t3 on t2.order_id = t3.order_id
    join food t4 on t3.f_id = t4.f_id
    group by t2.user_id, t3.f_id
)
select * from fav_food
where freq = (select max(freq)
                from fav_food f1
                where f1.user_id = f1.user_id);

--usage with SELECT
-- 1. get percentage of votes for each movie compared to the
-----total num of votes

select name, ((votes/(select sum(votes) from movies))*100) from movies;

--2. display all movie names, genre, score and avg(score) of genre

select name, genre, score, (select avg(score) from movies m2 where m2.genre = m1.genre) from movies m1;

--usage with FROM
--display avg rating of all restaurants
select r_id, avg(restaurant_rating) as avg_rating
from orders_res
group by r_id;

select r_name, avg_rating
from (select r_id, avg(restaurant_rating) as avg_rating
        from orders_res
        group by r_id) t1 join restaurants t2
        on t1.r_id = t2.r_id;

--usage with HAVING
--find genres having avg score > avg score of all movies
select genre, avg(score)
from movies
group by genre
having avg(score) > (select avg(score) from movies);



--subquery in INSERT
-- populate an already created loyal_customers table w/ records
-- of only those customers who have ordered food more than 3 times


insert into loyal_users
(user_id, name)
select t1.user_id, name, count(*)
from orders_res t1
join users_res t2 on t1.user_id = t2.user_id
group by user_id
having count(*) > 3;
