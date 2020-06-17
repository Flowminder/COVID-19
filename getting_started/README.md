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

The resulting 'located calls' table should contain one row for each CDR event between `start_date` and `end_date`, with fields `msisdn`, `call_date`, `call_datetime` and `locality`.

Here is an example of the 'located calls' table:

|              msisdn              | call_date  |       call_datetime        |  locality  |
| -------------------------------- | ---------- | -------------------------- | ---------- |
| 9e11684250dd7d0b39447907e934dc59 | 2020-02-01 | 2020-02-01 00:00:00.148863 | Locality31 |
| 61b745e9e3f144f00a888ab1452c2279 | 2020-02-01 | 2020-02-01 00:00:03.214628 | Locality34 |
| 6ed281ec19432fa4a2e2b32862d395f5 | 2020-02-01 | 2020-02-01 00:00:04.522204 | Locality08 |
| 9282922cadc904cdcdc9976373aad838 | 2020-02-01 | 2020-02-01 00:00:04.610717 | Locality31 |
| 42ef7cc3c5b601fa48f06687d0175939 | 2020-02-01 | 2020-02-01 00:00:05.467683 | Locality29 |
| ... | ... | ... | ... |

### Query 1: count_subscribers_per_locality_per_day

1. Create 'located calls' table as described above  
2. Count the number of unique subscribers in each locality each day  
    For each date in the date range:  
        For each locality:  
            Count the number of unique `msisdn`s that appear in the 'located calls' table with this `call_date` and `locality`  
3. Only output rows with subscriber count > 15

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

1. Create ‘located calls’ table as described above  
2. Count the total number of unique subscribers each day  
    For each date in the date range:  
        Count the number of unique `msisdn`s that appear in the 'located calls' table with this `call_date`  
3. Only output rows with subscriber count > 15

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

1. Create ‘located calls’ table as described above.  
2. Find the earliest time that each subscriber was active in each locality, each day  
    For each date in the date range:  
        For each locality:  
            For each msisdn:  
                Find the earliest time this msisdn appears in the 'located calls' table for this call date and locality  
    This should produce an 'earliest visits' table, with columns `msisdn`, `call_date`, `locality`, `earliest_time`.  
3. Find the latest time that each subscriber was active in each locality, each day  
    For each date in the date range:  
        For each locality:  
            For each msisdn:  
                Find the latest time this msisdn appears in the 'located calls' table for this call date and locality  
    This should produce a 'latest visits' table, with columns `msisdn`, `call_date`, `locality`, `latest_time`.   
4. Join the 'earliest visits' table to the 'latest visits' table, matching on columns `msisdn` and `call_date`. This should produce a table `pair_connections`, with columns `msisdn`, `call_date`, `locality_from`, `locality_to`, `earliest_time` and `latest_time` (where `locality_from` is the locality from the 'earliest visits' table, and `locality_to` is the locality from the 'latest visits' table).  
5. For each pair of localities, count the number of unique subscribers who were active at `locality_from` before `locality_to` each day  
    For each date in the date range:  
        For each `locality_from`:  
            For each `locality_to`:  
                Count the number of rows in the `pair_connections` table with this `call_date`, `locality_from` and `locality_to`, where `earliest_date <= latest_date`  
6. Only output rows with subscriber count > 15

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

## Scaled indicators
