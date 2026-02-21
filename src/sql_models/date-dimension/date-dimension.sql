/*
This is a DuckDB script.
*/

drop schema if exists dates cascade;
create schema if not exists dates;

create table dates.calendar (
    date                     date not null primary key,
    period_id                integer not null unique,
    year_month               integer not null,
    year_week                integer not null,
    julian_date              integer not null,
    ordinal_date             integer not null unique,
    year_number              integer not null,
    quarter_number           integer not null,
    month_number             integer not null,
    -- week_number_iso          integer not null,
    -- week_number              integer not null,
    day_of_week_number       integer not null,
    day_of_year_number       integer not null,
    day_name                 varchar not null,
    day_name_abbr            varchar not null,
    month_name               varchar not null,
    month_name_abbr          varchar not null,
    is_month_start           boolean not null,
    is_month_end             boolean not null,
    is_quarter_start         boolean not null,
    is_quarter_end           boolean not null,
    is_year_start            boolean not null,
    is_year_end              boolean not null,
    is_leap_year             boolean not null,
    is_day_weekday           boolean not null,
);

create table dates.bank_holidays (
    division varchar not null,
    title    varchar not null,
    date     date not null references dates.calendar(date),
    notes    varchar not null,
    bunting  boolean not null,
    primary key (division, date)
);

create table dates.daylight_savings (
    region             varchar not null,  /* This may change -- but for now, will stick to the UK/EU */
    year_number        integer not null,
    dst_start_time_utc datetime not null,
    dst_end_time_utc   datetime not null,
    primary key (region, year_number)
);
/*
In the UK:

- DST starts on the last Sunday in March at 01:00 UTC
- DST end on the last Sunday in October at 01:00 UTC

Between these dates and times, the time in the UK is UTC +1 hour

For example, in 2022:

- When local standard time was about to reach
    Sunday, 27 March 2022, 01:00:00 clocks were turned forward 1 hour to
    Sunday, 27 March 2022, 02:00:00 local daylight time instead.

- When local daylight time was about to reach
    Sunday, 30 October 2022, 02:00:00 clocks were turned backward 1 hour to
    Sunday, 30 October 2022, 01:00:00 local standard time instead.

Sources:

    - https://en.wikipedia.org/wiki/Daylight_saving_time_by_country
    - https://www.timeanddate.com/time/change/uk
*/


------------------------------------------------------------------------
------------------------------------------------------------------------

/* calendar */
insert or ignore into dates.calendar
    select
        date_::date as "date",
        strftime("date", '%Y%m%d')::integer as period_id,
        strftime("date", '%Y%m')::integer as year_month,
        extract('yearweek' from "date")::integer as year_week,
        strftime("date", '%j')::integer as julian_date,
        strftime("date", '%Y%j')::integer as ordinal_date,
        extract('year' from "date")::integer as year_number,
        extract('quarter' from "date")::integer as quarter_number,
        extract('month' from "date")::integer as month_number,

        /* Which of these should we use? */
        -- extract('week' from "date")::integer,
        -- strftime("date", '%W')::integer,
        -- strftime("date", '%U')::integer,

        extract('dayofweek' from "date")::integer as day_of_week_number,
        extract('dayofyear' from "date")::integer as day_of_year_number,
        dayname("date") as day_name,
        dayname("date")[:3] as day_name_abbr,
        monthname("date") as month_name,
        monthname("date")[:3] as month_name_abbr,
        "date" = date_trunc('month', "date") as is_month_start,
        "date" = date_trunc('month', "date") + interval '1 month' - interval '1 day' as is_month_end,
        "date" = date_trunc('quarter', "date") as is_quarter_start,
        "date" = date_trunc('quarter', "date") + interval '3 months' - interval '1 day' as is_quarter_end,
        "date" = date_trunc('year', "date") as is_year_start,
        "date" = date_trunc('year', "date") + interval '1 year' - interval '1 day' as is_year_end,
        year_number % 4 = 0 as is_leap_year,
        extract('dow' from "date") between 1 and 5 as is_day_weekday,
    from generate_series('1980-01-01'::date, '2079-12-31'::date, interval '1 day') as gen(date_)
;

/* bank holidays */
insert or ignore into dates.bank_holidays (division, title, date, notes, bunting)
    select
        division,
        unnest(events.events, recursive:=true)
    from (
        unpivot 'https://www.gov.uk/bank-holidays.json'
        on "england-and-wales", "scotland", "northern-ireland"
        into
            name division
            value events
    )
;

/* daylight savings */
insert or ignore into dates.daylight_savings
    select
        'UK/EU' as region,
        year_number,
        max(if(month_number = 3,  "date", '1900-01-01') || ' 01:00:00') as dst_start_time_utc,
        max(if(month_number = 10, "date", '1900-01-01') || ' 01:00:00') as dst_end_time_utc
    from dates.calendar
    where day_name = 'Sunday'
    group by year_number
    order by year_number
;
