# Count of subscribers only seen in one locality, per locality per time interval

## What is this?

This is the total number of unique subscribers who are seen in only _one_ locality in each time interval.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [count_subscribers_single_locality.sql](count_subscribers_single_locality.sql).

The query [`count_subscribers_single_locality_per_day`](count_subscribers_single_locality.sql#L5-L25) is a standalone query which can be run by itself to produce the aggregate.

The first time you run this, you will need to include a timespan of data that includes the period before any mobility restrictions were enforced in your country, or before the first cases of COVID-19 were reported in your country. This is so that you can establish what ‘normal’ baseline behaviour looks like, and then see how this behaviour changed. We recommend that you include at least two weeks of ‘normal’ baseline data (i.e. the two weeks immediately before the announcement of restrictions or the outbreak), and preferably four weeks.

Once you have this baseline data, you can then run the `count_subscribers_single_locality_per_day` query once every day, only looking at a single day’s data (yesterday).

We recommend that you also modify the `count_subscribers_single_locality_per_day` query to count single-locality subscribers per week (see [Note on calculating aggregates over multiple time intervals](README.md#calculating-aggregates-over-multiple-time-intervals-and-locality-sizes)). When aggregating by week, take care to specify a date range that includes entire weeks (e.g. the inbuilt `extract(WEEK FROM ...)` function in Postgres assigns a number to each week, with weeks starting on Monday and ending on Sunday).

## Usage and interpretation

This can be useful in combination with other aggregates. For example, counts of static subscribers per locality can be scaled using subscriber counts to get proportions of subscribers per locality who are adhering to mobility restrictions.
