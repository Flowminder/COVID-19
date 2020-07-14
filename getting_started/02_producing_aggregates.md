# Getting started: producing the aggregates

This file describes the steps required to produce outputs for three of the aggregate queries in this repository. We recommend that these should be the first three queries calculated, as they are fairly simple to implement, should be compatible with most SQL-supporting systems, and are sufficient to produce some mobility indicators that can be of use to decision makers.

It covers the steps required before calculating the aggregates, descriptions of the aggregate queries, and guidance on checking that the outputs are correct.

Before reading through this document, we recommend working through [01_running_a_test_query.md](01_running_a_test_query.md) to ensure that you have identified the correct data structure and are able to query the CDR data.

## Initial steps

### 1. Choose localities

Before producing any aggregates, it is necessary to choose the set of spatial localities to which data will be aggregated. Typically it is best to use administrative divisions, as these will be more useful to government decision makers than other spatial divisions such as sales regions. Aggregating to this set of spatial localities, instead of to cell sites, means that outputs can be shared without revealing commercially sensitive information about cell tower locations, and also enables easier comparison of indicators derived from CDR data from different MNOs.

Once a suitable set of localities has been selected, each cell tower must be assigned to the appropriate locality. The aim here is to create a table with two columns: one column with the cell ID (which should correspond to the values in the `location_id` column of the CDR data), and another with the identifier of the locality to which each cell is assigned. The SQL queries in this repository expect this information to be in a table called `cells`, with columns `cell_id` and `locality`.

Example of `cells` table:

| cell_id |  locality  |
| ------- | ---------- |
| 00070   | Locality01 |
| 00040   | Locality01 |
| 00049   | Locality01 |
| 00036   | Locality01 |
| 00047   | Locality02 |
| ... | ... |

At this stage it is important to check for errors in the cell locations information. Some common issues that should be checked are:

- Check that no cell towers have obviously incorrect locations (for example in the sea or outside the country borders),  
- Check that each cell has a unique ID (i.e. no duplicated cell IDs corresponding to different tower locations),  
- If cell towers are already associated with spatial regions, check that the location of each tower is within the spatial region with which it is associated.  

If you are not sure how to create this mapping table, you may find it helpful to look at the advice on our [COVID-19 website](https://covid19.flowminder.org/cdr-aggregates/understanding-cdr-aggregates-fundamentals#h.82tox8a9gwpz).

### 2. Choose date range

The queries described below will produce aggregated outputs for each day in a specified date range.

The first time each query is run, this date range should include a 'baseline' period before the COVID-19 crisis began, to which outputs during the crisis can be compared. We recommend that the date range for the first run should start at least 4 weeks before the first mobility restrictions were announced, and end at the current date.

After these first outputs have been produced, updated outputs can be produced at regular intervals (daily, or a few times per week) to provide insights into mobility in the most recent days. For these runs, the date range only needs to cover the few days since the last outputs were produced. It is important to ensure that a full day of CDR data is available before producing aggregates for that day.

In the descriptions below, we use `start_date` and `end_date` to refer to the start and end dates of this date range.

## Aggregates

The first three aggregates we would recommend calculating are [`total_subscribers_per_day`](../total_subscribers.md), [`count_subscribers_per_locality_per_day`](../count_subscribers.md) and [`od_matrix_directed_all_pairs_per_day`](../od_matrix_directed_all_pairs.md).

If your database / data analysis system can execute SQL queries, the queries in [total_subscribers.sql](../total_subscribers.sql#L5-L19), [count_subscribers.sql](../count_subscribers.sql#L5-L20) and [od_matrix_directed_all_pairs.sql](../od_matrix_directed_all_pairs.sql#L5-L51) can be used. As noted above, the names of tables and columns may need to be changed to match your data structure. Additionally, it may be necessary to modify or optimise the queries to suit your data system.

In case your system does not support running SQL queries, or it would be preferable to implement the queries in a different query language, the steps to produce these three aggregates are described in the document [02b_description_of_queries.md](02b_description_of_queries.md).

Below are some example outputs from the three queries.

`total_subscribers_per_day`:

| call_date  | subscriber_count |
| ---------- | ---------------- |
| 2020-02-01 |             9549 |
| 2020-02-02 |             9458 |
| 2020-02-03 |             9522 |
| 2020-02-04 |             9463 |
| 2020-02-05 |             9495 |
| ... | ... |

`count_subscribers_per_locality_per_day`:

| visit_date |  locality  | subscriber_count |
| ---------- | ---------- | ---------------- |
| 2020-02-01 | Locality01 |             1161 |
| 2020-02-01 | Locality02 |              301 |
| 2020-02-01 | Locality03 |              286 |
| 2020-02-01 | Locality04 |             1076 |
| 2020-02-01 | Locality05 |              308 |
| ... | ... | ... |

`od_matrix_directed_all_pairs_per_day`:

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

- The subscriber counts in _total_subscribers_per_day_ should be close to the size of your total subscriber base (they will be slightly less than this, because not all subscribers will be active every day).  
- The subscriber counts in urban localities (in _count_subscribers_per_locality_per_day_) should be larger than those in rural localities.  
- The sum of subscriber counts in _count_subscribers_per_locality_per_day_ across all localities each day should be greater than the subscriber count in _total_subscribers_per_day_ for the same day (because some subscribers will be active in more than one locality). If this is not the case, this suggests that there is an issue with the implementation of one of the queries (for example, if both counts are equal this suggests that the queries may be counting CDR events rather than unique subscribers).  
- The subscriber counts in the diagonal of _od_matrix_directed_all_pairs_per_day_ (i.e. the rows with `locality_from=locality_to`) should be equal to the subscriber counts in _count_subscribers_per_locality_per_day_ for the same date and locality. If these are not equal, this suggests that there is an issue with the implementation of one of the queries.  
- All subscriber counts in each of the three aggregates should be greater than 15. If this is not the case, then the final redaction step of the aggregate query has not been performed.  
- Plotting a graph of subscriber counts over time should show a clear weekly pattern of variation (for example, subscriber counts on Sundays may be lower than on weekdays). If there is no such pattern evident in the data, this could indicate an issue with the data or the calculation of aggregates.  
- Compare the subscriber counts each day to the corresponding subscriber counts for the previous days/weeks. A large change from one day to the next could indicate an issue with the data (for example, the aggregates may have been calculated on an incomplete temporal subset of the CDR data for that day, or data from some cells may be missing or incorrectly assigned to localities).

We will be updating this section with some additional queries that can be run for data checking purposes.
