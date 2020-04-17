# Count of travellers (origin-destination matrix, consecutive pairs), per pair of localities per time interval

## What is this?

This is the number of ‘_consecutive_ directional connections’ between each pair of localities, in each time interval. This is defined for each pair of localities A and B as the number of unique subscribers that have an event (call, SMS etc.) in locality A within a time interval, and whose next event in that time interval occurred in locality B.

For example, a subscriber who made calls from localities A, B and C in the sequence [A, A, B, C, A] would be counted in A->A, A->B, B->C and C->A.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [od_matrix_directed_consecutive_pairs.sql](od_matrix_directed_consecutive_pairs.sql).

The query [`od_matrix_directed_consecutive_pairs_per_day`](od_matrix_directed_consecutive_pairs.sql#L5-L32) is a standalone query which can be run by itself to produce the aggregate.

The first time you run this, you will need to include a timespan of data that includes the period before any mobility restrictions were enforced in your country, or before the first cases of COVID-19 were reported in your country. This is so that you can establish what ‘normal’ baseline behaviour looks like, and then see how this behaviour changed. We recommend that you include at least two weeks of ‘normal’ baseline data (i.e. the two weeks immediately before the announcement of restrictions or the outbreak), and preferably four weeks.

Once you have this baseline data, you can then run the query once every day, only looking at a single day’s data (yesterday).

We recommend that you calculate this aggregate for all available geographic divisions (e.g. state, municipality, district), and also modify the `od_matrix_directed_consecutive_pairs_per_day` query to count connections per hour (see [Note on calculating aggregates over multiple time intervals and locality sizes](README.md#calculating-aggregates-over-multiple-time-intervals-and-locality-sizes)).

## Usage and interpretation

This is similar to [_Count of travellers (origin-destination matrix, all pairs)_](od_matrix_directed_all_pairs.md), but includes the number of subscribers who 'stayed' within a locality (i.e. they remained there long enough make more than one call). For example, the count for `locality_from=A` and `locality_to=A` is the number of unique subscribers who had a stay in locality A on that day. In addition, and unlike [_Count of travellers (origin-destination matrix, all pairs)_](od_matrix_directed_all_pairs.md), a subscriber who called from locality A, then B, then C would be counted in movements from A->B, and B->C but _not_ A->C.
