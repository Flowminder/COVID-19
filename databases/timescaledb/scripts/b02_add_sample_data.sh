#!/bin/bash
set -e
#
#  EVENTS.SAMPLE
#  -------------
#
#  Generate synthetic sample CDR data and insert into 
#  table events.sample.
#

export PGUSER="$POSTGRES_USER"

psql --dbname="$POSTGRES_DB" -c "
    BEGIN;
        INSERT INTO regions (region)
            SELECT concat('Region-', generate_series) AS region from generate_series(1,20);

        INSERT INTO cells (cell_id, region)
            SELECT cell_id, region FROM (
                SELECT TO_CHAR(random() * 100000, '00000')::TEXT cell_id, (random()*19)::integer + 1 rid
                FROM generate_series(1,100)
            ) l
            INNER JOIN (
                SELECT row_number() over() AS rid, region FROM regions
            ) r
            USING (rid);

        INSERT INTO subscribers (msisdn)
            SELECT md5(random()::TEXT) msisdn FROM generate_series(1, 10000);

        INSERT INTO calls (date, datetime, msisdn, location_id)
            SELECT date, datetime, msisdn, location_id
            FROM generate_sample_cdr('$SAMPLE_COUNT'::INTEGER, '$SAMPLE_START_TIME'::TIMESTAMP, '$SAMPLE_END_TIME'::TIMESTAMP);
    END;
"
