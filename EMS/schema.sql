-- CREATE DATABASE EMS;
-- CREATE USER EMSuser WITH PASSWORD 'password';
-- ALTER ROLE EMSuser SET client_encoding TO 'utf8';
-- ALTER ROLE EMSuser SET default_transaction_isolation TO 'read committed';
-- ALTER ROLE EMSuser SET timezone TO 'UTC';
-- GRANT ALL PRIVILEGES ON DATABASE EMS TO EMSuser;
-- \l
-- \c ems;
-- \d
GRANT ALL PRIVILEGES ON DATABASE EMS TO EMSuser;
GRANT ALL ON ALL TABLES IN SCHEMA public to emsuser;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to emsuser;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to emsuser;





DO $$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = current_schema()) LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END $$;


CREATE TABLE calendar(
    month SMALLINT,
    year INT,
    PRIMARY KEY (month,year)
);


INSERT INTO calendar(month, year) VALUES (1, 2017);
INSERT INTO calendar(month, year) VALUES (2, 2017);
INSERT INTO calendar(month, year) VALUES (3, 2017);
INSERT INTO calendar(month, year) VALUES (4, 2017);
INSERT INTO calendar(month, year) VALUES (5, 2017);
INSERT INTO calendar(month, year) VALUES (6, 2017);
INSERT INTO calendar(month, year) VALUES (7, 2017);
INSERT INTO calendar(month, year) VALUES (8, 2017);
INSERT INTO calendar(month, year) VALUES (9, 2017);
INSERT INTO calendar(month, year) VALUES (10, 2017);
INSERT INTO calendar(month, year) VALUES (11, 2017);
INSERT INTO calendar(month, year) VALUES (12, 2017);
INSERT INTO calendar(month, year) VALUES (1, 2018);
INSERT INTO calendar(month, year) VALUES (2, 2018);
INSERT INTO calendar(month, year) VALUES (3, 2018);
INSERT INTO calendar(month, year) VALUES (4, 2018);
INSERT INTO calendar(month, year) VALUES (5, 2018);
INSERT INTO calendar(month, year) VALUES (6, 2018);
INSERT INTO calendar(month, year) VALUES (7, 2018);
INSERT INTO calendar(month, year) VALUES (8, 2018);
INSERT INTO calendar(month, year) VALUES (9, 2018);
INSERT INTO calendar(month, year) VALUES (10, 2018);
INSERT INTO calendar(month, year) VALUES (11, 2018);
INSERT INTO calendar(month, year) VALUES (12, 2018);


CREATE TABLE person(
    person_id SERIAL PRIMARY KEY,
    name VARCHAR(20),
    email VARCHAR(30),
    password VARCHAR(30),
    role VARCHAR(20),
    leave Int
);

INSERT INTO person(name, email, password, role, leave) VALUES ('Shreyanshu Shekhar','shekhar@gmail.com', 'asdf', 'faculty', 20);
INSERT INTO person(name, email, password, role, leave) VALUES ('Mattela Nithish','mattela@gmail.com', 'asdf', 'faculty', 22);
INSERT INTO person(name, email, password, role, leave) VALUES ('Shailendra Gupta','gupta@gmail.com', 'asdf', 'faculty', 23);
INSERT INTO person(name, email, password, role, leave) VALUES ('Abhinav Jindal','jindal@gmail.com', 'asdf', 'faculty', 24);


INSERT INTO person(name, email, password, role, leave) VALUES ('Sameer Arora','sameer@gmail.com', 'asdf', 'staff', 25);
INSERT INTO person(name, email, password, role, leave) VALUES ('Ram Krishna','krishna@gmail.com', 'asdf', 'staff', 26);
INSERT INTO person(name, email, password, role, leave) VALUES ('Harshavardhan Thakur','harsh@gmail.com', 'asdf', 'staff', 27);

INSERT INTO person(name, email, password, role, leave) VALUES ('admin','admin@admin', 'asdf', 'admin', 0);


CREATE TABLE faculty_department (
    dept_name VARCHAR(20) PRIMARY KEY
);


INSERT INTO faculty_department(dept_name) VALUES ('CSE');
INSERT INTO faculty_department(dept_name) VALUES ('EE');
INSERT INTO faculty_department(dept_name) VALUES ('ME');
INSERT INTO faculty_department(dept_name) VALUES ('CE');

CREATE TABLE staff_department (
    dept_name VARCHAR(20) PRIMARY KEY
);

INSERT INTO staff_department(dept_name) VALUES ('Accounts-Finance');
INSERT INTO staff_department(dept_name) VALUES ('Academics');
INSERT INTO staff_department(dept_name) VALUES ('Stores-Purchase');
INSERT INTO staff_department(dept_name) VALUES ('Establishment');


CREATE TABLE faculty (
    faculty_id INT PRIMARY KEY,
    dept_name varchar(20),
    DOJ_month SMALLINT,
    DOJ_year INT,
    DOE_month SMALLINT,
    DOE_year INT,
    FOREIGN KEY (DOJ_month,DOJ_year) REFERENCES calendar (month,year),
    FOREIGN KEY (DOE_month,DOE_year) REFERENCES calendar (month,year),
    FOREIGN KEY (faculty_id) REFERENCES person(person_id),
    FOREIGN KEY (dept_name) REFERENCES faculty_department(dept_name)
);


INSERT INTO faculty (faculty_id, dept_name, DOJ_month, DOJ_year) VALUES (4, 'CSE', 1, 2018);
INSERT INTO faculty (faculty_id, dept_name, DOJ_month, DOJ_year) VALUES (5, 'EE', 4, 2018);
INSERT INTO faculty (faculty_id, dept_name, DOJ_month, DOJ_year) VALUES (6, 'ME', 8, 2018);
INSERT INTO faculty (faculty_id, dept_name, DOJ_month, DOJ_year) VALUES (7, 'CE', 12, 2018);


CREATE TABLE staff(
    staff_id INT PRIMARY KEY,
    dept_name VARCHAR(20) REFERENCES staff_department (dept_name),
    DOJ_month SMALLINT,
    DOJ_year INT,
    DOE_month SMALLINT,
    DOE_year INT,
    FOREIGN KEY (DOJ_month,DOJ_year) REFERENCES calendar (month,year),
    FOREIGN KEY (DOE_month,DOE_year) REFERENCES calendar (month,year),
    FOREIGN KEY (staff_id) REFERENCES person(person_id)
);


INSERT INTO staff (staff_id, dept_name, DOJ_month, DOJ_year) VALUES (8, 'Establishment', 1, 2017);
INSERT INTO staff (staff_id, dept_name, DOJ_month, DOJ_year) VALUES (9, 'Academics', 5, 2017);
INSERT INTO staff (staff_id, dept_name, DOJ_month, DOJ_year) VALUES (10, 'Accounts-Finance', 8, 2017);


CREATE TABLE director(
    month SMALLINT,
    YEAR INT,
    faculty_id INT,
    PRIMARY KEY (month,year),
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id),
    FOREIGN KEY (month,year) REFERENCES calendar (month,year)
);

INSERT INTO director (month, YEAR, faculty_id) VALUES (9, 2018, 4);

CREATE TABLE hod(
    faculty_id INT,
    month SMALLINT,
    year INT,
    dept_name varchar(20),
    PRIMARY KEY (dept_name,month,year),
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id),
    FOREIGN KEY (month,year) REFERENCES calendar(month,year)
);

CREATE TABLE assistant_registrar(
    staff_id INT REFERENCES staff(staff_id),
    month SMALLINT,
    year INT,
    dept_name VARCHAR(20) REFERENCES staff_department(dept_name),
    PRIMARY KEY (dept_name,month,year),
    FOREIGN KEY (month,year) REFERENCES calendar(month,year)
);

CREATE TABLE dept_secretary(
    staff_id INT REFERENCES staff(staff_id),
    month SMALLINT,
    year INT,
    dept_name VARCHAR(20) REFERENCES faculty_department(dept_name),
    PRIMARY KEY (dept_name,month,year),
    FOREIGN KEY (month,year) REFERENCES calendar (month,year)
);

CREATE TABLE affairs(
    name VARCHAR(20) PRIMARY KEY
);

CREATE TABLE dean_secretary(
    name VARCHAR(20) REFERENCES affairs(name),
    month SMALLINT,
    year INT,
    staff_id INT REFERENCES staff(staff_id),
    PRIMARY KEY (name,month,year),
    FOREIGN KEY (month,year) REFERENCES calendar(month,year)
);

CREATE TABLE dean(
    dean INT REFERENCES faculty (faculty_id),
    associate_dean INT REFERENCES faculty (faculty_id),
    name VARCHAR(20) REFERENCES affairs(name),
    month SMALLINT,
    year INT,
    FOREIGN KEY (month,year) REFERENCES calendar(month,year),
    PRIMARY KEY (name,month,year)
);

CREATE TABLE project (
    name varchar(20) PRIMARY KEY,
    main_PI INT,
    FOREIGN KEY (main_PI) REFERENCES faculty (faculty_id)
);


CREATE TABLE co_PI(
    name VARCHAR(20) REFERENCES project(name),
    co_pi INT REFERENCES faculty(faculty_id),
    PRIMARY KEY (name,co_pi)
);

CREATE TABLE project_associate (
    associate_id INT REFERENCES person(person_id),
    PRIMARY KEY (associate_id)
);

CREATE TABLE project_pa (
    name VARCHAR(20) REFERENCES project (name),
    faculty_id INT REFERENCES faculty (faculty_id),
    associate_id INT REFERENCES project_associate (associate_id),
    PRIMARY KEY (name,faculty_id)
);

CREATE TABLE pa_salary(
    associate_id INT REFERENCES project_associate(associate_id),
    month SMALLINT,
    year INT,
    salary INT,
    PRIMARY KEY (associate_id,month,year),
    FOREIGN KEY (month,year) REFERENCES calendar (month,year)
);

CREATE TABLE faculty_cfti(
    grade VARCHAR(20),
    experience INT,
    salary INT,
    PRIMARY KEY (grade,experience)
);

INSERT INTO faculty_cfti (grade, experience, salary) VALUES ('g1', 1, 10000);
INSERT INTO faculty_cfti (grade, experience, salary) VALUES ('g1', 2, 20000);
INSERT INTO faculty_cfti (grade, experience, salary) VALUES ('g1', 3, 30000);
INSERT INTO faculty_cfti (grade, experience, salary) VALUES ('g2', 1, 40000);
INSERT INTO faculty_cfti (grade, experience, salary) VALUES ('g2', 2, 50000);
INSERT INTO faculty_cfti (grade, experience, salary) VALUES ('g2', 3, 60000);
INSERT INTO faculty_cfti (grade, experience, salary) VALUES ('g3', 1, 70000);
INSERT INTO faculty_cfti (grade, experience, salary) VALUES ('g3', 2, 80000);
INSERT INTO faculty_cfti (grade, experience, salary) VALUES ('g3', 3, 90000);

CREATE TABLE faculty_pay_slip(
    faculty_id INT REFERENCES faculty(faculty_id),
    grade VARCHAR(20),
    experience INT,
    month SMALLINT,
    year INT,
    salary INT,
    signer INT REFERENCES staff(staff_id),
    FOREIGN KEY (grade,experience) REFERENCES faculty_cfti(grade,experience),
    PRIMARY KEY (faculty_id,month,year)
);

INSERT INTO faculty_pay_slip (faculty_id, grade, experience, month, year, salary, signer) VALUES (7, 'g1', 1, 1, 2017, 10000, 10);
INSERT INTO faculty_pay_slip (faculty_id, grade, experience, month, year, salary, signer) VALUES (7, 'g1', 2, 2, 2017, 20000, 10);
INSERT INTO faculty_pay_slip (faculty_id, grade, experience, month, year, salary, signer) VALUES (7, 'g1', 3, 3, 2017, 30000, 10);
INSERT INTO faculty_pay_slip (faculty_id, grade, experience, month, year, salary, signer) VALUES (7, 'g2', 1, 4, 2017, 40000, 10);
INSERT INTO faculty_pay_slip (faculty_id, grade, experience, month, year, salary, signer) VALUES (7, 'g2', 2, 5, 2017, 50000, 10);
INSERT INTO faculty_pay_slip (faculty_id, grade, experience, month, year, salary, signer) VALUES (7, 'g2', 3, 6, 2017, 60000, 10);

CREATE TABLE staff_cfti(
    grade VARCHAR(20),
    experience INT,
    salary INT,
    PRIMARY KEY (grade,experience)
);

CREATE TABLE staff_pay_slip(
    staff_id INT REFERENCES staff(staff_id),
    grade VARCHAR(20),
    experience INT,
    month SMALLINT,
    year INT,
    salary INT,
    signer INT REFERENCES staff(staff_id),
    FOREIGN KEY (grade,experience) REFERENCES staff_cfti(grade,experience),
    PRIMARY KEY (staff_id,month,year)
);