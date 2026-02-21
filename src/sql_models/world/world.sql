/*
    Data source:

        https://github.com/dr5hn/countries-states-cities-database/

    Run this script with DuckDB
*/

drop schema if exists world cascade;
create schema world;
use world;

create or replace table cities as
    from 'https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/refs/tags/v2.6/csv/cities.csv'
;
create or replace table countries as
    from 'https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/refs/tags/v2.6/csv/countries.csv'
;
create or replace table regions as
    from 'https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/refs/tags/v2.6/csv/regions.csv'
;
create or replace table states as
    from 'https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/refs/tags/v2.6/csv/states.csv'
;
create or replace table subregions as
    from 'https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/refs/tags/v2.6/csv/subregions.csv'
;
-- create or replace table world as
--     from 'https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/refs/tags/v2.6/csv/world.csv'
-- ;
