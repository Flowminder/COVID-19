# Count of ‘home’ and ‘away’ visits (‘home-away matrix’), per day

## What is this?

For each pair of regions R1 and R2, each day, count the number of unique subscribers whose 'home location' is R1 and that used their phone in R2 during that day. See [intermediate_queries.md](intermediate_queries.md) for a definition of 'home location'.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [count_visits_home_away_per_day.sql](count_visits_home_away_per_day.sql)

To produce this aggregate, you need to run a sequence of queries in the following order. These are:

1. Home locations for all subscribers - [`home_locations`](intermediate_queries.sql#L5-L44)  
    See description under [Intermediate queries](intermediate_queries.md), and SQL code in [intermediate_queries.sql](intermediate_queries.sql).

2. Count of 'home' and 'away' visits per day - [`count_visits_home_away_per_day`](count_visits_home_away_per_day.sql#L5-L34)  
    *Description*: For each pair of regions R1 and R2, this query counts the number of unique subscribers whose 'home location' (as calculated in the previous query) is R1 and that used their phone in R2 during each day in the specified time period.

The first time you run this, you will need to include a timespan of data that includes the period before any mobility restrictions were enforced in your country, or before the first cases of COVID-19 were reported in your country. This is so that you can establish what ‘normal’ baseline behaviour looks like, and then see how this behaviour changed. We recommend that you include at least two weeks of ‘normal’ baseline data (i.e. the two weeks immediately before the announcement of restrictions or the outbreak), and preferably four weeks.

Once you have this baseline data, you can then run the `count_visits_home_away_per_day` query once every day, only looking at a single day’s data (yesterday).

## Usage and interpretation

This aggregate is similar to [Aggregate 1](aggregate_1.md), but contains more granular information (the number of active subscribers in each region whose home location is a given region, rather than just the total number of active subscribers in each region). In cases where travel is severely restricted, the number of subscribers active in regions away from their home should drop close to zero.

The diagonal of the home-away matrix (where `home_region = visit_region`) is the number of 'active residents' in each region, each day. This can be useful for scaling other aggregates.

This aggregate can also be used to identify regions with a large amount of mixing between subscribers from different home regions, which can help to indicate locations where the virus may spread between regions.