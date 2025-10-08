--ibrahim johar
--23k-0074
--bai-5a
--lab04-inlab tasks

--q1
select dept_id, count(*) as num_students
from students
group by dept_id;

--q2
select dept_id, avg(gpa) as avg_gpa
from students
group by dept_id
having avg(gpa) > 3.0;

--q3
select course_id, round(avg(fee),2) as avg_fee
from students
group by course_id;

--q4
select dept_id, count(*) as num_faculty
from faculty
group by dept_id;

--q5
select *
from faculty
where salary > (select avg(salary) from faculty);

--q6
select *
from students
where gpa > any (select gpa from students where dept_id = 'cs');

--q7
select *
from (
    select * 
    from students
    order by gpa desc
)
where rownum <= 3;

--q8
select a.std_id, s.name
from students s
where not exists(
    select c.course_id
    from enrollment c
    where c.std_id = (select std_id from students where name = 'Ali')
    minus
    select e.course_id
    from enrollment e
    where e.std_id = s.std_id
);

--q9
select dept_id, sum(fee) as total_fee
from students
group by dept_id;

--q10
select * from course 
where course_id in (select course_id 
                    from enrollment
                    where std_id in (
                                    select std_id 
                                    from students
                                    where gpa >3.5
                                    )
                    );






