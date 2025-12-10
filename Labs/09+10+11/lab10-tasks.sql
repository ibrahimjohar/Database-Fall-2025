--ibrahim johar - 23K-0074 - BAI-5A
--lab10 - tasks

--q1
create table bank_accounts (
    account_no varchar2(10) primary key,
    holder_name varchar2(50),
    balance number
);

insert into bank_accounts values ('x1', 'hamza', 45000);
insert into bank_accounts values ('x2', 'rehman', 32000);
insert into bank_accounts values ('x3', 'zahra', 38000);

commit;

--deduct from x1
update bank_accounts
set balance = balance - 4000
where account_no = 'x1';

--credit x2
update bank_accounts
set balance = balance + 4000
where account_no = 'x2';

--accidental update to x3
update bank_accounts
set balance = balance - 2500
where account_no = 'x3';

rollback;
select * from bank_accounts;

--q2
create table inventory (
    item_id number primary key,
    item_name varchar2(50),
    quantity number
);

insert into inventory values (10, 'stapler', 75);
insert into inventory values (11, 'tape', 120);
insert into inventory values (12, 'folders', 95);
insert into inventory values (13, 'eraser', 200);

commit;

update inventory
set quantity = quantity - 8
where item_id = 10;

savepoint sp1;

update inventory
set quantity = quantity - 15
where item_id = 11;

savepoint sp2;

update inventory
set quantity = quantity - 4
where item_id = 12;

rollback to sp1;

commit;

--q3
create table fees (
    student_id number primary key,
    name varchar2(50),
    amount_paid number,
    total_fee number
);

insert into fees values (21, 'maheen', 12000, 40000);
insert into fees values (22, 'sajjad', 15000, 40000);
insert into fees values (23, 'ayman', 18000, 40000);

commit;

--correct update
update fees
set amount_paid = amount_paid + 3000
where student_id = 21;

savepoint halfway;

--incorrect update
update fees
set amount_paid = amount_paid + 3000
where student_id = 22;

rollback to halfway;

commit;

--q4
create table products (
    product_id     number primary key,
    product_name   varchar2(50),
    stock          number
);

create table orders (
    order_id number primary key,
    product_id number,
    quantity number
);

insert into products values (101, 'monitor', 30);
insert into products values (102, 'mouse', 60);

commit;

--reduce stock for product101
update products
set stock = stock - 3
where product_id = 101;

--create order
insert into orders values (5001, 101, 3);

--mistake (deleting a prod)
delete from products
where product_id = 102;

rollback;

--correct 2nd attempt
update products
set stock = stock - 3
where product_id = 101;

insert into orders values (5002, 101, 3);

commit;

--q5
create table employees (
    emp_id number primary key,
    emp_name varchar2(50),
    salary number
);

insert into employees values (201, 'ridha', 52000);
insert into employees values (202, 'ammar', 54000);
insert into employees values (203, 'hina', 51000);
insert into employees values (204, 'murtaza', 50000);
insert into employees values (205, 'sana', 56000);

commit;

-- raise salary for emp 201
update employees
set salary = salary + 1500
where emp_id = 201;

savepoint a1;

-- raise salary for emp 202
update employees
set salary = salary + 1500
where emp_id = 202;

savepoint b1;

--raise salary for emp203 (that will be undone)
update employees
set salary = salary + 1500
where emp_id = 203;

rollback to a1;

commit;
