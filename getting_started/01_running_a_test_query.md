# Getting started: running a test query

This file describes the CDR data structure that is required for running the aggregate queries in this repository, and introduces a simple SQL query that should be run to test that the CDR data can be queried. We recommend that this test query should be run before following the steps in [02_producing_aggregates.md](02_producing_aggregates.md) to produce the aggregated outputs.

## Data structure

The SQL queries in this repository have been written assuming that the CDR data are in a table named `calls`, which contains the CDR events for the period over which the aggregates are to be calculated, including the msisdn of the subscriber making the event, the date and time of the event, and the cell to which the subscriber connected.

Example of `calls` table:

|              msisdn              | call_date  |       call_datetime        | location_id |
| -------------------------------- | ---------- | -------------------------- | ----------- |
| 9e11684250dd7d0b39447907e934dc59 | 2020-02-01 | 2020-02-01 00:00:00.148863 | 00039 |
| 61b745e9e3f144f00a888ab1452c2279 | 2020-02-01 | 2020-02-01 00:00:03.214628 | 00062 |
| 6ed281ec19432fa4a2e2b32862d395f5 | 2020-02-01 | 2020-02-01 00:00:04.522204 | 00056 |
| 9282922cadc904cdcdc9976373aad838 | 2020-02-01 | 2020-02-01 00:00:04.610717 | 00087 |
| 42ef7cc3c5b601fa48f06687d0175939 | 2020-02-01 | 2020-02-01 00:00:05.467683 | 00097 |
| ... | ... | ... | ... |

(the `location_id` column contains the ID of the cell with which the event is associated).

It is likely that there is an existing table equivalent to this, but with different column names. In this case, the table and column names in the SQL queries will need to be changed accordingly.

## Test query

The aggregate queries in this repository are written in SQL. To ensure you are able to modify the SQL queries to be compatible with your data structure and database system, here is a simple SQL query to aggregate the CDR data in a `calls` table that has the structure described above. This query counts the number of unique msisdns with CDR events at each cell, each day.

**Note:** This query is included for testing purposes only. The output of this query will not be used for producing mobility indicators.

```
SELECT call_date,
    location_id,
    count(DISTINCT msisdn) AS subscriber_count
FROM calls
WHERE call_date >= '2020-02-01'
    AND call_date <= '2020-02-03'
GROUP BY call_date, location_id
HAVING count(DISTINCT msisdn) > 15;
```

Note two features that are similar to many of the aggregate queries in this repository:

- `count(DISTINCT msisdn)` counts the number of unique msisdns (e.g. if one msisdn makes multiple calls at the same cell on one day, the query will only count that msisdn once). This is important because often we are interested in the number of subscribers in an area, rather than the number of CDR events.  
- `HAVING count(DISTINCT msisdn) > 15` ensures that the output does not contain any information about groups of 15 or fewer subscribers. This is important to protect subscribers' privacy.  

If you are able to run SQL queries against your CDR data, you should be able to run this query after modifying the table and column names to match your data structure (you may also need to change the date range to dates that are available in your data). If your system does not support running SQL queries, or it would be preferable to implement the queries in a different query language, you can follow the steps described below (note: you will need to follow a similar process to implement the aggregate queries):

1. Choose an appropriate `start_date` and `end_date` for a short date range that is included in your CDR data. The SQL query above has `start_date=2020-02-01` and `end_date=2020-02-03`.
2. Select the subset of the `calls` table with `call_date >= start_date` and `call_date <=  end_date`
3. Count the number of unique subscribers in each locality each day:  
    ```
    for each individual_date from start_date to end_date:  
        for each cell_id in calls.location_id:  
            subscriber_count = count_unique(calls.msisdn)
                               where calls.call_date=individual_date
                               and calls.location_id=cell_id;
    ```  
4. Only output rows with `subscriber_count > 15`

## Next steps

Once you have been able to run the query above and produce an output, look at [02_producing_aggregates.md](02_producing_aggregates.md) for details of the steps to produce the first aggregate outputs that can be used to produce mobility indicators.
