# Aggregate 8: Home location counts per region

## What is this?

This is the total number of subscribers whose 'home location' is in each region. See [intermediate_queries.md](intermediate_queries.md) for a definition of 'home location'.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [aggregate_8.sql](aggregate_8.sql).

To produce this aggregate, you need to run a sequence of queries in the following order. These are:

1. Home locations for all subscribers - [`home_locations`](intermediate_queries.sql#L5-L44)  
    See description under [Intermediate queries](intermediate_queries.md), and SQL code in [intermediate_queries.sql](intermediate_queries.sql).

2. Home location counts per region - [`home_location_counts_per_region`](aggregate_8.sql#L5-L14)  
    *Description*: This query counts the number of subscribers whose home locations (as calculated in the previous query) are in each region.

## Usage and interpretation

This can be useful in combination with other aggregates. For example, counts of subscribers per region can be scaled using home location counts to get proportions of residents per region.