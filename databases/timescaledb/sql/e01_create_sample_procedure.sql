-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
/*

ADD_SAMPLE_GENERATOR---------------------------------------
Create a function to generate synthetic sample CDR data
@chrisjbrooks
-----------------------------------------------------------
*/
CREATE OR REPLACE FUNCTION generate_sample_cdr(IN sample_count INTEGER DEFAULT 7, IN start_timestamp TIMESTAMP DEFAULT '20190101'::TIMESTAMP, IN end_timestamp TIMESTAMP DEFAULT '20190101'::TIMESTAMP)
    RETURNS TABLE (
		date                DATE,
	    datetime            TIMESTAMP, 
	    msisdn              TEXT,
	    location_id         TEXT
	) AS
$$
DECLARE
	time_interval INTERVAL;
BEGIN
	time_interval = (end_timestamp - start_timestamp) + INTERVAL '1 day' - INTERVAL '0.01' SECONDS;
	RETURN QUERY
	    SELECT
			l.datetime::date AS date,
			l.datetime,
			s.msisdn,
			l.location_id
		FROM (
			SELECT cell_id AS location_id, d.datetime, sid FROM (
				SELECT
					floor(random()*99) + 1 cid,
					floor(random()*9999) + 1 sid,
					start_timestamp + random() * time_interval AS datetime
				FROM generate_series(1, sample_count)
			) d
			INNER JOIN (
				SELECT row_number() over() AS cid, cell_id FROM cells
			) c
			USING (cid)
		) l
		INNER JOIN (
			SELECT row_number() over() AS sid, m.msisdn FROM subscribers m
		) s
		USING (sid)
		ORDER BY datetime;
END
$$
STRICT LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp;
