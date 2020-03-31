-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

CREATE TABLE count_unique_subscribers_per_region_per_day AS (

    SELECT * FROM (
        SELECT date(calls.call_datetime) AS visit_date,
            cells.region AS region,
            COUNT(DISTINCT msisdn) AS subscriber_count
        FROM calls
        INNER JOIN cells
            ON calls.location_id = cells.cell_id
        WHERE call_date >= '2020-02-01'
            AND call_date <= CURRENT_DATE
        GROUP BY 1, 2
    ) AS grouped
    WHERE grouped.subscriber_count >= 15

);



CREATE TABLE home_locations AS (

    SELECT msisdn, region FROM (
        SELECT
            msisdn,
            region,
            row_number() OVER (
                PARTITION BY msisdn
                ORDER BY total DESC, latest_date DESC
            ) AS daily_location_rank
        FROM (

            SELECT msisdn,
                region,
                count(*) AS total,
                max(call_date) AS latest_date
            FROM (
                SELECT calls.msisdn,
                    cells.region,
                    calls.call_datetime,
                    calls.call_date,
                    ROW_NUMBER() OVER (
                        PARTITION BY calls.msisdn, date(calls.call_datetime)
                        ORDER BY calls.call_datetime DESC
                    ) AS event_rank
                FROM calls
                INNER JOIN cells
                    ON calls.location_id = cells.cell_id
                WHERE calls.call_date >= '2020-02-01'
                    AND calls.call_date <= '2020-02-29'

            ) ranked_events

            WHERE event_rank = 1
            GROUP BY 1, 2

        ) times_visited
    ) ranked_locations
    WHERE daily_location_rank = 1

);


CREATE TABLE count_unique_active_residents_per_day AS (

    SELECT * FROM (
        SELECT calls.call_date AS visit_date,
            cells.region AS region,
            COUNT(DISTINCT calls.msisdn) AS subscriber_count
        FROM calls
        INNER JOIN cells
            ON calls.location_id = cells.cell_id
        INNER JOIN home_locations homes
            ON calls.msisdn = homes.msisdn
            AND cells.region = homes.region
        GROUP BY 1, 2
    ) AS grouped
    WHERE grouped.subscriber_count >= 15

);

CREATE TABLE count_unique_visitors_per_region_per_day AS (
    SELECT * FROM (
        SELECT all_visits.visit_date,
            all_visits.region,
            all_visits.subscriber_count - COALESCE(home_visits.subscriber_count, 0) AS subscriber_count
        FROM count_unique_subscribers_per_region_per_day all_visits
        LEFT JOIN count_unique_active_residents_per_day home_visits
            ON all_visits.visit_date = home_visits.visit_date
            AND all_visits.region = home_visits.region
    ) AS visitors
    WHERE visitors.subscriber_count >= 15

);