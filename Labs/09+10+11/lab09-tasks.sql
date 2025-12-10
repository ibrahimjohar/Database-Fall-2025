--ibrahim johar - 23K-0074 - BAI-5A
--lab 09 tasks

--q1
create or replace trigger trg_stds_uppercase
before insert on students
for each row
begin
    :new.student_name := upper(:new.student_name);
end;
/

--q2
create or replace trigger trg_dont_delete_weekend
before delete on employees
begin
    if to_char(sysdate, 'dy') in ('sat', 'sun') then
        raise_application_error(-20100, 'deletion is not allowed on weekends.');
    end if;
end;
/

--q3
create table log_salary_audit (
    employee_id number,
    old_salary number,
    new_salary number,
    changed_by varchar2(30),
    changed_date date
);
/

--q4
create or replace trigger prod_price_check_trg
before update of price on products
for each row
begin
    if :new.price < 0 then
        raise_application_error(-20101, 'negative prices arent allowed.');
    end if;
end;

create or replace trigger trg_log_salary_updates
after update of salary on employees
for each row
begin
    insert into log_salary_audit
    values (
        :old.employee_id,
        :old.salary,
        :new.salary,
        user,
        sysdate
    );
end;
/

--q5
create table course_insert_audit (
    username varchar2(30),
    log_time date
);

create or replace trigger course_insert_audit_trg
after insert on courses
for each row
begin
    insert into course_insert_audit
    values (user, sysdate);
end;
/

--q6
create or replace trigger emp_assign_default_dept
before insert on emp
for each row
begin
    if :new.department_id is null then
        :new.department_id := 5;   --default department here
    end if;
end;
/

--q7
create or replace trigger sales_totals_comp_trg
for insert on sales
compound trigger
  
    amount_before number;
    amount_after  number;

    before statement is
    begin
        select nvl(sum(amount),0)
        into amount_before
        from sales;
    end before statement;

    after statement is
    begin
        select nvl(sum(amount),0)
        into amount_after
        from sales;
        dbms_output.put_line('previous total: ' || amount_before);
        dbms_output.put_line('new total: ' || amount_after);
    end after statement;

end sales_totals_comp_trg;
/

--q8
create table schema_ddl_log (
    username varchar2(30),
    event_type varchar2(20),
    object_name varchar2(30),
    event_time date
);

create or replace trigger ddl_audit_trg
after create or drop on schema
begin
    insert into schema_ddl_log
    values (
        user,
        ora_sysevent,
        ora_dict_obj_name,
        sysdate
    );
end;
/

--q9
create or replace trigger order_block_shipped_trg
before update on orders
for each row
begin
    if :old.order_status = 'shipped' then
        raise_application_error(-20102, 'shipped orders cant be updated.');
    end if;
end;
/
  
--q10
create table login_audit (
    username varchar2(30),
    login_time date
);

create or replace trigger schema_logon_audit
after logon on schema
begin
    insert into login_activity
    values (user, sysdate);
end;
/
