# Count of travellers (connections triangular matrix), per pair of localities per time interval

## What is this?

This is the number of ‘connections’ between each pair of localities in each time interval. This is defined for each pair of localities as the number of unique subscribers that have visited _both_ localities within the time interval.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [od_matrix_undirected_all_pairs.sql](od_matrix_undirected_all_pairs.sql).

The query [`od_matrix_undirected_all_pairs_per_day`](od_matrix_undirected_all_pairs.sql#L5-L51) is a standalone query which can be run by itself to produce the aggregate.

The first time you run this, you will need to include a timespan of data that includes the period before any mobility restrictions were enforced in your country, or before the first cases of COVID-19 were reported in your country. This is so that you can establish what ‘normal’ baseline behaviour looks like, and then see how this behaviour changed. We recommend that you include at least two weeks of ‘normal’ baseline data (i.e. the two weeks immediately before the announcement of restrictions or the outbreak), and preferably four weeks.

Once you have this baseline data, you can then run the query once every day, only looking at a single day’s data (yesterday).

We recommend that you calculate this aggregate for all available geographic divisions (e.g. state, municipality, district), and also modify the `od_matrix_undirected_all_pairs_per_day` query to count connections per hour (see [Note on calculating aggregates over multiple time intervals and locality sizes](README.md#calculating-aggregates-over-multiple-time-intervals-and-locality-sizes)).

## Usage and interpretation

This aggregate is a simple measure of how much travel is occurring between each pair of localities. This is similar to [_Count of travellers (origin-destination matrix, all pairs)_](od_matrix_directed_all_pairs.sql), but does not account for the direction of movement. We would expect to see a decrease in the number of connections between localities that are affected by travel restrictions. It will be possible to see which localities are still connected with each other, and which ones have become disconnected.
