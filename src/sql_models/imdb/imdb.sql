/*
    Data source:

        https://developer.imdb.com/non-commercial-datasets/

    Run this script with DuckDB
*/
select version();

drop schema if exists imdb_raw cascade;
create schema imdb_raw;
use imdb_raw;


create or replace table imdb_raw.title_akas as
    from read_csv(
        'https://datasets.imdbws.com/title.akas.tsv.gz',
        quote='',
        nullstr='\N'
    )
;

create or replace table imdb_raw.title_basics as
    from read_csv(
        'https://datasets.imdbws.com/title.basics.tsv.gz',
        quote='',
        nullstr='\N'
    )
;

create or replace table imdb_raw.title_crew as
    from read_csv(
        'https://datasets.imdbws.com/title.crew.tsv.gz',
        quote='',
        nullstr='\N'
    )
;

create or replace table imdb_raw.title_episode as
    from read_csv(
        'https://datasets.imdbws.com/title.episode.tsv.gz',
        quote='',
        nullstr='\N'
    )
;

create or replace table imdb_raw.title_principals as
    from read_csv(
        'https://datasets.imdbws.com/title.principals.tsv.gz',
        quote='',
        nullstr='\N'
    )
;

create or replace table imdb_raw.title_ratings as
    from read_csv(
        'https://datasets.imdbws.com/title.ratings.tsv.gz',
        quote='',
        nullstr='\N'
    )
;

create or replace table imdb_raw.name_basics as
    from read_csv(
        'https://datasets.imdbws.com/name.basics.tsv.gz',
        quote='',
        nullstr='\N'
    )
;
