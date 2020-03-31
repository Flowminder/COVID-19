-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

CREATE TABLE regional_pair_connections_per_day AS (

    SELECT * FROM (
        SELECT connection_date,
            region1,
            region2,
            COUNT(*) AS subscriber_count
        FROM (

            SELECT t1.call_date AS connection_date,
                t1.msisdn AS msisdn,
                t1.region AS region1,
                t2.region AS region2
            FROM (
                SELECT DISTINCT calls.msisdn,
                    calls.call_date,
                    cells.region
                FROM calls
                INNER JOIN cells
                    ON calls.location_id = cells.cell_id
                WHERE calls.call_date >= '2020-03-01'
                    AND calls.call_date <= CURRENT_DATE
                ) t1

                FULL OUTER JOIN

                (
                SELECT DISTINCT calls.msisdn,
                    calls.call_date,
                    cells.region
                FROM calls
                INNER JOIN cells
                    ON calls.location_id = cells.cell_id
                WHERE calls.call_date >= '2020-03-01'
                    AND calls.call_date <= CURRENT_DATE
                ) t2

                ON t1.msisdn = t2.msisdn
                AND t1.call_date = t2.call_date
            WHERE t1.region < t2.region

        ) AS pair_connections
        GROUP BY 1, 2, 3
    ) AS grouped
    WHERE grouped.subscriber_count >= 15

);
