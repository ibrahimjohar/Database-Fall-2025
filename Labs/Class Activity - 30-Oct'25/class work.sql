create table students (
student_id int primary_key,
student_name varchar(20),
h_pay int,
y_pay int
);

select * from students;
insert into students(student_id, student_name) values(4, 'hamza');

insert into students(student_id, student_name) values(3, 'sana');
set serveroutput on ;

--dml trigger
--before insert
create or replace trigger insert_data
before insert on students
for each row
begin
IF :NEW.h_pay IS NULL THEN
:NEW.hay := 250;
end if;
end;

--before update
create or replace trigger update_Salary
before update on students
for each row 
begin
:NEW.y_pay := :NEW.h_pay*1920;
end;
/
UPDATE students set h_pay = 200 where student_id = 3;
--delete
create or replace trigger prevent_admin
before delete on students
for each row
begin 
IF :OLD.student_name = 'admin'
then
RAISE_APPLICATION_ERROR(-2000, 'you cannot delete admin record.');
end if;
end;
/
delete from students where student_name = 'admin';
--after insert
create table student_logs(
student_id int,
student_name varchar(20),
inserted_by varchar(20),
inserted_on date
);

create or replace trigger after_ins
after insert on student for each row
begin
insert into student_logs(student_id, student_name, inserted_by, inserted_on) values
(:NEW.student_id , :NEW.student_name, SYS_CONTEXT('USERENV','SESSION_UNDER'), SYSDATE);
end;
/

insert into students(student_id, student_name, h_pay) values(5, 'aqsa', 300);
select * from STUDENT_LOGS;
--ddl triggers
--prevent table to drop
create or replace trigger prevent_tables
before drop ON database
begin
RAISE_APPLICATION_ERROR (
    num => -2000,
    msg => 'Cannot drop object');
end;
/
DROP table students_logs;
--ddl 2
create table schema_audit(
ddl_date DATE,
ddl_user varchar2(15),
object_created varchar2(15),
object_name varchar2(15),
ddl_operation varchar2(15)
);

select * from schema_audit;
set serveroutput on;
create or replace trigger hr_audit_tr
after ddl on schema 
begin
insert into schema_audit values (sysdate, sys_context('USERENV', 'CURRENT_USER'), ora_dict_obj_type, ora_dict_obj_name, ora_sysevent);
end;
/

);




