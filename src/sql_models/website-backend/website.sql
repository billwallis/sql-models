
drop table if exists events;
drop table if exists google_auth;
drop table if exists password_auth;
drop table if exists users;


create table users (
    user_id integer primary key,
    username varchar,
    last_review_datetime datetime
);
insert into users (user_id, username, last_review_datetime)
values
    (1, 'alex', '2023-12-15 03:20:00'),
    (2, 'blake', '2024-01-24 03:30:00'),
    (3, 'charlie', '2024-02-01 04:10:00'),
    (4, 'dylan', '2024-02-04 02:50:00')
;


create table google_auth (
    user_id integer primary key references users(user_id),
    last_accessed datetime,
    google_token varchar
);
insert into google_auth (user_id, last_accessed, google_token)
values
    (1, '2024-01-03 03:05:00', '1db8b82e-ff18-471a-8a06-5283cfe00225'),
    (3, '2024-01-31 21:00:00', '12482a5f-b277-470a-93fc-4953037275d6')
;


create table password_auth (
    user_id integer primary key references users(user_id),
    last_accessed datetime,
    email varchar,
    password varchar
);
insert into password_auth (user_id, last_accessed, email, password)
values
    (1, '2024-01-23 03:00:00', 'alex1@example.com', 'password123'),
    (2, '2024-01-24 22:00:00', '8lake@example.com', 'P@$$w0rd'),
    (4, '2023-12-30 17:00:00', 'dy101@example.com', 'qwerty')
;


create table events (
    event_id integer primary key,
    user_id integer references users(user_id),
    event_datetime datetime,
    event_type varchar
);
insert into events (event_id, user_id, event_datetime, event_type)
values
    (1, 1, '2024-01-01 11:00:00', 'login'),
    (2, 1, '2024-01-01 12:00:00', 'logout'),
    (3, 1, '2024-01-03 03:00:00', 'login failed'),
    (4, 1, '2024-01-03 03:05:00', 'login'),
    (5, 2, '2024-01-03 10:00:00', 'login'),
    (6, 2, '2024-01-03 15:00:00', 'logout'),
    (7, 1, '2024-01-03 23:00:00', 'logout'),
    (8, 2, '2024-01-04 22:00:00', 'login failed'),
    (9, 2, '2024-01-04 22:05:00', 'login'),
    (10, 3, '2024-01-05 20:00:00', 'login'),
    (11, 3, '2024-01-06 04:00:00', 'logout'),
    (12, 2, '2024-01-09 15:00:00', 'logout'),
    (13, 3, '2024-01-11 21:00:00', 'login'),
    (14, 1, '2024-01-12 12:00:00', 'login'),
    (15, 1, '2024-01-12 13:00:00', 'logout'),
    (16, 1, '2024-01-13 03:00:00', 'login'),
    (17, 2, '2024-01-13 10:00:00', 'login failed'),
    (18, 2, '2024-01-13 10:05:00', 'login'),
    (19, 2, '2024-01-13 15:00:00', 'logout'),
    (20, 1, '2024-01-13 23:00:00', 'logout'),
    (21, 2, '2024-01-14 22:00:00', 'login'),
    (22, 3, '2024-01-15 20:00:00', 'login'),
    (23, 3, '2024-01-16 04:00:00', 'logout'),
    (24, 2, '2024-01-19 15:00:00', 'logout'),
    (25, 3, '2024-01-21 21:00:00', 'login'),
    (26, 1, '2024-01-22 12:00:00', 'login failed'),
    (27, 1, '2024-01-22 12:05:00', 'password reset'),
    (28, 1, '2024-01-22 12:10:00', 'login'),
    (29, 1, '2024-01-22 13:00:00', 'logout'),
    (30, 1, '2024-01-23 03:00:00', 'login'),
    (31, 2, '2024-01-23 10:00:00', 'login'),
    (32, 2, '2024-01-23 15:00:00', 'logout'),
    (33, 1, '2024-01-23 23:00:00', 'logout'),
    (34, 2, '2024-01-24 22:00:00', 'login'),
    (35, 3, '2024-01-25 20:00:00', 'login'),
    (36, 3, '2024-01-26 04:00:00', 'logout'),
    (37, 2, '2024-01-29 15:00:00', 'logout'),
    (38, 3, '2024-01-31 21:00:00', 'login')
;
