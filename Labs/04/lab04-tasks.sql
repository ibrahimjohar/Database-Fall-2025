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

--postLab tasks

--q11
select dept_id, sum(fee) as total_fee
from students
group by dept_id
having sum(fee) > 1000000;

--q12
select dept_id, count(*) as top_faculty
from faculty
where salary > 100000
group by dept_id
having count(*) > 5;

--q13
delete from students
where gpa < (select avg(gpa) from students);

--q14
delete from courses
where course_id not in (select distinct course_id from enrollment);

--q15
create table HighFee_Students as
select *
from students
where fee > (select avg(fee) from students)

--q16
create table retired_faculty(
            faculty_id int primary key,
            faculty_name varchar2(50),
            dept_id number,
            salary number,
            joining_date date,
            foreign key (dept_id) references department(dept_id) on delete set null);
insert into Retired_Faculty
select * 
from faculty
where joining_date < (select min(joining_date) from faculty);

--q17
select dept_id, sum(fee) as total_fee
from students
group by dept_id
having sum(fee) = (
        select max(sum(fee))
        from students
        group by dept_id
);
select dept_id, total_fee
from (
    select dept_id, total_fee, rownum as rn
    from (
        select dept_id, (sum(fee)) as total_fee
        from students
        group by dept_id
        order by sum(fee) desc
    )
)
where rn = 1;


--q18
select * 
from (
    select course_id, count(*) as total_enrolled
    from enrollment
    group by course_id
    order by count(*) desc
)
where rownum <= 3;


--q19
select * from students where gpa > (select avg(gpa) from students) 
and (std_id in (select std_id 
                from enrollment 
                group by std_id 
                having count(*) > 3)
);


--q20
insert into Unassigned_Faculty
select * from faculty
where faculty_id not in (select distinct faculty_id from courses);
