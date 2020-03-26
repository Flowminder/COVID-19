-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

CREATE TABLE count_unique_subscribers_per_region_per_week AS (

    SELECT EXTRACT('week' FROM calls.date) AS week,
        cells.region AS region,
        COUNT(DISTINCT calls.msisdn) AS count
    FROM calls
    INNER JOIN cells
        ON calls.location_id = cells.cell_id
    WHERE calls.date >= '2020-02-17'
        AND calls.datetime <= '2020-03-15'
    GROUP BY 1, 2

);

-- See indicators_1_2.sql for code to create the home_locations table

CREATE TABLE count_unique_active_residents_per_week AS (

    SELECT EXTRACT('week' FROM calls.date) AS week,
        cells.region AS region,
        COUNT(DISTINCT calls.msisdn) AS count
    FROM calls
    INNER JOIN cells
        ON calls.location_id = cells.cell_id
    INNER JOIN home_locations homes
        ON calls.msisdn = homes.msisdn
        AND cells.region = homes.region
    WHERE calls.datetime >= '2020-02-17'
        AND calls.datetime <= '2020-03-15'
    GROUP BY 1, 2

);

CREATE TABLE count_unique_visitors_per_region_per_week AS (

    SELECT week,
        region,
	      all_visits.count - COALESCE(home_visits.count, 0) AS count
    FROM count_unique_subscribers_per_region_per_week all_visits
    LEFT JOIN count_unique_active_residents_per_week home_visits
        ON all_visits.date = home_visits.date
	      AND all_visits.region = home_visits.region

);