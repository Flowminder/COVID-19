-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

CREATE TABLE count_subscribers_single_region_per_day
  AS WITH located AS (SELECT calls.msisdn,
                             calls.call_date,
                             cells.region
                      FROM calls
                           INNER JOIN cells ON calls.location_id = cells.cell_id
                      WHERE (calls.call_date >= '2020-02-01')
                        AND (calls.call_date <= CURRENT_DATE)
                      GROUP BY call_date, msisdn, region)

       SELECT region,
              call_date AS count_date,
              count(*) AS subscriber_count
       FROM (SELECT msisdn,
                    call_date
             FROM located
             GROUP BY msisdn, call_date
             HAVING count(*) = 1) AS unmoving
            INNER JOIN located USING (msisdn, call_date)
       GROUP BY region, call_date
       HAVING count(*) >= 15;