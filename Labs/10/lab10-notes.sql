-- TRANSACTIONS

-- 1. Start Transaction
SET TRANSACTION NAME 'my_transaction';

-- 2. Basic COMMIT / ROLLBACK
UPDATE employees SET salary = salary + 500 WHERE emp_id = 10;
COMMIT;
-- or
ROLLBACK;

-- 3. SAVEPOINTS
SET TRANSACTION NAME 'savepoint_demo';
UPDATE employees SET salary = 9000 WHERE emp_id = 20;
SAVEPOINT sp1;
UPDATE employees SET salary = 12000 WHERE emp_id = 30;
SAVEPOINT sp2;
ROLLBACK TO sp1;
COMMIT;

-- 4. AUTOCOMMIT
SET AUTOCOMMIT ON;
SET AUTOCOMMIT OFF;

-- 5. Locking Demo
-- Session 1:
-- UPDATE worker SET salary = 6000 WHERE worker_id = 1;
-- (Row locked)
-- Session 2:
-- UPDATE worker SET salary = 7000 WHERE worker_id = 1;
-- (Hangs until commit)
-- Session 1:
-- COMMIT;

-- 6. Implicit Commit
-- CREATE TABLE test (...);  -- Auto commit
-- ALTER TABLE test (...);   -- Auto commit
-- GRANT SELECT ON test TO A; -- Auto commit

-- 7. Full Transaction Example (Products + Inventory)

-- Table Setup
CREATE TABLE product (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(50),
    price NUMBER
);

CREATE TABLE inventory (
    inventory_id NUMBER PRIMARY KEY,
    product_id NUMBER REFERENCES product(product_id),
    quantity NUMBER
);

-- Start Transaction
SET TRANSACTION NAME 'product_inventory_transaction';

-- Insert Product
INSERT INTO product VALUES (10, 'USB Cable', 300);
SAVEPOINT product_added;

-- Insert Inventory Entry
INSERT INTO inventory VALUES (100, 10, 50);
SAVEPOINT inventory_added;

-- Deduct Inventory
UPDATE inventory
SET quantity = quantity - 60
WHERE product_id = 10;
SAVEPOINT after_deduction;

-- Handle Errors
-- ROLLBACK TO inventory_added;
-- ROLLBACK TO product_added;
-- ROLLBACK;

-- Finalize
COMMIT;
