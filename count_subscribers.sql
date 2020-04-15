-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

CREATE TABLE count_subscribers_per_locality_per_day AS (

    SELECT * FROM (
        SELECT calls.call_date AS visit_date,
            cells.locality AS locality,
            count(DISTINCT msisdn) AS subscriber_count
        FROM calls
        INNER JOIN cells
            ON calls.location_id = cells.cell_id
        WHERE calls.call_date >= '2020-02-01'
            AND calls.call_date <= CURRENT_DATE
        GROUP BY visit_date, locality
    ) AS grouped
    WHERE grouped.subscriber_count > 15

);


CREATE TABLE count_subscribers_per_locality_per_week AS (
    
    SELECT * FROM (
        SELECT extract(WEEK FROM calls.call_date) AS visit_week,
            cells.locality AS locality,
            count(DISTINCT msisdn) AS subscriber_count
        FROM calls
        INNER JOIN cells
            ON calls.location_id = cells.cell_id
        WHERE calls.call_date >= '2020-02-01'
            AND calls.call_date <= CURRENT_DATE
        GROUP BY visit_week, locality
    ) AS grouped
    WHERE grouped.subscriber_count > 15

);


CREATE TABLE count_subscribers_per_locality_per_hour AS (

    SELECT * FROM (
        SELECT calls.call_date AS visit_date,
            extract(HOUR FROM calls.call_datetime) AS visit_hour,
            cells.locality AS locality,
            count(DISTINCT msisdn) AS subscriber_count
        FROM calls
        INNER JOIN cells
            ON calls.location_id = cells.cell_id
        WHERE calls.call_date >= '2020-02-01'
            AND calls.call_date <= CURRENT_DATE
        GROUP BY visit_date, visit_hour, locality
    ) AS grouped
    WHERE grouped.subscriber_count > 15

);