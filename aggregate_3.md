# Aggregate 3: Count of unique subscribers, per region per week

## What is this?

This is the number of unique subscribers seen in each region, each week. 

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [aggregates_3_4.sql](aggregates_3_4.sql).

The query [`count_unique_subscribers_per_region_per_week`](aggregates_3_4.sql#L5-L20) is a standalone query which can be run by itself to produce the aggregate. When specifying the dates in the query, take care to include entire weeks in the date range. (E.g. the inbuilt `extract(WEEK FROM ...)` function in Postgres assigns a number to each week, with weeks starting on Monday and ending on Sunday).

## Usage and interpretation

This can be combined with [Aggregate 1](aggregate_1.md) to identify locations where a lot of ‘mixing’ may occur between different groups of people: A location may experience a high number of visitors each day, with the same people visiting each day. Then there may be locations which receive fewer visitors each day, but because different people visit each day, the number of distinct visitors seen over a week is higher. This would indicate that the second location potentially experiences a higher degree of ‘mixing’ than the first location. ‘Mixing’ means interaction between distinct groups of people that normally do not interact.
