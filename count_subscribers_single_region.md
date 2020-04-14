# Count of subscribers that are seen only in one region per region per day

## What is this?

This is the total number of unique subscribers who are seen in only _one_ region in each time period.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [count_subscribers_single_region.sql](count_subscribers_single_region.sql).

The query [`count_subscribers_single_region`](count_subscribers_single_region.sql#L5-L25) is a standalone query which can be run by itself to produce the aggregate.

The first time you run this, you will need to include a timespan of data that includes the period before any mobility restrictions were enforced in your country, or before the first cases of COVID-19 were reported in your country. This is so that you can establish what ‘normal’ baseline behaviour looks like, and then see how this behaviour changed. We recommend that you include at least two weeks of ‘normal’ baseline data (i.e. the two weeks immediately before the announcement of restrictions or the outbreak), and preferably four weeks.

## Usage and interpretation

This can be useful in combination with other aggregates. For example, counts of static subscribers per region can be scaled using subscriber counts to get proportions of subscribers who are adhering to mobility restrictions per region.
