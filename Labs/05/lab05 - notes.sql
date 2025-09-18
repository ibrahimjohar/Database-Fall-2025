select * from students;
select * from departments;
insert into students values(1, 'ali khan', 'ali@gmail.com', 21, 60000, 'karachi', 1);

create table faculty(
id int primary key,
name varchar(20)
);
select * from faculty;
insert into faculty values(1, 'Miss fareeha');
insert into faculty values(2, 'miss aqsa');
insert into faculty values(3, 'miss aisha');

alter table students add (f_id int, foreign key(f_id), REFERENCES faculty(id));
update students set f_id = 1 where id in(2);

select s.* from students cross join faculty;

select s.* , f.name as faculty_name from students s
cross join
faculty f;

select s.* , f.* from students s
full outer join
faculty f
on
s,f_id = f.id
;


