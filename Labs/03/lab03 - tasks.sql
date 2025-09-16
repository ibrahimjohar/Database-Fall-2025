--q1
--couldn't use "employees" due to name already in use hence 'employees1"
create table employees1
(   emp_id number primary key,
    emp_name varchar(100),
    salary number(10,2) constraint checking_salary check (salary > 20000),
    dept_id number,
    constraint foreignkey_emp_dept foreign key (dept_id) references departments(department_id)
);

--q2
alter table employees1 rename column emp_name to full_name;

--q3
alter table employees1 drop constraint checking_salary;
insert into employees1 (emp_id, full_name, salary, dept_id)
values (126, 'Ibrahim Johar', 5000, 10); 

--q4
create table departments1
(   dept_id number primary key,
    dept_name varchar(50) unique
);

insert into departments1(dept_id, dept_name) values (15, 'finance');
insert into departments1(dept_id, dept_name) values (25, 'hr');
insert into departments1(dept_id, dept_name) values (35, 'secuirity');

select * from departments1;

--q5
alter table employees1
add constraint fk_emp_dept
  foreign key (dept_id)
  references departments1(dept_id);

select constraint_name, constraint_type, status
from user_constraints
where table_name = 'employees1';

--q6
alter table employees1 add bonus number(6,2) default 1000;

--q7
alter table employees1 add city varchar(20) default 'karachi';
alter table employees1 add age number;
alter table employees1 add constraint check_age check(age > 18);
select * from employees1;

--q8
delete from employees1 where emp_id in (1,3);

--q9
alter table employees1 modify (full_name varchar(20), city varchar(20));

--q10
alter table employees1 add email varchar(100);
alter table employees1 add constraint unique_emp_email unique(email);

--q11
alter table employees1 add constraint unq_emp_bonus unique(bonus);
--insert 1st entry
insert into employees1 values (221, 'Ahmed', 30000, 10, 500, 'karachi', 19, 'ahmed@gmail.com');
select emp_id, full_name, dept_id, bonus, city, age, email from employees1 where emp_id = 221;
--try to insert 2nd entry
insert into employees1 values (222, 'Ali', 32000, 10, 500, 'karachi', 21, 'ali@gmail.com');

--q12
alter table employees1 add dob date;
alter table employees1 add constraint check_emp_age check (dob <= date '2007-01-01');

--q13
insert into employees1(emp_id, full_name, salary, dept_id, dob)
values(203, 'baby ali', 31000, 15, date '2009-01-01');

--q14
alter table employees1 drop constraint fk_emp_dept;
alter table employees1 drop constraint foreignkey_emp_dept;

insert into employees1 values(209, 'ethan khan', 28000, 999, 510, 'karachi', 25, 'ethan@hotmail.com', date '2000-01-01');

select * from employees1;

alter table employees1 add constraint fk_emp_dept foreign key (dept_id) references departments1(dept_id) enable novalidate; 

insert into employees1 values(210, 'rehan khan', 29000, 999, 490, 'karachi', 25, 'rehan@hotmail.com', date '2000-01-01');

--q15
alter table employees1 drop column age;
alter table employees1 drop column city;

--q16
select dept_id, emp_id, full_name from employees1 order by dept_id;

--q17
alter table employees1 rename column salary to monthly_salary;

select constraint_name, column_name, position
from user_cons_columns
where table_name = 'employees1'
order by constraint_name, position;

--q18
select d.dept_id, d.dept_name 
from departments1 d
where not exists 
(   select 1 from employees1 e where e.dept_id = d.dept_id
);

--q19
drop table students;

--q20
select dept_id, emp_count
from (
    select dept_id, count(*) as emp_count
    from employees1
    group by dept_id
    order by emp_count desc
)
where rownum = 1;
