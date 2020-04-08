# Trips between consecutive locations per day

## What is this?

This is the number of ‘_consecutive_ directional connections’ between each pair of regions, each day. This is defined for each pair of regions as the number of unique subscribers that have visited the first region within a day, and next visited the second region that same day.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [od_matrix_directed_consecutive_pairs.sql](od_matrix_directed_consecutive_pairs.sql).

The query [`od_matrix_directed_consecutive_pairs`](od_matrix_directed_consecutive_pairs.sql#L5-30) is a standalone query which can be run by itself to produce the aggregate.

The first time you run this, you will need to include a timespan of data that includes the period before any mobility restrictions were enforced in your country, or before the first cases of COVID-19 were reported in your country. This is so that you can establish what ‘normal’ baseline behaviour looks like, and then see how this behaviour changed. We recommend that you include at least two weeks of ‘normal’ baseline data (i.e. the two weeks immediately before the announcement of restrictions or the outbreak), and preferably four weeks.

Once you have this baseline data, you can then run the query once every day, only looking at a single day’s data (yesterday).

## Usage and interpretation

This is similar to [Aggregate 6](aggregate_6.md), but includes the number of subscribers who 'stayed' within a region (i.e. they remained there long enough make more than one call). For example, the count for `region_from=A` and `region_to=A` is the number of unique subscribers who had a stay in region A on that day.
