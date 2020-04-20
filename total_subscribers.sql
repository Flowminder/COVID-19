-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

CREATE TABLE total_subscribers_per_day AS (

    SELECT call_date,
        count(*) AS subscriber_count
    FROM calls
    WHERE call_date >= '2020-02-01'
        AND call_date <= CURRENT_DATE
    GROUP BY call_date, msisdn
    HAVING count(*) > 15

);