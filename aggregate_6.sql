-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

CREATE TABLE directed_regional_pair_connections_per_day AS (

    WITH subscriber_locations AS (
        SELECT calls.msisdn,
            calls.call_date,
            cells.region,
            min(calls.call_datetime) AS earliest_visit,
            max(calls.call_datetime) AS latest_visit
        FROM calls
        INNER JOIN cells
            ON calls.location_id = cells.cell_id
        WHERE calls.call_date >= '2020-03-01'
            AND calls.call_date <= CURRENT_DATE
        GROUP BY msisdn, call_date, region
    )
    SELECT * FROM (
        SELECT connection_date,
            region_from,
            region_to,
            count(*) AS subscriber_count
        FROM (

            SELECT t1.call_date AS connection_date,
                t1.msisdn AS msisdn,
                t1.region AS region_from,
                t2.region AS region_to
            FROM subscriber_locations t1
            FULL OUTER JOIN subscriber_locations t2
            ON t1.msisdn = t2.msisdn
                AND t1.call_date = t2.call_date
            WHERE t1.region <> t2.region
                AND t1.earliest_visit < t2.latest_visit

        ) AS pair_connections
        GROUP BY 1, 2, 3
    ) AS grouped
    WHERE grouped.subscriber_count >= 15

);