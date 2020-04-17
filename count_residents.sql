-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

CREATE TABLE count_residents_per_locality AS (

    SELECT * FROM (
        SELECT locality, count(msisdn) AS subscriber_count
        FROM home_locations  -- See home_locations.sql for code to create the home_locations table
        GROUP BY locality
    ) AS home_counts
    WHERE home_counts.subscriber_count > 15

);