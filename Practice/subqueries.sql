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
