-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

CREATE TABLE count_unique_subscribers_per_region_per_week AS (

    SELECT * FROM (
        SELECT extract(WEEK FROM calls.call_date) AS visit_week,
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
