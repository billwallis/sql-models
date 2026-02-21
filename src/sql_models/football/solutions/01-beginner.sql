/*
https://www.w3resource.com/sql-exercises/soccer-database-exercise/basic-exercises-on-soccer-database.php
*/


/*
    Q1. Count the number of venues for EURO cup 2016. Return number of venues
*/
SELECT COUNT(*) FROM soccer_venue;


/*
    Q2.
*/
SELECT COUNT(DISTINCT team_id) FROM player_mast;

SELECT COUNT(*) FROM soccer_country;

SELECT *
FROM soccer_country
WHERE country_id NOT IN (
    SELECT DISTINCT team_id FROM player_mast
)
;


/*
    Q3.
*/
SELECT COUNT(*) FROM goal_details;


/*
    Q4.
*/
SELECT COUNT(*) FROM match_mast WHERE results = 'WIN';


/*
    Q5.
*/
SELECT COUNT(*) FROM match_mast WHERE results = 'DRAW';


/*
    Q6.
*/
SELECT MIN(play_date) FROM match_mast;


/*
    Q7.
*/
SELECT COUNT(*) FROM goal_details WHERE goal_type = 'O';


/*
    Q8.
*/
SELECT COUNT(*) FROM match_mast WHERE play_stage = 'G' AND results = 'WIN';


/*
    Q9.
*/
SELECT COUNT(DISTINCT match_no) FROM penalty_shootout;


/*
    Q10.
*/
SELECT COUNT(*) FROM match_mast WHERE play_stage = 'R' AND decided_by = 'P';


/*
    Q11.
*/
SELECT match_no, COUNT(*)
FROM goal_details
WHERE goal_schedule = 'NT'
GROUP BY match_no
ORDER BY match_no
;


/*
    Q12.
*/
SELECT
    match_no,
    play_date,
    goal_score
FROM match_mast
WHERE stop1_sec = 0
;


/*
    Q13.
*/
SELECT COUNT(DISTINCT match_no)
FROM match_details
WHERE True
    AND goal_score = 0
    AND play_stage = 'G'
    AND win_lose = 'D'
;


/*
    Q14.
*/
SELECT COUNT(*)
FROM match_details
WHERE True
    AND goal_score = 1
    AND decided_by = 'N'
    AND win_lose = 'W'
;


/*
    Q15.
*/
SELECT COUNT(*) AS player_replaced
FROM player_in_out
WHERE in_out = 'O'
;


/*
    Q16.
*/
SELECT COUNT(*) AS player_replaced
FROM player_in_out
WHERE True
    AND in_out = 'O'
    AND play_schedule = 'NT'
;


/*
    Q17.
*/
SELECT COUNT(*) AS player_replaced
FROM player_in_out
WHERE True
    AND in_out = 'O'
    AND play_schedule = 'ST'
;


/*
    Q18.
*/
SELECT COUNT(*) AS player_replaced
FROM player_in_out
WHERE True
    AND in_out = 'O'
    AND play_half = 1
    AND play_schedule = 'NT'
;


/*
    Q19.
*/
SELECT COUNT(DISTINCT match_no)
FROM match_details
WHERE True
    AND goal_score = 0
    AND win_lose = 'D'
;


/*
    Q20.
*/
SELECT COUNT(*)
FROM player_in_out
WHERE True
    AND in_out = 'O'
    AND play_schedule = 'ET'
;


/*
    Q21.
*/
SELECT
    play_half,
    play_schedule,
    COUNT(*) AS sub_volume
FROM player_in_out
WHERE in_out = 'O'
GROUP BY
    play_half,
    play_schedule
ORDER BY
    play_half,
    play_schedule,
    sub_volume
;


/*
    Q22.
*/
SELECT COUNT(*) AS number_of_penalty_kicks
FROM penalty_shootout
;


/*
    Q23.
*/
SELECT COUNT(*) AS goal_scored_by_penalty_kicks
FROM penalty_shootout
WHERE score_goal = 'Y'
;


/*
    Q24.
*/
SELECT COUNT(*) AS goal_missed_or_saved_by_penalty_kicks
FROM penalty_shootout
WHERE score_goal = 'N'
;


/*
    Q25.
*/
SELECT
    ps.match_no,
    sc.country_name AS team,
    pm.player_name,
    pm.jersey_no,
    ps.score_goal,
    ps.kick_no
FROM penalty_shootout AS ps
    LEFT JOIN soccer_country AS sc
        ON sc.country_id = ps.team_id
    LEFT JOIN player_mast AS pm
        ON ps.player_id = pm.player_id
;


/*
    Q26.
*/
SELECT
    sc.country_name AS team,
    COUNT(*) AS number_of_shots
FROM soccer_country AS sc
    INNER JOIN penalty_shootout AS ps
        ON sc.country_id = ps.team_id
GROUP BY sc.country_name
;

/* Dan's Solution */
SELECT
    sc.country_name AS team,
    COUNT(team_id) AS number_of_shots
FROM soccer_country AS sc
    LEFT JOIN penalty_shootout AS ps
        ON sc.country_id = ps.team_id
GROUP BY sc.country_name
;

/* My Solution */
SELECT
    sc.country_name AS team,
    COALESCE(number_of_shots, 0) AS number_of_shots
FROM soccer_country AS sc
    LEFT JOIN (
        SELECT team_id, COUNT(*) AS number_of_shots
        FROM penalty_shootout
        GROUP BY team_id
    ) AS ps
        ON sc.country_id = ps.team_id
GROUP BY sc.country_name
;


/*
    Q27.
*/
SELECT
    play_half,
    play_schedule,
    COUNT(*) AS number_of_booking
FROM player_booked
WHERE play_schedule = 'NT'
GROUP BY
    play_half,
    play_schedule
;


/*
    Q28.
*/
SELECT COUNT(*)
FROM player_booked
WHERE play_schedule = 'ST'
;


/*
    Q29.
*/
SELECT COUNT(*)
FROM player_booked
WHERE play_schedule = 'ET'
;
