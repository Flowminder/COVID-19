# Count of residents (home location counts), per locality

## What is this?

This is the total number of subscribers whose 'home location' is in each locality. See [Home locations](home_locations.md) for a definition of 'home location'.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [count_residents.sql](count_residents.sql).

To produce this aggregate, you need to run a sequence of queries in the following order. These are:

1. Home locations for all subscribers - [`home_locations`](home_locations.sql#L5-L44)  
    See description under [Home locations](home_locations.md), and SQL code in [home_locations.sql](home_locations.sql).

2. Home location counts per locality - [`count_residents_per_locality`](count_residents.sql#L5-L14)  
    *Description*: This query counts the number of subscribers whose home locations (as calculated in the previous query) are in each locality.

## Usage and interpretation

This can be useful in combination with other aggregates. For example, counts of subscribers per locality can be scaled using home location counts to get proportions of residents per locality.