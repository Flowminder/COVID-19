CREATE TABLE regional_pair_connections_per_day AS (

    SELECT * FROM (
        SELECT date,
            region1,
            region2,
            COUNT(*) AS count
        FROM (

            SELECT t1.date AS date,
                t1.msisdn AS msisdn,
                t1.region AS region1,
                t2.region AS region2
            FROM (
                SELECT calls.msisdn,
                    cells.region
                FROM calls
                INNER JOIN cells
                    ON calls.location_id = cells.cell_id
                WHERE calls.date >= '2020-03-01'
                    AND calls.date <= CURRENT_DATE
                GROUP BY 1
                ) t1

                FULL OUTER JOIN

                (
                SELECT calls.msisdn,
                    cells.region
                FROM calls
                INNER JOIN cells
                    ON calls.location_id = cells.cell_id
                WHERE calls.date >= '2020-03-01'
                    AND calls.date <= CURRENT_DATE
                GROUP BY 1
                ) t2

                ON t1.msisdn = t2.msisdn
                AND t1.date = t2.date
            WHERE t1.region < t2.region

        )
        GROUP BY 1, 2, 3
    ) AS grouped
    WHERE grouped.count > 15

);