--lab 09 - notes

create table superheroes(
    sh_name varchar2(20)
);

--example 1: dml trigger displays user-def-message everytime user
--inserts a row into the table

set serveroutput on;
--bi: before insertion
create or replace trigger bi_superheroes
before insert on superheroes
for each row
enable
declare
    v_user varchar2(20);
begin
    select user into v_user from dual;
    dbms_output.put_line('you inserted a line mr. ' || v_user);
end;


set serveroutput on;

begin
    insert into superheroes values ('ironman');
end;

select count(*) from superheroes;




--example 2: dml trigger displays user-def-message everytime user
--updates a row into the table

set serveroutput on;
--bi: before update
create or replace trigger bu_superheroes
before update on superheroes
for each row
enable
declare
    v_user varchar2(20);
begin
    select user into v_user from dual;
    dbms_output.put_line('you updated a line mr. ' || v_user);
end;

set serveroutput on;
begin
    update superheroes set sh_name = 'Superman' where sh_name = 'ironman';
end;

--dml trigger (insert + update + delete)
set serveroutput on;
create or replace trigger tr_superheroes
before insert or delete or update on superheroes
for each row
enable
declare
    v_user varchar2(20);
begin
    select user into v_user from dual;
    
    if inserting then
        dbms_output.put_line('one row inserted by: ' || v_user);
    elsif deleting then
        dbms_output.put_line('one row deleted by: ' || v_user);
    elsif updating then
        dbms_output.put_line('one row updated by: ' || v_user);
    end if;
    
end;

--insert row
set serveroutput on;
begin
    insert into superheroes values ('batman');
end;

--update row
set serveroutput on;
begin
    update superheroes
    set sh_name = 'flash'
    where sh_name = 'batman';
end;

--delete row
set serveroutput on;
begin
    delete from superheroes
    where sh_name = 'Superman';
end;

--audit table
create table sh_audit(
    new_name varchar2(30),
    old_name varchar2(30),
    user_name varchar2(30),
    entry_date varchar2(30),
    operation varchar2(30)
);

--trigger for audit table
create or replace trigger superheroes_audit
before insert or delete or update on superheroes
for each row
enable
declare
    v_user varchar2(30);
    v_date varchar2(30);
begin
    select user, to_char(sysdate, 'DD/MON/YYYY HH24:MI:SS')
        into v_user, v_date from dual;
    
    if inserting then
        insert into sh_audit(new_name, old_name, user_name, entry_date, operation)
        values(:NEW.sh_name, NULL, v_user, v_date, 'Insert');
    elsif deleting then
        insert into sh_audit(new_name, old_name, user_name, entry_date, operation)
        values(NULL, :OLD.sh_name, v_user, v_date, 'Delete');
    elsif updating then
        insert into sh_audit(new_name, old_name, user_name, entry_date, operation)
        values(:NEW.sh_name, :OLD.sh_name, v_user, v_date, 'Update');
    end if;
end;

select * from sh_audit;

set serveroutput on;
begin
    insert into superheroes values('superman2');
end;

set serveroutput on;
begin
    update superheroes set sh_name = 'ironman'
    where sh_name = 'superman';
end;

set serveroutput on;
begin
    delete from superheroes
    where sh_name = 'ironman';
end;

--creating synchronized backup copy of table using dml trigger
desc superheroes;
create table superheroes_backup as 
select * from superheroes where 1=2;

create or replace trigger sh_backup
before insert or delete or update on superheroes
for each row
enable
begin
    if inserting then
        insert into superheroes_backup(sh_name) values(:NEW.sh_name);
    elsif deleting then
        delete from superheroes_backup where sh_name = :OLD.sh_name;
    elsif updating then
        update superheroes_backup set sh_name = :NEW.sh_name
        where sh_name = :OLD.sh_name;
    end if;
end;

select * from superheroes;
select * from superheroes_backup;

set serveroutput on;
begin
    insert into superheroes values ('batman-new');
    insert into superheroes values ('superman-new');
end;

set serveroutput on;
begin
    update superheroes set sh_name='ironman-new'
    where sh_name='batman-new';
end;

set serveroutput on;
begin
    delete from superheroes
    where sh_name = 'superman-new';
end;

set serveroutput on;
begin
    delete from superheroes
    where sh_name = 'ironman-new';
end;

set serveroutput on;
begin
    delete from superheroes
    where sh_name = 'flash';
end;

set serveroutput on;
begin
    delete from superheroes
    where sh_name = 'superman2';
end;


--DDL triggers
--using ddl triggers, we can track changes to the DB
create table schema_audit
(
    ddl_date        date,
    ddl_user        varchar2(15),
    object_created  varchar2(15),
    object_name     varchar2(15),
    ddl_operation   varchar2(15)
);

--trigger for schema_audit
create or replace trigger hr_audit_tr
--ddl below can be replaced by 'truncate' or 'create' or 'alter'
after ddl on schema
begin
    insert into schema_audit (
        ddl_date,
        ddl_user,
        object_created,
        object_name,
        ddl_operation
    )
    values(
        sysdate,
        sys_context('USERENV', 'CURRENT_USER'),
        ora_dict_obj_type,
        ora_dict_obj_name,
        ora_sysevent
    );
end;


select * from schema_audit;

create table rebllionRider(r_num NUMBER);

insert into rebllionRider values(8);

select * from rebllionRider;

truncate table rebllionRider;

drop table rebllionRider;
