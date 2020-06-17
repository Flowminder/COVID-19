# Getting started: steps to produce aggregates from CDR data

This section explains the steps required for a mobile network operator to produce the first aggregates from their CDR data. It covers the steps required before calculating the aggregates, descriptions of the three aggregate queries we recommend should be calculated first, guidance on checking the outputs are correct, and steps to get from the aggregate data to  mobility indicators that can be shared with external parties without revealing commercially sensitive information.

## Initial steps

### 1. Choose localities

Before producing any aggregates, it is necessary to choose the set of spatial localities to which data will be aggregated. Typically it is best to use administrative divisions, as these will be more useful to government decision makers than other spatial divisions such as sales regions.

Once a suitable set of localities has been selected, each cell tower must be assigned to the appropriate locality. Advice for performing this mapping can be found on our [COVID-19 website](https://covid19.flowminder.org/cdr-aggregates/understanding-cdr-aggregates-fundamentals#h.82tox8a9gwpz). At this stage it is important to check for errors in the cell locations information. Some common issues that should be checked are:

- Check that no cell towers have obviously incorrect locations (for example in the sea or outside the country borders),  
- Check that each cell has a unique ID (i.e. no duplicated cell IDs corresponding to different tower locations),  
- If cell towers are already associated with spatial regions, check that the location of each tower is within the spatial region with which it is associated.  

### 2. Identify data structure

The SQL queries in this repository have been written assuming that the following two tables exist:

- `calls`: This table contains the CDR events for the period over which the aggregates are to be calculated, including the msisdn of the subscriber making the event, the date and time of the event, and the cell to which the subscriber connected.
- `cells`: This table should have been produced in the previous step (["choose localities"](choose_localities)). This is a mapping from each cell ID to a locality.

Example of `calls` table:

|              msisdn              | call_date  |       call_datetime        | location_id |
| -------------------------------- | ---------- | -------------------------- | ----------- |
| 9e11684250dd7d0b39447907e934dc59 | 2020-02-01 | 2020-02-01 00:00:00.148863 | 00039 |
| 61b745e9e3f144f00a888ab1452c2279 | 2020-02-01 | 2020-02-01 00:00:03.214628 | 00062 |
| 6ed281ec19432fa4a2e2b32862d395f5 | 2020-02-01 | 2020-02-01 00:00:04.522204 | 00056 |
| 9282922cadc904cdcdc9976373aad838 | 2020-02-01 | 2020-02-01 00:00:04.610717 | 00087 |
| 42ef7cc3c5b601fa48f06687d0175939 | 2020-02-01 | 2020-02-01 00:00:05.467683 | 00097 |
| ... | ... | ... | ... |

Example of `cells` table:

| cell_id |  locality  |
| ------- | ---------- |
| 00070   | Locality01 |
| 00040   | Locality01 |
| 00049   | Locality01 |
| 00036   | Locality01 |
| 00047   | Locality02 |
| ... | ... |

It is likely that there are existing tables equivalent to these, but with different column names. In this case, the table and column names in the SQL queries will need to be changed accordingly.

### 3. Choose date range

The queries described below will produce aggregated outputs for each day in a specified date range.

The first time each query is run, this date range should include a 'baseline' period before the COVID-19 crisis began, to which outputs during the crisis can be compared. We recommend that the date range for the first run should start at least 4 weeks before the first mobility restrictions were announced, and end at the current date.

After these first outputs have been produced, updated outputs can be produced at regular intervals (daily, or a few times per week) to provide insights into mobility in the most recent days. For these runs, the date range only needs to cover the few days since the last outputs were produced. It is important to ensure that a full day of CDR data is available before producing aggregates for that day.

In the descriptions below, we use `start_date` and `end_date` to refer to the start and end dates of this date range.

## Aggregates

The first three aggregates we would recommend calculating are [`count_subscribers_per_locality_per_day`](../count_subscribers.md), [`total_subscribers_per_day`](../total_subscribers.md) and [`od_matrix_directed_all_pairs_per_day`](../od_matrix_directed_all_pairs.md).

If your database / data analysis system can execute SQL queries, the queries in [count_subscribers.sql](../count_subscribers.sql#L5-L20), [total_subscribers.sql](../total_subscriber.sql#L5-L17) and [od_matrix_directed_all_pairs.sql](../od_matrix_directed_all_pairs.sql#L5-L53). As noted above, the names of tables and columns may need to be changed to match your data structure. Additionally, it may be necessary to modify or optimise the queries to suit your data system.

In case your system does not support running SQL queries, or it would be preferable to implement the queries in a different query language, the steps to produce these three aggregates are described below.

### Common steps

The first step in calculating each of the aggregates is to join each CDR event with its associated locality. The steps required are:

1. Select the subset of the `calls` table with `call_date >= start_date` and `call_date <=  end_date`  
2. Join this subset of the `calls` table to the `cells` table, matching the `location_id` field of `calls` to the `cell_id` field of `cells`.

The resulting `located_calls` table should contain one row for each CDR event between `start_date` and `end_date`, with fields `msisdn`, `call_date`, `call_datetime` and `locality`.

Here is an example of the `located_calls` table:

|              msisdn              | call_date  |       call_datetime        |  locality  |
| -------------------------------- | ---------- | -------------------------- | ---------- |
| 9e11684250dd7d0b39447907e934dc59 | 2020-02-01 | 2020-02-01 00:00:00.148863 | Locality31 |
| 61b745e9e3f144f00a888ab1452c2279 | 2020-02-01 | 2020-02-01 00:00:03.214628 | Locality34 |
| 6ed281ec19432fa4a2e2b32862d395f5 | 2020-02-01 | 2020-02-01 00:00:04.522204 | Locality08 |
| 9282922cadc904cdcdc9976373aad838 | 2020-02-01 | 2020-02-01 00:00:04.610717 | Locality31 |
| 42ef7cc3c5b601fa48f06687d0175939 | 2020-02-01 | 2020-02-01 00:00:05.467683 | Locality29 |
| ... | ... | ... | ... |

### Query 1: count_subscribers_per_locality_per_day

1. Create `located_calls` table as described above  
2. Count the number of unique subscribers in each locality each day:  
    ```
    for each visit_date in range(start_date, end_date):  
        for each locality in located_calls.locality:  
            subscriber_count = count_unique(located_calls.msisdn)
                               where located_calls.call_date=visit_date
                               and located_calls.locality=locality;
    ```  
3. Only output rows with `subscriber_count > 15`

The output should contain one row per day per locality.

Example output from this aggregate query:

| visit_date |  locality  | subscriber_count |
| ---------- | ---------- | ---------------- |
| 2020-02-01 | Locality01 |             1161 |
| 2020-02-01 | Locality02 |              301 |
| 2020-02-01 | Locality03 |              286 |
| 2020-02-01 | Locality04 |             1076 |
| 2020-02-01 | Locality05 |              308 |
| ... | ... | ... |

### Query 2: total_subscribers_per_day

1. Create `located_calls` table as described above  
2. Count the total number of unique subscribers each day:  
    ```
    for each call_date in range(start_date, end_date):  
        subscriber_count = count_unique(located_calls.msisdn)
                           where located_calls.call_date=call_date;
    ```  
3. Only output rows with `subscriber_count > 15`

The output should contain one row per day.

Example output from this aggregate query:

| call_date  | subscriber_count |
| ---------- | ---------------- |
| 2020-02-01 |             9549 |
| 2020-02-02 |             9458 |
| 2020-02-03 |             9522 |
| 2020-02-04 |             9463 |
| 2020-02-05 |             9495 |
| ... | ... |

### Query 3: od_matrix_directed_all_pairs_per_day

1. Create `located_calls` table as described above.  
2. Find the earliest time that each subscriber was active in each locality, each day:  
    ```
    for each call_date in range(start_date, end_date):  
        for each msisdn:  
            for each locality_from in located_calls.locality:  
                earliest_visit = min(located_calls.call_datetime)
                                 where located_calls.call_date=call_date
                                 and located_calls.msisdn=msisdn
                                 and located_calls.locality=locality_from;
    ```  
    This should produce an `earliest_visits` table, with columns `call_date`, `msisdn`, `locality_from` and `earliest_visit`.  
2. Find the latest time that each subscriber was active in each locality, each day:  
    ```
    for each call_date in range(start_date, end_date):  
        for each msisdn:  
            for each locality_to in located_calls.locality:  
                latest_visit = max(located_calls.call_datetime)
                               where located_calls.call_date=call_date
                               and located_calls.msisdn=msisdn
                               and located_calls.locality=locality_to;
    ```  
    This should produce a `latest_visits` table, with columns `call_date`, `msisdn`, `locality_from` and `latest_visit`.  
4. Join the `earliest_visits` table to the `latest_visits` table, matching on columns `call_date` and `msisdn`.  
5. Select only the rows from the joined table where `earliest_visit <= latest_visit` (i.e. subscribers who visited `locality_from` before `locality_to`).  
    This should produce a table `pair_connections`, with columns `call_date`, `msisdn`, `locality_from` and `locality_to`.  
5. For each pair of localities, count the number of unique subscribers who were active at `locality_from` before `locality_to` each day:  
    ```
    for each connection_date in range(start_date, end_date):  
        for each locality_from:  
            for each locality_to:  
                subscriber_count = count_unique(pair_connections.msisdn)
                                   where pair_connections.call_date=connection_date
                                   and pair_connections.locality_from=locality_from
                                   and pair_connections.locality_to=locality_to;
    ```
6. Only output rows with subscriber count > 15

The output should contain one row per day per pair of localities.

Example output from this aggregate query:

| connection_date | locality_from | locality_to | subscriber_count |
| --------------- | ------------- | ----------- | ---------------- |
| 2020-02-01      | Locality01    | Locality01  |             1161 |
| 2020-02-01      | Locality01    | Locality03  |               23 |
| 2020-02-01      | Locality01    | Locality04  |               45 |
| 2020-02-01      | Locality01    | Locality05  |               16 |
| 2020-02-01      | Locality01    | Locality06  |               27 |
| ... | ... | ... | ... |

## Data checks

Before these aggregates are used to produce mobility indicators, we strongly recommend that some data quality checks are performed to ensure that the aggregate queries have been implemented correctly and that the underlying CDR data are correct and complete.

Some checks that can be performed are:

- The sum of subscriber counts in _count_subscribers_per_locality_per_day_ across all localities each day should be greater than the subscriber count in _total_subscribers_per_day_ for the same day (because some subscribers will be active in more than one locality). If this is not the case, this suggests that there is an issue with the implementation of one of the queries (for example, if both counts are equal this suggests that the queries may be counting CDR events rather than unique subscribers).  
- The subscriber counts in the diagonal of _od_matrix_directed_all_pairs_per_day_ (i.e. the rows with `locality_from=locality_to`) should be equal to the subscriber counts in _count_subscribers_per_locality_per_day_ for the same date and locality. If these are not equal, this suggests that there is an issue with the implementation of one of the queries.  
- Plotting a graph of subscriber counts over time should show a clear weekly pattern of variation (for example, subscriber counts on Sundays may be lower than on weekdays). If there is no such pattern evident in the data, this could indicate an issue with the data or the calculation of aggregates.  
- Compare the subscriber counts each day to the corresponding subscriber counts for the previous days/weeks. A large change from one day to the next could indicate an issue with the data (for example, the aggregates may have been calculated on an incomplete temporal subset of the CDR data for that day, or data from some cells may be missing or incorrectly assigned to localities).

We will be updating this section with some additional queries that can be run for data checking purposes.
