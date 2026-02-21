/*
https://www.w3resource.com/sql-exercises/soccer-database-exercise/subqueries-exercises-on-soccer-database.php
*/





/*
    Q8.
*/

/* Accounting for potential ties */
WITH
    matches AS (
        SELECT
            match_details.*,
            soccer_country.country_name,
            ROW_NUMBER() OVER(
                PARTITION BY match_no
                ORDER BY team_id
            ) AS row_num
        FROM match_details
            INNER JOIN soccer_country
                ON  match_details.team_id = soccer_country.country_id
                AND soccer_country.country_name IN ('Portugal', 'Hungary')
    ),
    ranked AS (
        SELECT
            goal_details.goal_id,
            goal_details.goal_time,
            player_mast.player_name,
            RANK() OVER(ORDER BY goal_details.goal_time DESC) AS goal_rank
        FROM goal_details
            INNER JOIN player_mast USING(player_id)
        WHERE match_no = (SELECT match_no FROM matches WHERE row_num = 2)
    )

SELECT player_name
FROM ranked
WHERE goal_rank = 1
;


/*
    Q13.
*/
WITH counts AS (
    SELECT
        playing_club,
        COUNT(*) AS volume
    FROM player_mast
    GROUP BY playing_club
)

SELECT playing_club, volume
FROM counts
WHERE counts.volume = (
    SELECT MAX(volume) FROM counts
)
;


/*
    Q14.
*/
SELECT
    player_mast.player_name,
    player_mast.jersey_no
FROM (
    SELECT
        player_id,
        RANK() OVER(ORDER BY match_no, goal_time) AS goal_rank
    FROM goal_details
    WHERE goal_type = 'P'
) AS base
    LEFT JOIN player_mast USING(player_id)
WHERE goal_rank = 1
;


/*
    Q15.
*/
SELECT
    player_mast.player_name,
    player_mast.jersey_no,
    soccer_country.country_name
FROM (
    SELECT
        player_id,
        RANK() OVER(ORDER BY match_no, goal_time) AS goal_rank
    FROM goal_details
    WHERE goal_type = 'P'
) AS base
    LEFT JOIN player_mast USING(player_id)
    LEFT JOIN soccer_country
        ON player_mast.team_id = soccer_country.country_id
WHERE goal_rank = 1
;


/*
    Q16.
*/
WITH
    matches AS (
        SELECT match_details.match_no
        FROM match_details
            INNER JOIN soccer_country
                ON  match_details.team_id = soccer_country.country_id
                AND soccer_country.country_name IN ('Germany', 'Italy')
        GROUP BY match_details.match_no
            HAVING COUNT(*) = 2
    )

SELECT player_mast.player_name
FROM penalty_gk
    INNER JOIN player_mast
        ON penalty_gk.player_gk = player_mast.player_id
WHERE True
    AND penalty_gk.match_no = (SELECT match_no FROM matches)
    AND penalty_gk.team_id = (SELECT country_id FROM soccer_country WHERE country_name = 'Italy')
;


/*
    Q17.
*/
SELECT
    COUNT(*)
FROM goal_details
    INNER JOIN soccer_country
        ON  goal_details.team_id = soccer_country.country_id
        AND soccer_country.country_name = 'Germany'
;


/*
    Q18.
*/
SELECT
    player_mast.player_name,
    player_mast.jersey_no,
    player_mast.playing_club
FROM player_mast
    INNER JOIN soccer_country
        ON  player_mast.team_id = soccer_country.country_id
        AND soccer_country.country_name = 'England'
WHERE player_mast.posi_to_play = 'GK'
;


/*
    Q19.
*/
SELECT
    player_mast.player_name,
    player_mast.jersey_no,
    player_mast.posi_to_play,
    player_mast.age
FROM player_mast
    INNER JOIN soccer_country
        ON  player_mast.team_id = soccer_country.country_id
        AND soccer_country.country_name = 'England'
WHERE player_mast.playing_club = 'Liverpool'
ORDER BY player_mast.jersey_no
;


/*
    Q20.
*/
WITH
    sf_match AS (
        SELECT DISTINCT
            match_no,
            DENSE_RANK() OVER(ORDER BY match_no) AS match_rank
        FROM match_details
        WHERE play_stage = 'S'
    ),
    goal AS (
        SELECT
            player_id,
            goal_time,
            goal_half,
            RANK() OVER(ORDER BY goal_time DESC) AS goal_rank
        FROM goal_details
        WHERE match_no = (
            SELECT match_no FROM sf_match WHERE match_rank = 2
        )
    )

SELECT
    player_mast.player_name,
    goal.goal_time,
    goal.goal_half,
    soccer_country.country_name
FROM player_mast
    INNER JOIN goal
        ON  player_mast.player_id = goal.player_id
        AND goal.goal_rank = 1
    INNER JOIN soccer_country
        ON player_mast.team_id = soccer_country.country_id
;


/*
    Q21.
*/
SELECT player_mast.player_name
FROM match_details
    INNER JOIN match_captain USING(match_no, team_id)
    INNER JOIN player_mast
        ON match_captain.player_captain = player_mast.player_id
WHERE True
    AND match_details.play_stage = 'F'
    AND match_details.win_lose = 'W'
;
