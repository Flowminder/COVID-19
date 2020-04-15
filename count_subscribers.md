# Count of unique subscribers, per locality per time interval

## What is this?

For each locality, this is the number of unique subscribers that used their phone at any cell tower in that locality, at any time during the time interval.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [count_subscribers.sql](count_subscribers.sql). We recommend that you calculate this aggregate for all available geographic divisions (e.g. state, municipality, district), for each of the time intervals hour, day and week. When aggregating by week, take care to specify a date range that includes entire weeks (e.g. the inbuilt `extract(WEEK FROM ...)` function in Postgres assigns a number to each week, with weeks starting on Monday and ending on Sunday).

The query [`count_subscribers_per_locality_per_day`](count_subscribers.sql#L5-L20) is a standalone query which can be run by itself to produce the aggregate for each day in the specified period. The queries [`count_subscribers_per_locality_per_week`](count_subscribers.sql#L23-L38) and [`count_subscribers_per_locality_per_hour`](count_subscribers.sql#L41-L57) are equivalent, but calculate the aggregate per week and per hour, respectively.

The first time you run this, you will need to include a timespan of data that includes the period before any mobility restrictions were enforced in your country, or before the first cases of COVID-19 were reported in your country. This is so that you can establish what ‘normal’ baseline behaviour looks like, and then see how this behaviour changed. We recommend that you include at least two weeks of ‘normal’ baseline data (i.e. the two weeks immediately before the announcement of restrictions or the outbreak), and preferably four weeks.

Once you have this baseline data, you can then run the query once every day, only looking at a single day’s data (yesterday).

## Usage and interpretation

Looking at how this aggregate changes over time provides an indication of how government restrictions are affecting people’s mobility behaviour. You will be able to see which localities have seen a decrease in the number of people visiting that locality, and the size of the decrease.

The results of this aggregate for different time intervals (e.g. per day and per week) can be combined to identify locations where a lot of ‘mixing’ may occur between different groups of people: A location may experience a high number of visitors each day, with the same people visiting each day. Then there may be locations which receive fewer visitors each day, but because different people visit each day, the number of distinct visitors seen over a week is higher. This would indicate that the second location potentially experiences a higher degree of ‘mixing’ than the first location. ‘Mixing’ means interaction between distinct groups of people that normally do not interact.