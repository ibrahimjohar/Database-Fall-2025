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

--q12

--q13

--q14

--q15

--q16

--q17

--q18

--q19

--q20
