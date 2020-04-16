-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

CREATE TABLE count_subscribers_home_locality_per_day
  AS SELECT locality,
            call_date AS count_date,
            count(*) AS subscriber_count
     FROM (SELECT msisdn,
                  call_date
           FROM home_locations -- See home_locations.sql for code to create the home_locations table
                INNER JOIN (SELECT calls.msisdn,
                                   calls.call_date,
                                   cells.locality
                            FROM calls
                                 INNER JOIN cells ON calls.location_id = cells.cell_id
                            WHERE (calls.call_date >= '2020-02-01')
                              AND (calls.call_date <= CURRENT_DATE)
                            GROUP BY call_date, msisdn, locality) AS locs USING (msisdn)
           GROUP BY msisdn, call_date
           HAVING sum(((locs.locality <> home_locations.locality))::integer) = 0) AS at_home
          INNER JOIN home_locations USING (msisdn)
     GROUP BY locality, call_date
     HAVING count(*) > 15
     ORDER BY call_date,
              locality;