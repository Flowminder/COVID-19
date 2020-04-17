#!/bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
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
        INSERT INTO localities (locality)
            SELECT 'Locality-' || TO_CHAR(i, 'FM00') AS locality from generate_series(1,20) s(i);

        INSERT INTO cells (cell_id, locality)
            SELECT cell_id, locality FROM (
                SELECT TO_CHAR(i, 'FM00000')::TEXT cell_id, floor(random() * 20) + 1 rid
                FROM generate_series(1,$CELL_COUNT) s(i)
            ) l
            INNER JOIN (
                SELECT row_number() over() AS rid, locality FROM localities
            ) r
            USING (rid);

        INSERT INTO subscribers (msisdn)
            SELECT md5(random()::TEXT) msisdn FROM generate_series(1, $SUBSCRIBER_COUNT);

        INSERT INTO calls (call_date, call_datetime, msisdn, location_id)
            SELECT call_date, call_datetime, msisdn, location_id
            FROM generate_sample_cdr('$SAMPLE_COUNT'::INTEGER, '$SAMPLE_START_TIME'::TIMESTAMP, '$SAMPLE_END_TIME'::TIMESTAMP);
    END;
"
