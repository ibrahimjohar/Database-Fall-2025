--joins

--a join is a way to combine data from more database tables based on a related
--column between them

--joins are used when we want to query information that is distributed across
--multiple tables in a database, and the info we need is not contained in a single table
--by joing tables together, we can create a virtual table that contains all of the
--information we need for our query

--cross join:
--a type of join that returns the cartesian product of the two tables being joined, it returns all possible combinations of 
--rows from the two tables

--inner join:
--type of join operation that combines data from two or more tables based on a specific condition
--the inner join returns only the rows from both tables that satisfy the specified condition, that is
--matching rows.

--left join:
--also known as a left outer join, a type of join operation that returns all the rows from the left table(aka the first table)
--and matching rows from the right table (aka second table), if there are no matching rows in the right table, the result will
--contain NULL values in the columns that come from the right table

--right join:
--also known as a right outer join, a type of join operation that returns all the rows from the right table(aka the second table)
--and matching rows from the left table (aka first table), if there are no matching rows in the right table, the result will
--contain NULL values in the columns that come from the left table

--full outer join:
--a type of join operation, that returns all matching rows from both the left and right tables, as well as any non-matching rows
--from both tables, and matches rows with common values in the specified columns, and fills in NULL values for columns where
--there is no match

--cross join query
select * from users t1 cross join groups t2;

--inner join 
select * from membership t1 inner join users t2
on t1.user_id = t2.user_id;

--left join
select * from membership t1 left join users t2
on t1.user_id = t2.user_id;

--right join 
select * from membership t1 right join users t2
on t1.user_id = t2.user_id;

--outer join 
select * from membership t1 full outer join users t2
on t1.user_id = t2.user_id;

--union 
select * from person1
union
select * from person2;

--union all
select * from person1
union all
select * from person2;

--intersect
select * from person1
intersect
select * from person2;

--minus
select * from person1
minus
select * from person2;
--Returns rows that are in person1 but not in person2 (A - B)

--self join
--a type of join in which a table is joined with itself, this means that the table is treated as two separate tables, 
--with each row in the table being compared to every other row in the same table

--used when we want to compare the values of two diff rows within the same table
--might want to use this, when comparing the salaries of 2 employees who work in the same billing address

select * from users1 t1
join users1 t2
on t1.emergency_contact = t2.user_id;

--joining on more than one column
select * from students t1
join class t2
on t1.class_id = t2.class_id 
and t1.ENROLLMENT_YEAR = t2.class_year;

select * from students t1
left join class t2
on t1.class_id = t2.class_id 
and t1.ENROLLMENT_YEAR = t2.class_year;

select * from students t1
right join class t2
on t1.class_id = t2.class_id 
and t1.ENROLLMENT_YEAR = t2.class_year;


--joining more than 2 tables
select * from order_details t1
join orders t2
on t1.order_id = t2.order_id
join users t3
on t2.user_id = t3.user_id;

--filtering columns
select t1.order_id, t1.amount, t1.profit, t3.name 
from order_details t1
join orders t2
on t1.order_id = t2.order_id
join users t3
on t2.user_id = t3.user_id;

select t1.order_id, t2.name, t2.city
from orders t1
join users
on t1.user_id = t2.user_id;

--filtering rows
select * from orders t1
join users t2
on t1.user_id = t2.user_id
where t2.city = 'Pune' and t2.name = 'Sarita';



--find all profitable orders
select t1.order_id, sum(t2.profit) from orders t1
join order_details t2
on t1.order_id = t2.order_id
group by t1.order_id
having sum(t2.profit) > 0;

--find the customer who has placed max number of orders
select name, count(*) from orders t1
join users t2
on t1.user_id = t2.user_id
group by t2.name
order by count(*) desc;

select name, cnt
from (
    select name, cnt, rownum as rn
    from (
        select name, count(*) as cnt
        from orders t1
        join users t2
        on t1.user_id = t2.user_id
        group by t2.name
        order by count(*) desc
    )
)
where rn = 1;


--which is the most profitable category
select t2.vertical, sum(profit)
from order_details t1
join category t2
on t1.category_id = t2.category_id
group by t2.vertical 
order by sum(profit) desc;

select t_v, total_profit
from (
    select t_v, total_profit, rownum as rn
    from (
        select t2.vertical as t_v, sum(profit) as total_profit
        from order_details t1
        join category t2
        on t1.category_id = t2.category_id
        group by t2.vertical
        order by sum(profit) desc
    )
)
where rn = 1;
--Printers	5964

--which is the most profitable state
select * from orders t1
join order_details t2
on t1.order_id = t2.order_id
join users t3
on t1.user_id = t3.user_id;



--which is the most profitable state
select state, sum(profit) from orders t1
join order_details t2
on t1.order_id = t2.order_id
join users t3
on t1.user_id = t3.user_id
group by state
order by sum(profit) desc;


--find all categories with profit higher than 5000
select t2.vertical, sum(profit) 
from order_details t1
join category t2
on t1.category_id = t2.category_id
group by t2.vertical
having sum(profit) > 5000;
