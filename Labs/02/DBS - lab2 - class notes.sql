select count(*) as total_employees from employees;
select count(*) as total_employees, manager_id from employees group by (manager_id);
select distinct manager_id from employees group by (manager_id);
select sum(salary) as total_salary from employees;
select min(salary) as min_salary from employees;
select max(salary) as max_salary from employees;
select avg(salary) as average_salary from employees;
--concatenation
select first_name || salary as first_name_and_salary from employees;
select ALL salary from employees;
select salary from employees;
select salary from employees order by (salary) asc;
select first_name, hire_date from employees order by (first_name) asc;
--string functions
select lower('Ibrahim') from dual;
select first_name, lower(first_name) from employees;
select first_name, upper(first_name) from employees;
select INITCAP('the soap') from dual;
select length('ibrahim') from dual;
select first_name , length(first_name) from employees;
select ltrim(' ibrahim') from dual;
select substr('ibrahim johar', 7, 4) from dual;
select lpad('good', 7, '*') from dual;
select rpad('good', 7, '*') from dual;
--date functions
select ADD_MONTHS('16-sep-2000', 2) from dual;
select MONTHS_BETWEEN('16-dec-2024', '16-sep-2024') from dual;
select NEXT_day('4-NOV-1999', 'WEDNESDAY') from dual;

--conversion functions
select to_char(sysdate, 'DD-MM-YY') from dual;
select to_char(sysdate, 'Day') from dual;

