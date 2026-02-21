/*
This human resources data has come from:

- https://www.w3resource.com/sql-exercises/employee-database-exercise/index.php

All credit goes to the original authors of the data.
*/

drop table if exists department;
drop table if exists employees;
drop table if exists salary_grade;


create table department (
    dep_id       integer not null primary key,
    dep_name     text not null,
    dep_location text not null
);

create table employees (
    emp_id     integer not null primary key,
    emp_name   text not null,
    job_name   text not null,
    manager_id integer references employees (emp_id),
    hire_date  date not null,
    salary     real not null,
    commission real,
    dep_id     integer not null references department (dep_id)
);

create table salary_grade (
    grade   integer not null primary key,
    min_sal integer not null,
    max_sal integer not null
);


------------------------------------------------------------------------
------------------------------------------------------------------------

insert into department (dep_id, dep_name, dep_location)
values
    (1001, 'Finance',    'Sydney'),
    (2001, 'Audit',      'Melbourne'),
    (3001, 'Marketing',  'Perth'),
    (4001, 'Production', 'Brisbane')
;


insert into employees (emp_id, emp_name, job_name, manager_id, hire_date, salary, commission, dep_id)
values
    (63679, 'Sandrine', 'Clerk',     69062, '1990-12-18',  900, null, 2001),
    (64989, 'Adelyn',   'Salesman',  66928, '1991-02-20', 1700,  400, 3001),
    (65271, 'Wade',     'Salesman',  66928, '1991-02-22', 1350,  600, 3001),
    (65646, 'Jonas',    'Manager',   68319, '1991-04-02', 2957, null, 2001),
    (66564, 'Madden',   'Salesman',  66928, '1991-09-28', 1350, 1500, 3001),
    (66928, 'Blaze',    'Manager',   68319, '1991-05-01', 2750, null, 3001),
    (67832, 'Clare',    'Manager',   68319, '1991-06-09', 2550, null, 1001),
    (67858, 'Scarlet',  'Analyst',   65646, '1997-04-19', 3100, null, 2001),
    (68319, 'Kayling',  'President',  null, '1991-11-18', 6000, null, 1001),
    (68454, 'Tucker',   'Salesman',  66928, '1991-09-08', 1600,    0, 3001),
    (68736, 'Adnres',   'Clerk',     67858, '1997-05-23', 1200, null, 2001),
    (69000, 'Julius',   'Clerk',     66928, '1991-12-03', 1050, null, 3001),
    (69062, 'Frank',    'Analyst',   65646, '1991-12-03', 3100, null, 2001),
    (69324, 'Marker',   'Clerk',     67832, '1992-01-23', 1400, null, 1001)
;


insert into salary_grade (grade, min_sal, max_sal)
values
    (1,  800, 1300),
    (2, 1301, 1500),
    (3, 1501, 2100),
    (4, 2101, 3100),
    (5, 3101, 9999)
;
