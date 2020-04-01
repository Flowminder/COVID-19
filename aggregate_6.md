# Aggregate 6: Directional connections between pairs of regions - count of unique subscribers moving between each pair of locations, each day

## What is this?

This is the number of ‘directional connections’ between each pair of regions, each day. This is defined for each pair of regions as the number of unique subscribers that have visited the first region within a day, and visited the second region later the same day.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [aggregate_6.sql](aggregate_6.sql).

The query [`directed_regional_pair_connections_per_day`](aggregate_6.sql#L5-L43) is a standalone query which can be run by itself to produce the aggregate.

The first time you run this, you will need to include a timespan of data that includes the period before any mobility restrictions were enforced in your country, or before the first cases of COVID-19 were reported in your country. This is so that you can establish what ‘normal’ baseline behaviour looks like, and then see how this behaviour changed. We recommend that you include at least two weeks of ‘normal’ baseline data (i.e. the two weeks immediately before the announcement of restrictions or the outbreak), and preferably four weeks.

Once you have this baseline data, you can then run the query once every day, only looking at a single day’s data (yesterday).

## Usage and interpretation

This is similar to [Aggregate 5](aggregate_5.md), but accounts for the direction of travel. For example, the count for `region_from=A` and `region_to=B` is the number of unique subscribers seen in region A _before_ region B within the day.
