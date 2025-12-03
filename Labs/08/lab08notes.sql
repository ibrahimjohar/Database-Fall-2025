--lab 08 notes

SET SERVEROUTPUT ON;
--if else case
DECLARE
    x integer := 20;
BEGIN
    IF x > 0 THEN
        dbms_output.put_line('Positive, x= ' || x);
    ELSIF x = 0 THEN
        dbms_output.put_line('Zero, x= ' || x);
    ELSE
        dbms_output.put_line('Negative, x= ' || x);
    END IF;
END;

--loops
SET SERVEROUTPUT ON;

DECLARE

BEGIN
    for c in (select employee_id, first_name, salary
                from employees
                where department_id = 90)
    loop
        dbms_output.put_line('Salary for employee ' 
                            || c.first_name || ' is: ' 
                            || c.salary);
    end loop;
END;

--numeric loop
set serveroutput on;

declare

begin
    for i in 1..5 loop
        dbms_output.put_line('Number: ' || i);
    end loop;
end;

--another loop example
set serveroutput on;

declare

begin
    for r in (select 1 as num from dual
            union all
            select 2 from dual
            union all
            select 3 from dual
    )
    loop
        dbms_output.put_line('Number: ' || r.num);
    end loop;
end;

--simple employee loop
set serveroutput on;

declare 

begin
    for c in (select employee_id, first_name, salary
            from employees
            where salary > 5000)
    loop
        dbms_output.put_line('Employee: ' || c.first_name
                        || ', Salary: ' || c.salary);
    end loop;
end;

--explicit cursor

--1.DECLARE the cursor
--2.OPEN the cursor
--3.FETCH rows one by one
--4.EXIT WHEN cursor is empty
--5.CLOSE the cursor

set serveroutput on;
declare
    cursor cur is
        select 10 as num from dual
        union all
        select 20 from dual
        union all
        select 30 from dual;
    r cur%ROWTYPE;
begin
    open cur;
    loop
        fetch cur into r;
        exit when cur%NOTFOUND;
        dbms_output.put_line('Value: ' || r.num);
    end loop;
    close cur;
end;

--lab manual example
set serveroutput on;
declare
    cursor cur is
            select employee_id, first_name, salary
            from employees
            where salary > 10000;
    r cur%ROWTYPE;
begin
    open cur;
    loop
        fetch cur into r;
        exit when cur%NOTFOUND;
        dbms_output.put_line('ID: ' || r.employee_id || ' - Name: ' || r.first_name || ' - Salary: ' || r.salary);
    end loop;
    close cur;
end;

--views
create or replace view simple_employee_view as
select employee_id, first_name, last_name, salary
from employees
where salary > 5000;

--to run
select * from simple_employee_view;

--function creation
create or replace function GetSalary(emp_id NUMBER)
return NUMBER
is
    sal NUMBER;
begin
    select salary into sal
    from employees
    where employee_id = emp_id;
    
    return sal;
end;

--usage
select GetSalary(150) from dual;

--function - get highest salary in department
create or replace function GetMaxSalary(dept_id NUMBER)
return NUMBER
is
    sal NUMBER;
begin
    select max(salary)
    into sal
    from employees
    where department_id = dept_id;
    
    return sal;
end;

--usage
select GetMaxSalary(10) from dual;


--procedures
create or replace procedure RaiseSalary(emp_id NUMBER)
is
begin
    update employees
    set salary = salary + 500
    where employee_id = emp_id;
    
    dbms_output.put_line('salary updated for employee id: ' || emp_id);
end;

begin
    RaiseSalary(150);
end;

--object type - 
create or replace type emp_obj_type as object(
    employee_id number,
    first_name varchar(20),
    last_name varchar(20),
    department_id number
);

--creating table type
create or replace type emp_tbl_type as table of emp_obj_type;

--creating function that returns the table type
create or replace function GetDeptEmployees(dept_id number)
return emp_tbl_type
is
    result emp_tbl_type := emp_tbl_type();
begin
    select emp_obj_type(employee_id, first_name, last_name, department_id)
    bulk collect into result
    from employees
    where department_id = dept_id;
    
    return result;
end;

--BULK COLLECT allows to fetch many rows at once into a collection.

--select from the returned collection
select * from table(GetDeptEmployees(80));


--another example
--object
create or replace type emp_obj_type_2 as object(
    employee_id number,
    first_name varchar(20),
    last_name varchar(20),
    salary number
);

--creating table type
create or replace type emp_tbl_type_2 as table of emp_obj_type_2;

--function that returns a table of employee objects
create or replace function GetHighEarners(threshold number)
return emp_tbl_type_2
is
    result emp_tbl_type_2 := emp_tbl_type_2();
begin
    select emp_obj_type_2(employee_id, first_name, last_name, salary)
    bulk collect into result
    from employees
    where salary > threshold;
    
    return result;
end;

select * from table(GetHighEarners(20000));
