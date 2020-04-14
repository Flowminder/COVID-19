-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

CREATE TABLE count_visits_home_away_per_day AS (

    SELECT visit_date,
        home_region,
        visit_region,
        count(*) AS subscriber_count
    FROM (
        SELECT visited_locations.call_date AS visit_date,
            visited_locations.msisdn AS msisdn,
            home_locations.region AS home_region,
            visited_locations.region AS visit_region
        FROM (
            SELECT calls.msisdn,
                calls.call_date,
                cells.region
            FROM calls
            INNER JOIN cells
                ON calls.location_id = cells.cell_id
            WHERE calls.call_date >= '2020-03-01'
                AND calls.call_date <= CURRENT_DATE
            GROUP BY msisdn, call_date, region
        ) visited_locations
        LEFT JOIN home_locations  -- See intermediate_queries.sql for code to create the home_locations table
            USING (msisdn)
    ) home_away_pairs
    GROUP BY visit_date, home_region, visit_region
    HAVING count(*) >= 15

);