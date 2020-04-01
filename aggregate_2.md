# Aggregate 2: Count of unique ‘non-residents’, per region per day

## What is this?

This set of queries calculates the number of unique ‘visitors’ seen in each region each day. A subscriber is defined to be a ‘visitor’ in any region that they do not live in.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [aggregates_1_2.sql](aggregates_1_2.sql).

To produce this aggregate, you need to run a sequence of queries in the following order. These are:

1. Count of unique subscribers per region per day - [`count_unique_subscribers_per_region_per_day`](aggregates_1_2.sql#L5-L20)  
    See [Aggregate 1](aggregate_1.md) for description

2. Home locations for all subscribers - [`home_locations`](intermediate_queries.sql#L5-L44)  
    See description under [Intermediate queries](intermediate_queries.md), and SQL code in [intermediate_queries.sql](intermediate_queries.sql).

3. Count of unique subscribers seen at their home region, each day - [`count_unique_active_residents_per_region_per_day`](aggregates_1_2.sql#L23-L39)  
    *Description*: This calculates the number of subscribers that use their phone at their home location (see point (2) above) each day.

4. Subtract (3) from (1) to obtain the number of non-residents seen at each region, each day - [`count_unique_visitors_per_region_per_day`](aggregates_1_2.sql#L41-L53)  
    *Description*: For each date and region, this query subtracts the number of active residents (calculated in step 3) from the total number of active subscribers (calculated in step 1) to obtain the number of outside visitors.

## Usage and interpretation

This is similar to [Aggregate 1](aggregate_1.md), but counts only the people at each location that do not live at that location, and therefore are ‘visitors’. In cases where travel is severely restricted, the number of non-residents seen at each location should drop to close to zero.
