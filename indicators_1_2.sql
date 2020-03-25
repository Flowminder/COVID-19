CREATE TABLE count_unique_subscribers_per_region_per_day AS (


    SELECT date(calls.datetime) AS date,
        cells.region AS region
        COUNT(DISTINCT msisdn) AS count
    FROM calls
    INNER JOIN cells
        ON calls.location_id = cells.cell_id
    WHERE date >= '2020-02-01'
	      AND date <= CURRENT_DATE
    GROUP BY 1, 2

);



CREATE TABLE home_locations AS (

    SELECT msisdn,
        region
    FROM (

        SELECT msisdn,
            cells.region
        FROM (
            SELECT calls.msisdn,
                cells.region,
                calls.datetime,
                ROW_NUMBER() OVER (PARTITION BY calls.msisdn, date(calls.datetime)
                ORDER BY calls.datetime DESC) AS rank
        FROM calls
        INNER JOIN cells
            ON calls.location_id = cells.cell_id
        WHERE calls.date >= '2020-02-01'
            AND calls.date <= '2020-02-29'

        ) sub1

    WHERE rank = 1
    GROUP BY 1, 2

    ) sub2

);


CREATE TABLE count_unique_active_residents_per_day AS (

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

);

CREATE TABLE count_unique_visitors_per_region_per_day AS (

    SELECT date,
        region,
	      all_visits.count - COALESCE(home_visits.count, 0) AS count
    FROM count_unique_subscribers_per_region_per_day all_visits
    LEFT JOIN count_unique_active_residents_per_day home_visits
        ON all_visits.date = home_visits.date
	      AND all_visits.region = home_visits.region

);