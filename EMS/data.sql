-- Possible roles

-- faculty,hod,dean(all given in question),associate_dean,director,department_secretary,dean_secretary

-- staff,assistant_registrar,E_staff,E_assistant_registrar,registrar, 




INSERT INTO role (role) VALUES ('faculty');
INSERT INTO role (role) VALUES ('staff');
INSERT INTO role (role) VALUES ('hod');
INSERT INTO role (role) VALUES ('assistant_registrar');
INSERT INTO role (role) VALUES ('E_staff');
INSERT INTO role (role) VALUES ('E_assistant_registrar');
INSERT INTO role (role) VALUES ('registrar');
INSERT INTO role (role) VALUES ('director');



SELECT fill_calendar(2000,2020);

INSERT INTO allowed_leaves(leaves) values (10);

INSERT INTO cfti (grade, experience, salary) VALUES ('g1', 1, 10000);
INSERT INTO cfti (grade, experience, salary) VALUES ('g1', 2, 20000);
INSERT INTO cfti (grade, experience, salary) VALUES ('g1', 3, 30000);
INSERT INTO cfti (grade, experience, salary) VALUES ('g2', 1, 40000);
INSERT INTO cfti (grade, experience, salary) VALUES ('g2', 2, 50000);
INSERT INTO cfti (grade, experience, salary) VALUES ('g2', 3, 60000);
INSERT INTO cfti (grade, experience, salary) VALUES ('g3', 1, 70000);
INSERT INTO cfti (grade, experience, salary) VALUES ('g3', 2, 80000);
INSERT INTO cfti (grade, experience, salary) VALUES ('g3', 3, 90000);



INSERT INTO person(name, email, password, grade, experience, leaves, role_id) VALUES ('Shreyanshu Shekhar','shekhar@gmail.com', 'asdf', 'g2', 3, 17, 1);
INSERT INTO person(name, email, password, grade, experience, leaves, role_id) VALUES ('Mattela Nithish','mattela@gmail.com', 'asdf', 'g2', 3, 17, 1);
INSERT INTO person(name, email, password, grade, experience, leaves, role_id) VALUES ('Shailendra Gupta','gupta@gmail.com', 'asdf', 'g2', 3, 17, 1);
INSERT INTO person(name, email, password, grade, experience, leaves, role_id) VALUES ('Abhinav Jindal','jindal@gmail.com', 'asdf', 'g2', 3, 17, 1);


INSERT INTO person(name, email, password, grade, experience, leaves, role_id) VALUES ('Sameer Arora','sameer@gmail.com', 'asdf', 'g2', 3, 17, 2);
INSERT INTO person(name, email, password, grade, experience, leaves, role_id) VALUES ('Ram Krishna','krishna@gmail.com', 'asdf', 'g2', 3, 17, 2);
INSERT INTO person(name, email, password, grade, experience, leaves, role_id) VALUES ('Harshavardhan Thakur','harsh@gmail.com', 'asdf', 'g2', 3, 17, 2);


INSERT INTO person(name, email, password, grade, experience, leaves, role_id) VALUES ('p1','p1@gmail.com', 'asdf', 'g2', 3, 17, 2);
INSERT INTO person(name, email, password, grade, experience, leaves, role_id) VALUES ('p2','p2@gmail.com', 'asdf', 'g2', 3, 17, 2);
INSERT INTO person(name, email, password, grade, experience, leaves, role_id) VALUES ('p3','p3@gmail.com', 'asdf', 'g2', 3, 17, 2);

INSERT INTO person(name, email, password, grade, experience, leaves, role_id) VALUES ('p4','p4@gmail.com', 'asdf', 'g2', 3, 17, 2);
INSERT INTO person(name, email, password, grade, experience, leaves, role_id) VALUES ('p5','p5@gmail.com', 'asdf', 'g2', 3, 17, 2);
INSERT INTO person(name, email, password, grade, experience, leaves, role_id) VALUES ('p6','p6@gmail.com', 'asdf', 'g2', 3, 17, 2);

INSERT INTO person(name, email, password, grade, experience, leaves, role_id) VALUES ('p7','p7@gmail.com', 'asdf', 'g2', 3, 17, 2);
INSERT INTO person(name, email, password, grade, experience, leaves, role_id) VALUES ('p8','p8@gmail.com', 'asdf', 'g2', 3, 17, 2);
INSERT INTO person(name, email, password, grade, experience, leaves, role_id) VALUES ('p9','p9@gmail.com', 'asdf', 'g2', 3, 17, 2);


INSERT INTO person(name, email, password, grade, experience, leaves, role_id) VALUES ('p10','p10@gmail.com', 'asdf', 'g2', 3, 17, 2);
INSERT INTO person(name, email, password, grade, experience, leaves, role_id) VALUES ('p11','p11@gmail.com', 'asdf', 'g2', 3, 17, 2);
INSERT INTO person(name, email, password, grade, experience, leaves, role_id) VALUES ('p12','p12@gmail.com', 'asdf', 'g2', 3, 17, 2);




INSERT INTO faculty_department(dept_name) VALUES ('CSE');
INSERT INTO faculty_department(dept_name) VALUES ('EE');
INSERT INTO faculty_department(dept_name) VALUES ('ME');
INSERT INTO faculty_department(dept_name) VALUES ('CE');



INSERT INTO staff_department(dept_name) VALUES ('Accounts-Finance');
INSERT INTO staff_department(dept_name) VALUES ('Academics');
INSERT INTO staff_department(dept_name) VALUES ('Stores-Purchase');
INSERT INTO staff_department(dept_name) VALUES ('Establishment');



INSERT INTO faculty (faculty_id, dept_name, DOJ_month, DOJ_year) VALUES (1, 'CSE', 1, 2018);
INSERT INTO faculty (faculty_id, dept_name, DOJ_month, DOJ_year) VALUES (2, 'EE', 4, 2018);
INSERT INTO faculty (faculty_id, dept_name, DOJ_month, DOJ_year) VALUES (3, 'ME', 8, 2018);
INSERT INTO faculty (faculty_id, dept_name, DOJ_month, DOJ_year) VALUES (4, 'CE', 12, 2018);
INSERT INTO faculty (faculty_id, dept_name, DOJ_month, DOJ_year) VALUES (8, 'CSE', 1, 2018);
INSERT INTO faculty (faculty_id, dept_name, DOJ_month, DOJ_year) VALUES (9, 'CSE', 4, 2018);
INSERT INTO faculty (faculty_id, dept_name, DOJ_month, DOJ_year) VALUES (10, 'CSE', 8, 2018);


INSERT INTO staff (staff_id, dept_name, DOJ_month, DOJ_year) VALUES (5, 'Establishment', 1, 2017);
INSERT INTO staff (staff_id, dept_name, DOJ_month, DOJ_year) VALUES (6, 'Academics', 5, 2017);
INSERT INTO staff (staff_id, dept_name, DOJ_month, DOJ_year) VALUES (7, 'Accounts-Finance', 8, 2017);
INSERT INTO staff (staff_id, dept_name, DOJ_month, DOJ_year) VALUES (11, 'Establishment', 1, 2017);
INSERT INTO staff (staff_id, dept_name, DOJ_month, DOJ_year) VALUES (12, 'Establishment', 5, 2017);


INSERT INTO hod(faculty_id,month,year,dept_name) VALUES(8,10,2018,'CSE');
INSERT INTO assistant_registrar(staff_id,month,year,dept_name) VALUES(11,10,2018,'Establishment');
INSERT INTO faculty_leave_path (from_id, to_id) VALUES(5,NULL);
INSERT INTO faculty_leave_path (from_id, to_id) VALUES(6,5);
INSERT INTO faculty_leave_path (from_id, to_id) VALUES(3,6);
INSERT INTO faculty_leave_path (from_id, to_id) VALUES(1,3);


--INSERT INTO assistant_registrar(staff_id,month,year,dept_name) VALUES(8, month(CURRENT_TIMESTAMP),year(CURRENT_TIMESTAMP),'CSE')




INSERT INTO pay_slip (person_id, grade, experience, month, year, salary, signer, approved) VALUES (4, 'g1', 1, 1, 2017, 10000, 7, 0);
INSERT INTO pay_slip (person_id, grade, experience, month, year, salary, signer, approved) VALUES (4, 'g1', 2, 2, 2017, 20000, 7, 1);
INSERT INTO pay_slip (person_id, grade, experience, month, year, salary, signer, approved) VALUES (4, 'g1', 3, 3, 2017, 30000, 7, 0);
INSERT INTO pay_slip (person_id, grade, experience, month, year, salary, signer, approved) VALUES (4, 'g2', 1, 4, 2017, 40000, 7, 1);
INSERT INTO pay_slip (person_id, grade, experience, month, year, salary, signer, approved) VALUES (4, 'g2', 2, 5, 2017, 50000, 7, 0);
INSERT INTO pay_slip (person_id, grade, experience, month, year, salary, signer, approved) VALUES (4, 'g2', 3, 6, 2017, 60000, 7, 1);

INSERT INTO pay_slip (person_id, grade, experience, month, year, salary, signer, approved) VALUES (7, 'g2', 3, 6, 2017, 60000, 7, 1);



INSERT INTO faculty_leave_application(start_date,number_of_days,current_stage,faculty_id,reason) VALUES (to_date('12-10-2018','DD-MM-YYYY'),100,1,1,'cscsa');
INSERT INTO faculty_leave_application(start_date,number_of_days,current_stage,faculty_id,reason) VALUES (to_date('12-10-2018','DD-MM-YYYY'),10,1,1,'cscsa');
INSERT INTO faculty_leave_application(start_date,number_of_days,current_stage,faculty_id,reason) VALUES (to_date('20-10-2018','DD-MM-YYYY'),10,1,1,'vvyvuyvyyvysa');
-- select faculty_get_next_leave_stage(2,'fac app'1); 
select faculty_get_next_leave_stage(2,'hod app',1); 
select faculty_get_next_leave_stage(2,'ar app',1); 
select faculty_get_next_leave_stage(2,'staff app',1); 

-- select faculty_get_next_leave_stage(3,'fac app',1); 
select faculty_get_next_leave_stage(3,'hod app',1); 
select faculty_get_next_leave_stage(3,'staff app',0); 
