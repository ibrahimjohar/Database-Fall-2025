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

--database event LOG ON trigger
create table hr_event_audit
(
    event_type varchar2(20),
    logon_date date,
    logon_time varchar2(15),
    logof_date date,
    logof_time varchar2(15)
);

--trigger
create or replace trigger hr_lgon_audit
after logon on schema
begin
    insert into hr_event_audit values(
        ora_sysevent,
        sysdate,
        to_char(sysdate, 'hh24:mi:ss'),
        null,
        null
    );
    commit;
end;

select * from hr_event_audit;

DISC;

CONN hr/hr;

--log off trigger
create or replace trigger log_off_audit
before logoff on schema
begin
    insert into hr_event_audit values(
        ora_sysevent,
        null,
        null,
        sysdate,
        to_char(sysdate, 'hh24:mi:ss')
    );
commit;
end;

select * from hr_event_audit;

create or replace trigger db_logof_audit
before logoff on database
begin
    insert into db_event_audit values(
        user,
        ora_sysevent,
        null,
        null,
        sysdate,
        to_char(sysdate, 'hh24:mi:ss')
    );
commit;
end;


--INSTEAD OF trigger
--we can control the default behavior of Insert, Update
--Delete and Merge operations on VIEWS but not on TABLES

--table 1
create table trainer
(
    full_name varchar2(20)
);
--table 2
create table subject
(
    subject_name varchar2(20)
);

insert into trainer values ('ibrahim johar');
insert into subject values ('oracle');

create view custom_view as
select full_name, subject_name from trainer, subject;

--not changable right now -> will give error
insert into custom_view values ('ibrahim', 'java');

--instead of trigger
create or replace trigger tr_io_insert
instead of insert on custom_view
for each row
begin
    insert into trainer (full_name) values (:new.full_name);
    insert into subject (subject_name) values(:new.subject_name);
end;

--Trigger TR_IO_INSERT compiled

--lets try inserting again
insert into custom_view values ('ibrahim', 'java');

--output: 1 row inserted.

select * from trainer;

--instead of UPDATE trigger
create or replace trigger io_update
instead of update on custom_view
for each row
begin
    update trainer set full_name = :new.full_name
    where full_name = :old.full_name;
    
    update subject set subject_name = :new.subject_name
    where subject_name = :old.subject_name;
end;

--instead of DELETE trigger
create or replace trigger io_delete
instead of delete on custom_view
for each row
begin
    delete from trainer where full_name = :old.full_name;
    delete from subject where subject_name = :old.subject_name;
end;
