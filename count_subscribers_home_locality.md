# Count of subscribers only seen in home locality, per locality per time interval

## What is this?

This is the total number of subscribers who are not seen outside of their 'home location' in each locality. See [home_locations.md](home_locations.md) for a definition of 'home location'.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [count_subscribers_home_locality.sql](count_subscribers_home_locality.sql).

To produce this aggregate, you need to run a sequence of queries in the following order. These are:

1. Home locations for all subscribers - [`home_locations`](home_locations.sql#L8-L47)  
   See description under [Home locations](home_locations.md), and SQL code in [home_locations.sql](home_locations.sql).

2. Count of static residents per locality per day - [`count_subscribers_home_locality_per_day`](count_subscribers_home_locality.sql#L5-L26)  
   _Description_: This query counts the number of subscribers who are only seen at their home location (as calculated in the previous query) in each locality on each day.

The first time you run this, you will need to include a timespan of data that includes the period before any mobility restrictions were enforced in your country, or before the first cases of COVID-19 were reported in your country. This is so that you can establish what ‘normal’ baseline behaviour looks like, and then see how this behaviour changed. We recommend that you include at least two weeks of ‘normal’ baseline data (i.e. the two weeks immediately before the announcement of restrictions or the outbreak), and preferably four weeks.

Once you have this baseline data, you can then run the `count_subscribers_home_locality_per_day` query once every day, only looking at a single day’s data (yesterday).

We recommend that you also modify the `count_subscribers_home_locality_per_day` query to count static residents per week (see [Note on calculating aggregates over multiple time intervals](README.md#calculating-aggregates-over-multiple-time-intervals-and-locality-sizes)). When aggregating by week, take care to specify a date range that includes entire weeks (e.g. the inbuilt `extract(WEEK FROM ...)` function in Postgres assigns a number to each week, with weeks starting on Monday and ending on Sunday).

## Usage and interpretation

This can be useful in combination with other aggregates. For example, counts of static subscribers per locality can be scaled using home location counts to get proportions of residents per locality who are adhering to mobility restrictions.
