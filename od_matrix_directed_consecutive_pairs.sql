-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

CREATE TABLE od_matrix_directed_consecutive_pairs
  AS WITH located AS (SELECT msisdn,
                             region,
                             call_date,
                             row_number() OVER (PARTITION BY msisdn, call_date
                                                ORDER BY call_datetime ASC) AS rank
                      FROM calls
                           INNER JOIN cells ON calls.location_id = cells.cell_id
                      WHERE (calls.call_date >= '2020-03-01')
                        AND (calls.call_date <= CURRENT_DATE))

       SELECT call_date,
              region_from,
              region_to,
              count(*)
       FROM (SELECT source.msisdn,
                    source.call_date,
                    source.region AS region_from,
                    sink.region AS region_to
             FROM located AS source
                  INNER JOIN (SELECT msisdn,
                                     region,
                                     call_date,
                                     rank - 1 AS rank
                              FROM located) AS sink USING (msisdn, call_date, rank)
             GROUP BY msisdn, call_date, region_from, region_to) AS joined
       GROUP BY call_date, region_from, region_to
       HAVING count(*) >= 15; 
