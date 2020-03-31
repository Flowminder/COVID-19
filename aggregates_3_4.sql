-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

CREATE TABLE count_unique_subscribers_per_region_per_week AS (

    SELECT * FROM (
        SELECT extract('week' FROM calls.call_date) AS visit_week,
            cells.region AS region,
            count(DISTINCT calls.msisdn) AS subscriber_count
        FROM calls
        INNER JOIN cells
            ON calls.location_id = cells.cell_id
        WHERE calls.call_date >= '2020-02-17'
            AND calls.call_date <= '2020-03-15'
        GROUP BY 1, 2
    ) AS grouped
    WHERE grouped.subscriber_count >= 15

);

-- See aggregates_1_2.sql for code to create the home_locations table

CREATE TABLE count_unique_active_residents_per_week AS (

    SELECT * FROM (
        SELECT extract('week' FROM calls.call_date) AS visit_week,
            cells.region AS region,
            count(DISTINCT calls.msisdn) AS subscriber_count
        FROM calls
        INNER JOIN cells
            ON calls.location_id = cells.cell_id
        INNER JOIN home_locations homes
            ON calls.msisdn = homes.msisdn
            AND cells.region = homes.region
        WHERE calls.call_date >= '2020-02-17'
            AND calls.call_date <= '2020-03-15'
        GROUP BY 1, 2
    ) AS grouped
    WHERE grouped.subscriber_count >= 15

);

CREATE TABLE count_unique_visitors_per_region_per_week AS (

    SELECT * FROM (
        SELECT all_visits.visit_week,
            all_visits.region,
            all_visits.subscriber_count - coalesce(home_visits.subscriber_count, 0) AS subscriber_count
        FROM count_unique_subscribers_per_region_per_week all_visits
        LEFT JOIN count_unique_active_residents_per_week home_visits
            ON all_visits.visit_week = home_visits.visit_week
            AND all_visits.region = home_visits.region
    ) AS visitors
    WHERE visitors.subscriber_count >= 15

);