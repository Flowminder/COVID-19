# Getting started: description of the initial queries

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

### Query 1: total_subscribers_per_day

1. Create `located_calls` table as described above  
2. Count the total number of unique subscribers seen in any locality each day:  
    ```
    for each individual_date from start_date to end_date:  
        subscriber_count = count_unique(located_calls.msisdn)
                           where located_calls.call_date=individual_date
                           and located_calls.locality is not null;
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

The subscriber counts should be close to the size of your total subscriber base (they will be slightly less than this, because not all subscribers will be active every day).

### Query 2: count_subscribers_per_locality_per_day

1. Create `located_calls` table as described above  
2. Count the number of unique subscribers in each locality each day:  
    ```
    for each individual_date from start_date to end_date:  
        for each locality in located_calls.locality:  
            subscriber_count = count_unique(located_calls.msisdn)
                               where located_calls.call_date=individual_date
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

You should notice that the subscriber counts in urban localities are typically larger than those in rural localities.

### Query 3: od_matrix_directed_all_pairs_per_day

1. Create `located_calls` table as described above.  
2. Find the earliest time that each subscriber was active in each locality, each day:  
    ```
    for each individual_date from start_date to end_date:  
        for each msisdn:  
            for each locality_from in located_calls.locality:  
                earliest_visit = min(located_calls.call_datetime)
                                 where located_calls.call_date=individual_date
                                 and located_calls.msisdn=msisdn
                                 and located_calls.locality=locality_from;
    ```  
    This should produce an `earliest_visits` table, with columns `msisdn`, `call_date`, `locality_from` and `earliest_visit`.  
    Example:
    |              msisdn              | call_date  |  locality_from  |       earliest_visit       |
    | -------------------------------- | ---------- | ---------- | -------------------------- |
    | 0002a1416458f73b4d5f2baeedeb896b | 2020-02-01 | Locality09 | 2020-02-01 00:39:35.907448 |
    | 0002a1416458f73b4d5f2baeedeb896b | 2020-02-01 | Locality17 | 2020-02-01 18:31:06.438344 |
    | 0002a1416458f73b4d5f2baeedeb896b | 2020-02-01 | Locality29 | 2020-02-01 23:38:44.462744 |
    | 0002a1416458f73b4d5f2baeedeb896b | 2020-02-02 | Locality01 | 2020-02-02 05:57:56.755321 |
    | 0002a1416458f73b4d5f2baeedeb896b | 2020-02-02 | Locality09 | 2020-02-02 14:19:41.078018 |
    | ... | ... | ... | ... |  
3. Find the latest time that each subscriber was active in each locality, each day:  
    ```
    for each individual_date from start_date to end_date:  
        for each msisdn:  
            for each locality_to in located_calls.locality:  
                latest_visit = max(located_calls.call_datetime)
                               where located_calls.call_date=individual_date
                               and located_calls.msisdn=msisdn
                               and located_calls.locality=locality_to;
    ```  
    This should produce a `latest_visits` table, with columns `msisdn`, `call_date`, `locality_to` and `latest_visit`.  
    Example:
    |              msisdn              | call_date  |  locality_to  |        latest_visit        |
    | -------------------------------- | ---------- | ---------- | -------------------------- |
    | 0002a1416458f73b4d5f2baeedeb896b | 2020-02-01 | Locality09 | 2020-02-01 08:47:22.815032 |
    | 0002a1416458f73b4d5f2baeedeb896b | 2020-02-01 | Locality17 | 2020-02-01 19:55:13.274053 |
    | 0002a1416458f73b4d5f2baeedeb896b | 2020-02-01 | Locality29 | 2020-02-01 23:39:34.813259 |
    | 0002a1416458f73b4d5f2baeedeb896b | 2020-02-02 | Locality01 | 2020-02-02 05:57:56.755321 |
    | 0002a1416458f73b4d5f2baeedeb896b | 2020-02-02 | Locality09 | 2020-02-02 14:20:40.172956 |
    | ... | ... | ... | ... |  
4. Join the `earliest_visits` table to the `latest_visits` table, matching on columns `call_date` and `msisdn`.  
5. Select only the rows from the joined table where `earliest_visit <= latest_visit` (i.e. subscribers who visited `locality_from` before `locality_to`).  
    This should produce a table `pair_connections`, with columns `call_date`, `msisdn`, `locality_from` and `locality_to`.  
    Example:
    | call_date  |              msisdn              | locality_from | locality_to |
    | ---------- | -------------------------------- | ------------- | ----------- |
    | 2020-02-01 | 0002a1416458f73b4d5f2baeedeb896b | Locality09    | Locality09 |
    | 2020-02-01 | 0002a1416458f73b4d5f2baeedeb896b | Locality09    | Locality17 |
    | 2020-02-01 | 0002a1416458f73b4d5f2baeedeb896b | Locality09    | Locality29 |
    | 2020-02-01 | 0002a1416458f73b4d5f2baeedeb896b | Locality17    | Locality17 |
    | 2020-02-01 | 0002a1416458f73b4d5f2baeedeb896b | Locality17    | Locality29 |
    | ... | ... | ... | ... |  
6. For each pair of localities, count the number of unique subscribers who were active at `locality_from` before `locality_to` each day:  
    ```
    for each individual_date from start_date to end_date:  
        for each locality_from:  
            for each locality_to:  
                subscriber_count = count_unique(pair_connections.msisdn)
                                   where pair_connections.call_date=individual_date
                                   and pair_connections.locality_from=locality_from
                                   and pair_connections.locality_to=locality_to;
    ```
7. Only output rows with subscriber count > 15

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

The diagonals (i.e. the rows where `locality_from = locality_to`) should have the same subscriber count as the output of query 2 (_count_subscribers_per_locality_per_day_) for the same date and locality.
