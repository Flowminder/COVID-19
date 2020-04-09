-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

CREATE TABLE count_home_relocations_per_week AS (

    WITH home_locations_per_week AS (
        SELECT residence_week, msisdn, region FROM (
            SELECT
                msisdn,
                residence_week,
                region,
                row_number() OVER (
                    PARTITION BY msisdn, residence_week
                    ORDER BY total DESC, latest_date DESC
                ) AS daily_location_rank
            FROM (

                SELECT msisdn,
                    extract(WEEK FROM call_date) AS residence_week,
                    region,
                    count(*) AS total,
                    max(call_date) AS latest_date
                FROM (
                    SELECT calls.msisdn,
                        cells.region,
                        calls.call_date,
                        row_number() OVER (
                            PARTITION BY calls.msisdn, calls.call_date
                            ORDER BY calls.call_datetime DESC
                        ) AS event_rank
                    FROM calls
                    INNER JOIN cells
                        ON calls.location_id = cells.cell_id
                    WHERE calls.call_date >= '2020-02-17'
                        AND calls.call_date <= '2020-03-15'

                ) ranked_events

                WHERE event_rank = 1
                GROUP BY msisdn, residence_week, region

            ) times_visited
        ) ranked_locations
        WHERE daily_location_rank = 1
    )
    SELECT residence_week,
        home_locations.region AS previous_home_region,
        home_locations_per_week.region AS new_home_region,
        count(*) AS subscriber_count
    FROM home_locations  -- See intermediate_queries.sql for code to create the home_locations table
        RIGHT JOIN home_locations_per_week
        USING (msisdn)
    GROUP BY residence_week,
        previous_home_region,
        new_home_region
    HAVING count(*) >= 15

);