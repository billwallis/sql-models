/*
    Slightly modify the IMDb data.

    This takes ages.
*/
select version();

drop schema if exists imdb cascade;
create schema imdb;
use imdb.imdb;


create or replace table title_akas (
    /* a tconst, an alphanumeric unique identifier of the title */
    title_id text,
    /* a number to uniquely identify rows for a given titleId */
    "ordering" int,
    /* the localized title */
    title text,
    /* the region for this version of the title */
    region text,
    /* the language of the title */
    "language" text,
    /* Enumerated set of attributes for this alternative title. One or more of the following: "alternative", "dvd", "festival", "tv", "video", "working", "original", "imdbDisplay". New values may be added in the future without warning */
    types text[],
    /* Additional terms to describe this alternative title, not enumerated */
    attributes text[],
    /* 0: not original title; 1: original title */
    is_original_title boolean,

    primary key (title_id, "ordering"),
);
insert into title_akas
    select
        titleId as title_id,
        "ordering",
        title,
        region,
        "language",
        split(types, ',') as types,
        split(attributes, ',') as attributes,
        (isOriginalTitle = 1) as is_original_title,
    from imdb_raw.title_akas
;

create or replace table title_basics (
    /* alphanumeric unique identifier of the title */
    title_id text primary key,
    /* the type/format of the title (e.g. movie, short, tvseries, tvepisode, video, etc) */
    title_type text,
    /* the more popular title / the title used by the filmmakers on promotional materials at the point of release */
    primary_title text,
    /* original title, in the original language */
    original_title text,
    /* 0: non-adult title; 1: adult title */
    is_adult boolean,
    /* represents the release year of a title. In the case of TV Series, it is the series start year */
    start_year int,
    /* TV Series end year. null for all other title types */
    end_year int,
    /* primary runtime of the title, in minutes */
    runtime_minutes int,
    /* includes up to three genres associated with the title */
    genres text[],
);
insert into title_basics
    select
        tconst as title_id,
        titleType as title_type,
        primaryTitle as primary_title,
        originalTitle as original_title,
        (isAdult = 1) as is_adult,
        startYear as start_year,
        endYear as end_year,
        runtimeMinutes as runtime_minutes,
        split(genres, ',') as genres,
    from imdb_raw.title_basics
;

create or replace table title_crew (
    /* alphanumeric unique identifier of the title */
    title_id text primary key,
    /* director(s) of the given title */
    directors text[],
    /* writer(s) of the given title */
    writers text[],
);
insert into title_crew
    select
        tconst as title_id,
        split(directors, ',') as directors,
        split(writers, ',') as writers,
    from imdb_raw.title_crew
;

create or replace table title_episode (
    /* alphanumeric identifier of episode */
    title_id text primary key,
    /* alphanumeric identifier of the parent TV Series */
    parent_title_id text,
    /* season number the episode belongs to */
    season_number int,
    /* episode number of the tconst in the TV series */
    episode_number int,
);
insert into title_episode
    select
        tconst as title_id,
        parentTconst as parent_title_id,
        seasonNumber as season_number,
        episodeNumber as episode_number,
    from imdb_raw.title_episode
;

create or replace table title_principals (
    /* alphanumeric unique identifier of the title */
    title_id text,
    /* a number to uniquely identify rows for a given titleId */
    "ordering" int,
    /* alphanumeric unique identifier of the name/person */
    person_id text,
    /* the category of job that person was in */
    category text,
    /* the specific job title if applicable, else null */
    job text,
    /* the name of the character played if applicable, else null */
    characters json,

    primary key (title_id, "ordering"),
);
insert into title_principals
    select
        tconst as title_id,
        ordering,
        nconst as person_id,
        category,
        job,
        characters::json as characters,
    from imdb_raw.title_principals
;

create or replace table title_ratings (
    /* alphanumeric unique identifier of the title */
    title_id text primary key,
    /* weighted average of all the individual user ratings */
    average_rating float,
    /* number of votes the title has received */
    num_votes int,
);
insert into title_ratings
    select
        tconst as title_id,
        averageRating as average_rating,
        numVotes as num_votes,
    from imdb_raw.title_ratings
;

create or replace table name_basics (
    /* alphanumeric unique identifier of the name/person */
    person_id text primary key,
    /* name by which the person is most often credited */
    primary_name text,
    /* birth year in YYYY format */
    birth_year int,
    /* death year in YYYY format if applicable, else null */
    death_year int,
    /* the top-3 professions of the person */
    primary_profession text[],
    /* titles the person is known for */
    known_for_titles text[],
);
insert into name_basics
    select
        nconst as person_id,
        primaryName as primary_name,
        birthYear as birth_year,
        deathYear as death_year,
        split(primaryProfession, ',') as primary_profession,
        split(knownForTitles, ',') as known_for_titles,
    from imdb_raw.name_basics
;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

use imdb.imdb;


/* Horror movies! */
with titles as (
    select
        title_id,
        format('{} ({})', primary_title, start_year) as title,
        -- original_title,
        runtime_minutes,
        genres,
        title_type,
    from title_basics
    where 1=1
        and genres.list_contains('Horror')
        and title_type in ('movie', 'tvMovie')
        and not is_adult
        and coalesce(start_year, 0) >= 1980
)

select
    title_id,
    titles.title,
    titles.runtime_minutes,
    titles.genres,
    titles.title_type,
    title_ratings.average_rating,
    title_ratings.num_votes,
    format('https://www.imdb.com/title/{}/', title_id) as url,
from titles
    left join title_ratings
        using (title_id)
where title_ratings.num_votes >= 2_000
order by title_ratings.average_rating desc
limit 100
;
