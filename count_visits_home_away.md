# Count of visits at home and away (home-away matrix), per pair of localities per time interval

## What is this?

For each pair of localities R1 and R2, in each time interval, count the number of unique subscribers whose 'home location' is R1 and that used their phone in R2 during the specified time interval. See [home_locations.md](home_locations.md) for a definition of 'home location'.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [count_visits_home_away.sql](count_visits_home_away.sql).

To produce this aggregate, you need to run a sequence of queries in the following order. These are:

1. Home locations for all subscribers - [`home_locations`](home_locations.sql#L8-L47)  
    See description under [Home locations](home_locations.md), and SQL code in [home_locations.sql](home_locations.sql).

2. Count of 'home' and 'away' visits per day - [`count_visits_home_away_per_day`](count_visits_home_away.sql#L5-L33)  
    *Description*: For each pair of localities R1 and R2, this query counts the number of unique subscribers whose 'home location' (as calculated in the previous query) is R1 and that used their phone in R2 during each day in the specified time period.

The first time you run this, you will need to include a timespan of data that includes the period before any mobility restrictions were enforced in your country, or before the first cases of COVID-19 were reported in your country. This is so that you can establish what ‘normal’ baseline behaviour looks like, and then see how this behaviour changed. We recommend that you include at least two weeks of ‘normal’ baseline data (i.e. the two weeks immediately before the announcement of restrictions or the outbreak), and preferably four weeks.

Once you have this baseline data, you can then run the `count_visits_home_away_per_day` query once every day, only looking at a single day’s data (yesterday).

We recommend that you also modify the `count_visits_home_away_per_day` query to count 'home' and 'away' visits per hour (see [Note on calculating aggregates over multiple time intervals](README.md#calculating-aggregates-over-multiple-time-intervals-and-locality-sizes)).

## Usage and interpretation

This aggregate is similar to [_Count of active subscribers_](count_subscribers.md), but contains more granular information (the number of active subscribers in each locality whose home location is a given locality, rather than just the total number of active subscribers in each locality). In cases where travel is severely restricted, the number of subscribers active in localities away from their home should drop close to zero.

The diagonal of the home-away matrix (where `home_locality = visit_locality`) is the number of 'active residents' in each locality, for each time interval. This can be useful for scaling other aggregates.

This aggregate can also be used to identify localities with a large amount of mixing between subscribers from different home locations, which can help to indicate locations where the virus may spread between localities.