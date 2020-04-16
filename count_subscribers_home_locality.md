# Count of ‘static’ residents, per locality per time interval

## What is this?

This is the total number of subscribers who are not seen outside of their 'home location' in each locality. See [home_locations.md](home_locations.md) for a definition of 'home location'.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [count_subscribers_home_locality.sql](count_subscribers_home_locality.sql).

To produce this aggregate, you need to run a sequence of queries in the following order. These are:

1. Home locations for all subscribers - [`home_locations`](home_locations.sql#L5-L44)  
   See description under [Home locations](home_locations.md), and SQL code in [home_locations.sql](home_locations.sql).

2. Count of static residents per locality per day - [`count_subscribers_home_locality_per_day`](count_subscribers_home_locality.sql#L5-L26)  
   _Description_: This query counts the number of subscribers who are only seen at their home location (as calculated in the previous query) in each locality on each day.

We recommend that you also modify the query [`count_subscribers_home_locality_per_day`](count_subscribers_home_locality.sql#L5-L26) to count static residents per week (see [Note on calculating aggregates over multiple time intervals](README.md#calculating-aggregates-over-multiple-time-intervals-and-locality-sizes)).

## Usage and interpretation

This can be useful in combination with other aggregates. For example, counts of static subscribers per locality can be scaled using home location counts to get proportions of residents per locality who are adhering to mobility restrictions.
