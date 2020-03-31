-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

CREATE TABLE home_locations AS (

    SELECT msisdn, region FROM (
        SELECT
            msisdn,
            region,
            row_number() OVER (
                PARTITION BY msisdn
                ORDER BY total DESC, latest_date DESC
            ) AS daily_location_rank
        FROM (

            SELECT msisdn,
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
                WHERE calls.call_date >= '2020-02-01'
                    AND calls.call_date <= '2020-02-29'

            ) ranked_events

            WHERE event_rank = 1
            GROUP BY 1, 2

        ) times_visited
    ) ranked_locations
    WHERE daily_location_rank = 1

);