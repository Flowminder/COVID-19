# Count of total active subscribers per time interval

## What is this?

This is the number of unique subscribers that used their phone at any cell tower, at any time during the time interval. This is different from [_Count of active subscribers per locality_](count_subscribers.md) in that this is the _total_ number of unique active subscribers across all localities.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [total_subscribers.sql](total_subscribers.sql).

The query [`total_subscribers_per_day`](total_subscribers.sql#L5-L15) is a standalone query which can be run by itself to produce the aggregate for each day in the specified period.

The first time you run this, you will need to include a timespan of data that includes the period before any mobility restrictions were enforced in your country, or before the first cases of COVID-19 were reported in your country. This is so that you can establish what ‘normal’ baseline behaviour looks like, and then see how this behaviour changed. We recommend that you include at least two weeks of ‘normal’ baseline data (i.e. the two weeks immediately before the announcement of restrictions or the outbreak), and preferably four weeks.

Once you have this baseline data, you can then run the query once every day, only looking at a single day’s data (yesterday).

We recommend that you modify the `total_subscribers_per_day` query to calculate this aggregate for each of the time intervals hour, day and week. When aggregating by week, take care to specify a date range that includes entire weeks (e.g. the inbuilt `extract(WEEK FROM ...)` function in Postgres assigns a number to each week, with weeks starting on Monday and ending on Sunday). See [Note on calculating aggregates over multiple time intervals](README.md#calculating-aggregates-over-multiple-time-intervals-and-locality-sizes).

## Usage and interpretation

This aggregate can be used to scale other aggregates. For example, if the aggregate [_Count of active subscribers per locality_](count_subscribers.md) shows an increase in the number of active subscribers in a locality, this could be because subscribers have moved there from a different locality, or the number of subscribers has stayed the same but more of them are using their phones. Scaling counts per locality by the count of total active subscribers across all localities can help to correct for this effect.

Note: this aggregate is not equivalent to summing `count_subscribers_per_locality_per_day` across all localities, because in that situation subscribers who were active in multiple localities would be counted multiple times.