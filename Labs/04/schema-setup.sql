CREATE TABLE department (
dept_id NUMBER PRIMARY KEY,
dept_name VARCHAR2(50)
);

CREATE TABLE students (
std_id NUMBER PRIMARY KEY,
student_name VARCHAR2(100),
dept_id NUMBER,
gpa NUMBER(3,2),
fee NUMBER(12,2),
CONSTRAINT fk_students_dept FOREIGN KEY (dept_id) REFERENCES department(dept_id) ON DELETE SET NULL
);

TABLE faculty (
faculty_id NUMBER PRIMARY KEY,
faculty_name VARCHAR2(100),
dept_id NUMBER,
salary NUMBER(12,2),
joining_date DATE,
CONSTRAINT fk_faculty_dept FOREIGN KEY (dept_id) REFERENCES department(dept_id) ON DELETE SET NULL
);


CREATE TABLE courses (
course_id NUMBER PRIMARY KEY,
course_name VARCHAR2(100),
dept_id NUMBER,
faculty_id NUMBER,
CONSTRAINT fk_courses_dept FOREIGN KEY (dept_id) REFERENCES department(dept_id) ON DELETE SET NULL,
CONSTRAINT fk_courses_fac FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id) ON DELETE SET NULL
);


CREATE TABLE enrollment (
std_id NUMBER,
course_id NUMBER,
CONSTRAINT pk_enrollment PRIMARY KEY (std_id, course_id),
CONSTRAINT fk_enr_students FOREIGN KEY (std_id) REFERENCES students(std_id) ON DELETE CASCADE,
CONSTRAINT fk_enr_courses FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

CREATE TABLE Retired_Faculty (
faculty_id NUMBER PRIMARY KEY,
faculty_name VARCHAR2(100),
INSERT INTO enrollment VALUES (10,3);

INSERT INTO department VALUES (1, 'CS');
INSERT INTO department VALUES (2, 'EE');
INSERT INTO department VALUES (3, 'FT');

INSERT INTO faculty VALUES (101, 'George Khan', 1, 150000, TO_DATE('01-01-2000','DD-MM-YYYY'));
INSERT INTO faculty VALUES (102, 'Ayesha R', 1, 140000, TO_DATE('15-03-2003','DD-MM-YYYY'));
INSERT INTO faculty VALUES (103, 'Bilal A', 1, 135000, TO_DATE('20-06-2005','DD-MM-YYYY'));
INSERT INTO faculty VALUES (104, 'Sana M', 1, 125000, TO_DATE('11-07-2008','DD-MM-YYYY'));
INSERT INTO faculty VALUES (105, 'Umar S', 1, 122000, TO_DATE('09-09-2010','DD-MM-YYYY'));
INSERT INTO faculty VALUES (106, 'Haris Sh', 1, 118000, TO_DATE('05-05-2012','DD-MM-YYYY'));

INSERT INTO faculty VALUES (201, 'Noor A', 2, 95000, TO_DATE('22-02-2009','DD-MM-YYYY'));
INSERT INTO faculty VALUES (202, 'Zainab Q', 3, 85000, TO_DATE('12-12-2011','DD-MM-YYYY'));
INSERT INTO faculty VALUES (203, 'Imran Ali', 2, 90000, TO_DATE('01-06-2014','DD-MM-YYYY'));

INSERT INTO students VALUES (1, 'Ali', 1, 3.80, 220000);
INSERT INTO students VALUES (2, 'Bob', 1, 3.20, 200000);
INSERT INTO students VALUES (3, 'Charlie', 1, 3.60, 210000);
INSERT INTO students VALUES (4, 'Ibrahim Johar', 1, 3.75, 195000);
INSERT INTO students VALUES (5, 'Aisha Malik', 1, 3.45, 180000);
INSERT INTO students VALUES (6, 'Frank', 1, 3.95, 220000);

INSERT INTO students VALUES (7, 'David', 2, 3.50, 70000);
INSERT INTO students VALUES (8, 'Eve', 2, 2.90, 40000);
INSERT INTO students VALUES (9, 'Zara', 3, 3.25, 95000);
INSERT INTO students VALUES (10,'Hamza', 3, 2.80, 42000);

INSERT INTO courses VALUES (1, 'DBMS', 1, 101);
INSERT INTO courses VALUES (2, 'Networks', 1, 101);
INSERT INTO courses VALUES (3, 'Circuits', 2, 201);
INSERT INTO courses VALUES (4, 'Marketing', 3, 202);
INSERT INTO courses VALUES (5, 'AI', 1, 102);
INSERT INTO courses VALUES (6, 'Ethics', 3, NULL);

INSERT INTO enrollment VALUES (2,1);
INSERT INTO enrollment VALUES (2,5);
INSERT INTO enrollment VALUES (3,1);
INSERT INTO enrollment VALUES (3,2);
INSERT INTO enrollment VALUES (4,1);
INSERT INTO enrollment VALUES (4,3);
INSERT INTO enrollment VALUES (4,2);
INSERT INTO enrollment VALUES (4,5);
INSERT INTO enrollment VALUES (5,4);
INSERT INTO enrollment VALUES (7,3);
INSERT INTO enrollment VALUES (8,4);
INSERT INTO enrollment VALUES (9,4);
INSERT INTO enrollment VALUES (10,3);
