# Aggregate 7: Total number of calls per region per day

## What is this?

This is the total number of calls in each region each day.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [aggregate_7.sql](aggregate_7.sql).

The query [`total_calls_per_region_per_day`](aggregate_7.sql#L5-L25) is a standalone query which can be run by itself to produce the aggregate.

The first time you run this, you will need to include a timespan of data that includes the period before any mobility restrictions were enforced in your country, or before the first cases of COVID-19 were reported in your country. This is so that you can establish what ‘normal’ baseline behaviour looks like, and then see how this behaviour changed. We recommend that you include at least two weeks of ‘normal’ baseline data (i.e. the two weeks immediately before the announcement of restrictions or the outbreak), and preferably four weeks.

Once you have this baseline data, you can then run the query once every day, only looking at a single day’s data (yesterday).

## Usage and interpretation

This can be used in combination with other aggregates to check whether changes in number of subscribers are due to changes in call volumes. For example, a decrease in the number of unique subscribers in a region (calculated in [Aggregate 1](aggregate_1.md)) may be due to fewer people present in that region, or may simply be due to fewer subscribers making calls in that region. This aggregate can help to distinguish between those cases.