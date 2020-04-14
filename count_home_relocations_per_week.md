# Count of home relocations, per week

## What is this?

For each pair of regions R1 and R2, each week, count the number of unique subscribers whose 'home location' was R1 during a reference period before mobility restrictions began, and whose 'home location' during this week was R2. See [intermediate_queries.md](intermediate_queries.md) for a definition of 'home location'.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [count_home_relocations_per_week.sql](count_home_relocations_per_week.sql)

To produce this aggregate, you need to run a sequence of queries in the following order. These are:

1. Home locations for all subscribers, during reference period before mobility restrictions began - [`home_locations`](intermediate_queries.sql#L5-L44)  
    See description under [Intermediate queries](intermediate_queries.md), and SQL code in [intermediate_queries.sql](intermediate_queries.sql).

2. Count of subscribers' home relocations per week - [`count_home_relocations_per_week`](count_home_relocations_per_week.sql#L5-L59)  
    *Description*: For each pair of regions R1 and R2, this query counts the number of unique subscribers whose 'home location' was R1 during the reference period (as calculated in the previous query) and whose 'home location' is R2 during each week in the specified time period.

The first time you run this, you will need to include a timespan of data that includes the period before any mobility restrictions were enforced in your country, or before the first cases of COVID-19 were reported in your country. This is so that you can establish what ‘normal’ baseline behaviour looks like, and then see how this behaviour changed. We recommend that you include at least two weeks of ‘normal’ baseline data (i.e. the two weeks immediately before the announcement of restrictions or the outbreak), and preferably four weeks.

Once you have run the `home_locations` query for the reference period (as described in [Intermediate queries](intermediate_queries.md)), you can then run the `count_home_relocations_per_week` query once every week. When specifying the dates in the query, take care to include entire weeks in the date range. (E.g. the inbuilt `extract(WEEK FROM ...)` function in Postgres assigns a number to each week, with weeks starting on Monday and ending on Sunday).

## Usage and interpretation

This aggregate can be used to identify the number of subscribers whose home region has changed since mobility restrictions began. Comparing the results of this aggregate over time can indicate the time taken for a region to return to its pre-crisis population size.