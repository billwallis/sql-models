
/*
    Calculate the total working hours between two dates.

    Assuming 08:30 to 17:30 working hours.

    TODO: Convert to DuckDB syntax and make an actual UDF.
*/
WITH
    raw_data AS (
        SELECT
            column1 AS from_date,
            column2 AS to_date
        FROM (VALUES
            ('2022-07-25 12:30:00', '2022-07-25 19:30:00'),
            ('2022-07-25 12:30:00', '2022-07-27 13:30:00'),
            ('2022-07-25 12:30:00', '2022-08-01 13:30:00'),
            ('2021-08-23 23:15:27', '2021-08-23 23:15:27')
        )
    ),
    calcs AS (
        SELECT
            from_date,
            to_date,
            IIF(DATE(from_date) = DATE(to_date),
                MAX(0, MIN(to_date, UNIXEPOCH(STRFTIME('%Y-%m-%d 17:30:00', to_date))) - UNIXEPOCH(from_date)),
                MAX(0, UNIXEPOCH(STRFTIME('%Y-%m-%d 17:30:00', from_date)) - UNIXEPOCH(from_date))
            ) AS part_1,  /* Working minutes on first day */
            (
                SELECT COUNT(*)
                FROM dates.calendar
                WHERE day_name NOT IN ('Saturday', 'Sunday')
                  AND full_date > DATE(from_date)
                  AND full_date < DATE(to_date)
            ) AS part_2, /* Working days between dates */
            IIF(DATE(from_date) = DATE(to_date),
                0,  /* Already calculated in part 1 */
                MAX(0, UNIXEPOCH(to_date) - UNIXEPOCH(STRFTIME('%Y-%m-%d 08:30:00', to_date)))
            ) AS part_3  /* Working minutes on last day */
        FROM raw_data
    )

SELECT
    from_date,
    to_date,
    part_1,
    part_2,
    part_3,
    (part_1 + 60 * 8 * part_2 + part_3) AS total_working_minutes,
    (part_1 + 60 * 8 * part_2 + part_3)/60.0 AS total_working_hours
FROM calcs
;
