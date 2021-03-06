-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

CREATE TABLE total_subscribers_per_day AS (

    SELECT call_date,
        count(DISTINCT msisdn) AS subscriber_count
    FROM calls
    INNER JOIN cells
        ON calls.location_id = cells.cell_id
    WHERE call_date >= '2020-02-01'
        AND call_date <= CURRENT_DATE
        AND cells.locality IS NOT NULL
        AND cells.locality != ''
    GROUP BY call_date
    HAVING count(DISTINCT msisdn) > 15

);