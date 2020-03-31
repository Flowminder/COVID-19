# Aggregate 4: Count of unique ‘non-residents’, per region per week

## What is this?

This set of queries calculates the number of unique ‘visitors’ seen in each region each week. A subscriber is defined to be a ‘visitor’ in any region that they do not live in.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [aggregates_3_4.sql](aggregates_3_4.sql).

To produce this aggregate, you need to run a sequence of queries. These are:

1. Count of unique subscribers per region per week - [`unique_subscribers_per_region_per_week`](aggregates_3_4.sql#L5-L20)  
    See [Aggregate 3](aggregate_3.md) for description

2. Home locations for all subscribers - [`home_locations`](intermediate_queries.sql#L5-L44)  
    See description under [Intermediate queries](intermediate_queries.md), and SQL code in [intermediate_queries.sql](intermediate_queries.sql).

3. Count of unique subscribers seen at their home region, each week - [`count_unique_active_residents_per_week`](aggregates_3_4.sql#L24-L42)  
    *Description*: This calculates the number of subscribers that use their phone at their home location (see point (2) above) each week. When specifying the dates in the query, take care to include entire weeks in the date range. (E.g. the inbuilt `extract(‘week’)` function in Postgres assigns a number to each week, with weeks starting on Monday and ending on Sunday).

4. Subtract (3) from (1) to obtain the number of non-residents seen at each region, each week - [`count_unique_visitors_per_region_per_week`](aggregates_3_4.sql#L44-L57)  
    *Description*: For each week and region, this query subtracts the number of active residents (calculated in step 3) from the total number of active subscribers (calculated in step 1) to obtain the number of outside visitors.

## Usage and interpretation

This is similar to [Aggregate 3](aggregate_3.md), but excludes residents from the count in order to establish the degree of ‘outside traffic’ that the region receives from visitors. In cases where travel is severely restricted, the number of non-residents seen at each location should drop to close to zero. Aggregates 2 and 4 can be analysed together to compare how locations with higher or lower degrees of ‘mixing’ have been affected by restrictions.
