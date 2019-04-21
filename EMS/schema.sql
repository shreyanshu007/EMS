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

CREATE TABLE person(
    person_id SERIAL PRIMARY KEY,
    name VARCHAR(20),
    email VARCHAR(30),
    password VARCHAR(30),
    role VARCHAR(20),
    leave Int
);

INSERT INTO person(name, email, password, role, leave) VALUES ('Shreyanshu Shekhar','shreyanshushekhar007@gmail.com', 'Shekhar123#', 'faculty', 21);
INSERT INTO person(name, email, password, role, leave) VALUES ('admin','admin@admin', 'asdf', 'admin', 0);


CREATE TABLE faculty_department (
    dept_name VARCHAR(20) PRIMARY KEY
);

CREATE TABLE staff_department (
    dept_name VARCHAR(20) PRIMARY KEY
);

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

CREATE TABLE director(
    month SMALLINT,
    YEAR INT,
    faculty_id INT,
    PRIMARY KEY (month,year),
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id),
    FOREIGN KEY (month,year) REFERENCES calendar (month,year)
);

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