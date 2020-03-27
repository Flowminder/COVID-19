-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

CREATE TABLE count_unique_subscribers_per_region_per_day AS (

    SELECT * FROM (
        SELECT date(calls.datetime) AS date,
            cells.region AS region,
            COUNT(DISTINCT msisdn) AS count
        FROM calls
        INNER JOIN cells
            ON calls.location_id = cells.cell_id
        WHERE date >= '2020-02-01'
            AND date <= CURRENT_DATE
        GROUP BY 1, 2
    ) AS grouped
    WHERE grouped.count > 15

);



CREATE TABLE home_locations AS (

    SELECT msisdn, region FROM (
        SELECT
            msisdn,
            region,
            row_number() OVER (
                PARTITION BY msisdn
                ORDER BY total DESC, date DESC
            ) AS rank
        FROM (

            SELECT msisdn,
                region,
                count(*) AS total,
                max(date) AS date
            FROM (
                SELECT calls.msisdn,
                    cells.region,
                    calls.datetime,
                    calls.date,
                    ROW_NUMBER() OVER (
                        PARTITION BY calls.msisdn, date(calls.datetime)
                        ORDER BY calls.datetime DESC
                    ) AS rank
                FROM calls
                INNER JOIN cells
                    ON calls.location_id = cells.cell_id
                WHERE calls.date >= '2020-02-01'
                    AND calls.date <= '2020-02-29'

            ) ranked_events

        WHERE rank = 1
        GROUP BY 1, 2

        ) times_visited
    ) ranked_locations
    WHERE rank = 1

);


CREATE TABLE count_unique_active_residents_per_day AS (

    SELECT * FROM (
        SELECT calls.date AS date,
            cells.region AS region,
            COUNT(DISTINCT calls.msisdn) AS count
        FROM calls
        INNER JOIN cells
            ON calls.location_id = cells.cell_id
        INNER JOIN home_locations homes
            ON calls.msisdn = homes.msisdn
            AND cells.region = homes.region
        GROUP BY 1, 2
    ) AS grouped
    WHERE grouped.count > 15

);

CREATE TABLE count_unique_visitors_per_region_per_day AS (
    SELECT * FROM (
        SELECT all_visits.date,
            all_visits.region,
            all_visits.count - COALESCE(home_visits.count, 0) AS count
        FROM count_unique_subscribers_per_region_per_day all_visits
        LEFT JOIN count_unique_active_residents_per_day home_visits
            ON all_visits.date = home_visits.date
            AND all_visits.region = home_visits.region
    ) AS visitors
    WHERE visitors.count > 15

);