-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

CREATE TABLE home_location_counts_per_region AS (

    SELECT * FROM (
        SELECT region, count(msisdn) AS subscriber_count
        FROM home_locations     -- See intermediate_queries.sql for code to create the home_locations table
        GROUP BY region
    ) AS home_counts
    WHERE home_counts.subscriber_count >= 15

);