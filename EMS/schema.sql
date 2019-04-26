DO $$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = current_schema()) LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END $$;

------------------
CREATE TABLE calendar(
    month SMALLINT,
    year INT,
    bonus DECIMAL(4,2) default 0.0,
    PRIMARY KEY (month,year)
);

----------------------
CREATE TABLE role(
    role_id SERIAL PRIMARY KEY,
    role VARCHAR(40)

);

-----------------------
CREATE TABLE cfti(
    grade VARCHAR(40),
    experience INT,
    salary DECIMAL(10,2),
    PRIMARY KEY (grade,experience)
);


---------------------------

CREATE TABLE person(
    person_id SERIAL PRIMARY KEY,
    name VARCHAR(40),
    email VARCHAR(30),
    password VARCHAR(30),
    grade VARCHAR(40),
    experience INT,
    leaves INT,
    role_id INT REFERENCES role(role_id),
    special_role_id INT REFERENCES role(role_id) DEFAULT NULL,
    FOREIGN KEY (grade, experience) REFERENCES cfti (grade, experience)
);

CREATE TABLE faculty_department (
    dept_name VARCHAR(40) PRIMARY KEY
);

CREATE TABLE staff_department (
    dept_name VARCHAR(40) PRIMARY KEY
);

CREATE TABLE faculty (
    faculty_id INT PRIMARY KEY,
    dept_name VARCHAR(40),
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
    dept_name VARCHAR(40) REFERENCES staff_department (dept_name),
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
    dept_name VARCHAR(40),
    PRIMARY KEY (dept_name,month,year),
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id),
    FOREIGN KEY (month,year) REFERENCES calendar(month,year)
);

CREATE TABLE assistant_registrar(
    staff_id INT REFERENCES staff(staff_id),
    month SMALLINT,
    year INT,
    dept_name VARCHAR(40) REFERENCES staff_department(dept_name),
    PRIMARY KEY (dept_name,month,year),
    FOREIGN KEY (month,year) REFERENCES calendar(month,year)
);

CREATE TABLE dept_secretary(
    staff_id INT REFERENCES staff(staff_id),
    month SMALLINT,
    year INT,
    dept_name VARCHAR(40) REFERENCES faculty_department(dept_name),
    PRIMARY KEY (dept_name,month,year),
    FOREIGN KEY (month,year) REFERENCES calendar (month,year)
);

CREATE TABLE affairs(
    name VARCHAR(40) PRIMARY KEY
);

CREATE TABLE dean_secretary(
    name VARCHAR(40) REFERENCES affairs(name),
    month SMALLINT,
    year INT,
    staff_id INT REFERENCES staff(staff_id),
    PRIMARY KEY (name,month,year),
    FOREIGN KEY (month,year) REFERENCES calendar(month,year)
);

CREATE TABLE dean(
    dean INT REFERENCES faculty (faculty_id),
    associate_dean INT REFERENCES faculty (faculty_id),
    name VARCHAR(40) REFERENCES affairs(name),
    month SMALLINT,
    year INT,
    FOREIGN KEY (month,year) REFERENCES calendar(month,year),
    PRIMARY KEY (name,month,year)
);

CREATE TABLE project (
    name VARCHAR(40) PRIMARY KEY,
    main_PI INT,
    FOREIGN KEY (main_PI) REFERENCES faculty (faculty_id)
);


CREATE TABLE co_PI(
    name VARCHAR(40) REFERENCES project(name),
    co_pi INT REFERENCES faculty(faculty_id),
    PRIMARY KEY (name,co_pi)
);

CREATE TABLE project_associate (
    associate_id INT REFERENCES person(person_id),
    PRIMARY KEY (associate_id)
);

CREATE TABLE project_pa (
    name VARCHAR(40) REFERENCES project (name),
    faculty_id INT REFERENCES faculty (faculty_id),
    associate_id INT REFERENCES project_associate (associate_id),
    PRIMARY KEY (name,faculty_id)
);
------------------------------------------
CREATE TABLE pa_salary(
    associate_id INT REFERENCES project_associate(associate_id),
    month SMALLINT,
    year INT,
    salary DECIMAL(10,2),
    PRIMARY KEY (associate_id,month,year),
    FOREIGN KEY (month,year) REFERENCES calendar (month,year)
);

---------------------------------
CREATE TABLE pay_slip(
    person_id INT REFERENCES person(person_id),
    grade VARCHAR(40),
    experience INT,
    month SMALLINT,
    year INT,
    salary DECIMAL(10,2),
    signer INT REFERENCES staff(staff_id),
    approved INT DEFAULT 0,
    FOREIGN KEY (grade,experience) REFERENCES cfti(grade,experience),
    PRIMARY KEY (person_id,month,year)
);

-- CREATE TABLE staff_cfti(
--     grade VARCHAR(40),
--     experience INT,
--     salary INT,
--     PRIMARY KEY (grade,experience)
-- );

-- CREATE TABLE staff_pay_slip(
--     staff_id INT REFERENCES staff(staff_id),
--     grade VARCHAR(40),
--     experience INT,
--     month SMALLINT,
--     year INT,
--     salary INT,
--     signer INT REFERENCES staff(staff_id),
--     FOREIGN KEY (grade,experience) REFERENCES cfti(grade,experience),
--     PRIMARY KEY (staff_id,month,year)
-- );


-----------------faculty leaves---------------------

CREATE TABLE faculty_leave_path(
    from_id INT REFERENCES role(role_id),
    to_id INT REFERENCES faculty_leave_path(from_id),
    PRIMARY KEY (from_id)
);


-- current_stage will be null when application is done
CREATE TABLE faculty_leave_application(
    leave_id SERIAL PRIMARY KEY,
    start_date DATE,
    number_of_days INT,
    current_stage INT REFERENCES faculty_leave_path(from_id),
    faculty_id INT REFERENCES faculty(faculty_id),
    reason VARCHAR(40)
);

CREATE TABLE old_faculty_applications(
    leave_id INT REFERENCES faculty_leave_application(leave_id),
    comment VARCHAR(40),
    approved INT,
    person_id INT REFERENCES person(person_id),
    time_comment TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (leave_id,person_id) 
);

CREATE TABLE allowed_leaves(
    leaves INT
);

----------------Staff  leaves------------------------

CREATE TABLE staff_leave_path(
    from_id INT REFERENCES role(role_id),
    to_id INT REFERENCES staff_leave_path(from_id),
    PRIMARY KEY (from_id)
);


-- current_stage will be null when application is done
CREATE TABLE staff_leave_application(
    leave_id SERIAL PRIMARY KEY,
    start_date DATE,
    number_of_days INT,
    current_stage INT REFERENCES staff_leave_path(from_id),
    staff_id INT REFERENCES staff(staff_id),
    reason VARCHAR(40)
);

CREATE TABLE old_staff_applications(
    leave_id INT REFERENCES staff_leave_application(leave_id),
    comment VARCHAR(40),
    approved INT,
    person_id INT REFERENCES person(person_id),
    time_comment TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (leave_id,person_id) 
);

-----------------Project Assosiate Leave-----------------

------------------------------------------
CREATE OR REPLACE FUNCTION generate_pay_slip(monthv INT, yearv INT, person_idv INT, staff_idv INT)
    RETURNS RECORD  AS $var$
    DECLARE
        gradev VARCHAR(40);
        salaryv DECIMAL(10,2);
        bonusv DECIMAL(4,2);
        experiencev INT;
        actual_salaryv DECIMAL(10,2);

    BEGIN
        SELECT grade INTO gradev FROM person WHERE person_id = person_idv;
        SELECT experience INTO experiencev FROM person where person_id=person_idv;
        SELECT salary INTO salaryv from cfti where grade=gradev and experience=experiencev;
        SELECT bonus INTO bonusv from calendar where month=monthv and year=yearv;
        actual_salaryv = salaryv + salaryv*(bonusv/100);
        insert into pay_slip(person_id,grade,experience,month,year,salary,signer) VALUES(person_idv,gradev,experiencev,monthv,yearv,actual_salaryv,staff_idv);
    RETURN NULL;
    END;
    $var$ language plpgsql; 


CREATE OR REPLACE FUNCTION fill_calendar(start_y INT, end_y INT)
    RETURNS RECORD AS $$
    DECLARE
        iter INT;
        y INT;

    BEGIN
        y=start_y;
        LOOP
            iter=1;
            LOOP
                INSERT INTO calendar (month,year) VALUES (iter,y);
                iter = iter + 1;
                EXIT WHEN iter = 13;
            END LOOP;
            y = y + 1;
            EXIT WHEN y>end_y;
        END LOOP;  
    RETURN NULL;
    END;
    $$  language plpgsql;      

--------------------------------------------------
-- CREATE TRIGGER hod_insert_trigger  
    -- AFTER INSERT ON hod  
    -- FOR EACH ROW    
    -- DECLARE  
    --    dept_name VARCHAR(40);
    --    prev_hod_person_id INT;
    --    hod_role_id INT;  
    -- BEGIN  
    --     select dept_name INTO dept_name from hod where hod.faculty_id=NEW.faculty_id;
    --     select role_id into hod_role_id from role where role.role='hod';
    --     select faculty_id into prev_hod_person_id from faculty where faculty_id in (select person_id from person where special_role_id=hod_role_id) and dept_name=dept_name;
    --     update person set special_role_id=NULL where person_id=prev_hod_person_id;
    --     update person set special_role_id=hod_role_id where person_id=NEW.faculty_id;
    --     update hod set month=month(CURRENT_TIMESTAMP),year=year(CURRENT_TIMESTAMP) where faculty_id=NEW.faculty_id;

    -- END;
------------------------------------------------------
CREATE OR REPLACE FUNCTION hod_role_update() RETURNS TRIGGER AS $hod$

   DECLARE  
       dept_namev VARCHAR(40);
       prev_hod_person_idv INT;
       hod_role_idv INT;
       monthv SMALLINT;
       yearv INT;  
    BEGIN  
        select hod.dept_name INTO dept_namev from hod where hod.faculty_id=NEW.faculty_id;
        select role.role_id into hod_role_idv from role where role.role='hod';
        select faculty.faculty_id into prev_hod_person_idv from faculty where faculty_id in (select person_id from person where special_role_id=hod_role_idv) and faculty.dept_name=dept_namev;
        update person set special_role_id=NULL where person.person_id=prev_hod_person_idv;
        update person set special_role_id=hod_role_idv where person.person_id=NEW.faculty_id;
        SELECT date_part('month',CURRENT_TIMESTAMP) INTO monthv;
        SELECT date_part('year',CURRENT_TIMESTAMP) INTO yearv;
        RETURN NEW;
    END;
$hod$ LANGUAGE plpgsql;
---------------------------------------------------------
CREATE TRIGGER hod_insert_trigger
    AFTER INSERT ON hod
    FOR EACH ROW
    EXECUTE PROCEDURE hod_role_update();

----------------------------------------------------------
CREATE OR REPLACE FUNCTION assistant_registrar_role_update() RETURNS TRIGGER AS $assistant_registrar$

   DECLARE  
       dept_namev VARCHAR(40);
       prev_assistant_registrar_person_idv INT;
       assistant_registrar_role_idv INT; 
       monthv SMALLINT;
       yearv INT; 
    BEGIN  
        select dept_name INTO dept_namev from assistant_registrar where assistant_registrar.staff_id=NEW.staff_id;
        select role_id into assistant_registrar_role_idv from role where role.role='assistant_registrar';
        select staff_id into prev_assistant_registrar_person_idv from staff where staff_id in (select person_id from person where special_role_id=assistant_registrar_role_idv) and dept_name=dept_namev;
        update person set special_role_id=NULL where person_id=prev_assistant_registrar_person_idv;
        update person set special_role_id=assistant_registrar_role_idv where person_id=NEW.staff_id;
        SELECT date_part('month',CURRENT_TIMESTAMP) INTO monthv;
        SELECT date_part('year',CURRENT_TIMESTAMP) INTO yearv;
        RETURN NEW;
    END;
$assistant_registrar$ LANGUAGE plpgsql;
-----------------------------------------------------------
CREATE TRIGGER assistant_registrar_insert_trigger
    AFTER INSERT ON assistant_registrar
    FOR EACH ROW
    EXECUTE PROCEDURE assistant_registrar_role_update();
-----------------------------------------------------------


--------------------Leave part-----------------------------

CREATE OR REPLACE FUNCTION faculty_check_leaves_left_procedure() RETURNS TRIGGER AS $$
    
    DECLARE
        person_idv INT;
        avail_leavesv INT;
        permit_leavesv INT;
    BEGIN
        select faculty_id into person_idv from faculty_leave_application where faculty_leave_application.leave_id = NEW.leave_id;
        select leaves into avail_leavesv from person where person_id=person_idv;
        select leaves into permit_leavesv from allowed_leaves;
        if avail_leavesv-NEW.number_of_days <  -permit_leavesv then
            insert into old_faculty_applications(leave_id,comment,approved,person_id) VALUES(NEW.leave_id,'Rejected. Cannot borrow more leaves',0,NEW.faculty_id);
            update faculty_leave_application set current_stage=NULL where leave_id = NEW.leave_id;
        else
            PERFORM faculty_get_next_leave_stage(NEW.leave_id,NEW.reason,1);
        end if;
    RETURN NEW;    
    END;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER faculty_check_leaves_left_trigger
    AFTER INSERT ON faculty_leave_application
    FOR EACH ROW 
    EXECUTE PROCEDURE faculty_check_leaves_left_procedure();

-- CREATE TRIGGER faculty_update_leave
--     AFTER UPDATE ON old_faculty_applications
--     FOR EACH ROW 

CREATE OR REPLACE FUNCTION faculty_get_next_leave_stage(leave_idv INT, commentv VARCHAR(40), approvedv INT) 
    RETURNS TEXT AS $$
    DECLARE
        current_stagev INT;
        next_stagev INT;
        current_stage_person_idv INT;
        role_namev VARCHAR(40);
        faculty_idv INT;
        dept_namev VARCHAR(40);
        temp_role_idv INT;
        leaves_nov INT;
        est_staffv INT;
    BEGIN
        select current_stage into current_stagev from faculty_leave_application where faculty_leave_application.leave_id = leave_idv;
        select to_id into next_stagev from faculty_leave_path where from_id=current_stagev;
        select role into role_namev from role where role_id=current_stagev;
        select faculty_id into faculty_idv from faculty_leave_application where leave_id=leave_idv;
        select dept_name into dept_namev from faculty where faculty_id=faculty_idv;
        RAISE NOTICE '%',role_namev;
        if role_namev='hod' then
            select faculty_id into current_stage_person_idv 
            from faculty inner join person on faculty.faculty_id = person.person_id 
            where person.special_role_id = current_stagev and faculty.dept_name = dept_namev;
        elsif role_namev='faculty' then
            current_stage_person_idv = faculty_idv;
        elsif role_namev='E_staff' then      
            select staff_id INTO current_stage_person_idv from staff INNER JOIN  person  on person_id=staff_id
            where dept_name='Establishment' and person.special_role_id is NULL ORDER BY random() LIMIT 1;
        elsif role_namev='E_assistant_registrar' then      
            select staff_id INTO current_stage_person_idv from staff INNER JOIN  person  on person_id=staff_id
            where dept_name='Establishment' and person.special_role_id in (select role_id from role where role.role='assistant_registrar');    
        else
            select person_id into current_stage_person_idv from person where person.special_role_id=current_stagev;
        end if;




        insert into old_faculty_applications(leave_id, comment, approved, person_id) values(leave_idv,commentv,approvedv,current_stage_person_idv); 
        if approvedv = 0 then
            
            update faculty_leave_application set current_stage = NULL where faculty_leave_application.leave_id=leave_idv;     
        else
            update faculty_leave_application set current_stage=next_stagev where faculty_leave_application.leave_id=leave_idv;
        end if;

        if next_stagev is NULL and approvedv=1 then
            select number_of_days into leaves_nov from faculty_leave_application where faculty_leave_application.leave_id=leave_idv; 
            update person set leaves=leaves-leaves_nov WHERE person_id=faculty_idv;
        END IF;        

    RETURN NULL;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION faculty_retrieve_leaves(person_idv INT) RETURNS RECORDS AS $$
    
    DECLARE
    
    BEGIN

    END

---------------------------------Leave staff part----------------------------------------------
--old_staff_application
CREATE OR REPLACE FUNCTION staff_check_leaves_left_procedure() RETURNS TRIGGER AS $$
    
    DECLARE
        person_idv INT;
        avail_leavesv INT;
        permit_leavesv INT;
    BEGIN
        select staff_id into person_idv from staff_leave_application where staff_leave_application.leave_id = NEW.leave_id;
        select leaves into avail_leavesv from person where person_id=person_idv;
        select leaves into permit_leavesv from allowed_leaves;
        if avail_leavesv-NEW.number_of_days <  -permit_leavesv then
            insert into old_staff_applications(leave_id,comment,approved,person_id) VALUES(NEW.leave_id,'Rejected. Cannot borrow more leaves',0,NEW.staff_id);
            update staff_leave_application set current_stage=NULL where leave_id = NEW.leave_id;
        else
            PERFORM staff_get_next_leave_stage(NEW.leave_id,NEW.reason,1);
        end if;
    RETURN NEW;    
    END;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER staff_check_leaves_left_trigger
    AFTER INSERT ON staff_leave_application
    FOR EACH ROW 
    EXECUTE PROCEDURE staff_check_leaves_left_procedure();

-- CREATE TRIGGER faculty_update_leave
--     AFTER UPDATE ON old_faculty_applications
--     FOR EACH ROW 

CREATE OR REPLACE FUNCTION staff_get_next_leave_stage(leave_idv INT, commentv VARCHAR(40), approvedv INT) 
    RETURNS TEXT AS $$
    DECLARE
        current_stagev INT;
        next_stagev INT;
        current_stage_person_idv INT;
        role_namev VARCHAR(40);
        staff_idv INT;
        dept_namev VARCHAR(40);
        temp_role_idv INT;
        leaves_nov INT;
    BEGIN
        select current_stage into current_stagev from staff_leave_application where staff_leave_application.leave_id = leave_idv;
        select to_id into next_stagev from staff_leave_path where from_id=current_stagev;
        select role into role_namev from role where role_id=current_stagev;
        select staff_id into staff_idv from staff_leave_application where leave_id=leave_idv;
        select dept_name into dept_namev from staff where staff_id=staff_idv;
        if role_namev='assistant_registrar' then
            select staff_id into current_stage_person_idv 
            from staff inner join person on staff.faculty_id = person.person_id 
            where person.special_role_id = current_stagev and staff.dept_name = dept_namev;
        elsif role_namev='staff' then
            current_stage_person_idv = staff_idv;
        elsif role_namev='E_staff' then      
            select staff_id INTO current_stage_person_idv from staff INNER JOIN  person  on person_id=staff_id
            where dept_name='Establishment' and person.special_role_id is NULL ORDER BY random() LIMIT 1;
        elsif role_namev='E_assistant_registrar' then      
            select staff_id INTO current_stage_person_idv from staff INNER JOIN  person  on person_id=staff_id
            where dept_name='Establishment' and person.special_role_id in (select role_id from role where role.role='assistant_registrar');    
        else
            select person_id into current_stage_person_idv from person where person.special_role_id=current_stagev;
        end if;




        insert into old_staff_applications(leave_id, comment, approved, person_id) values(leave_idv,commentv,approvedv,current_stage_person_idv); 
        if approvedv = 0 then
            
            update staff_leave_application set current_stage = NULL where staff_leave_application.leave_id=leave_idv;     
        else
            update staff_leave_application set current_stage=next_stagev where staff_leave_application.leave_id=leave_idv;
        end if;

        if next_stagev is NULL and approvedv=1 then
            select number_of_days into leaves_nov from staff_leave_application where staff_leave_application.leave_id=leave_idv; 
            update person set leaves=leaves-leaves_nov WHERE person_id=staff_idv;
        END IF;        

    RETURN NULL;
    END;
    $$ LANGUAGE plpgsql; 








