# Static residents count per region per day

## What is this?

This is the total number of subscribers who are not seen outside of their 'home location' in each region. See [intermediate_queries.md](intermediate_queries.md) for a definition of 'home location'.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [count_subscribers_home_region_per_day.sql](count_subscribers_home_region_per_day.sql).

To produce this aggregate, you need to run a sequence of queries in the following order. These are:

1. Home locations for all subscribers - [`home_locations`](intermediate_queries.sql#L5-L44)  
   See description under [Intermediate queries](intermediate_queries.md), and SQL code in [intermediate_queries.sql](intermediate_queries.sql).

2. Count of static residents per region per day - [`count_subscribers_home_region_per_day`](count_subscribers_home_region_per_day.sql#L5-L22)  
   _Description_: This query counts the number of subscribers who are only seen at their home location (as calculated in the previous query) in each region on each day.

## Usage and interpretation

This can be useful in combination with other aggregates. For example, counts of static subscribers per region can be scaled using home location counts to get proportions of residents who are adhering to mobility restrictions per region.
