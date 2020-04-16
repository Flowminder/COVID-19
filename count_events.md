# Count of events, per locality per hour

## What is this?

This is the total number of 'events' (calls, SMS and/or mobile data sessions, depending on the dataset) in each locality, each hour.

## How to produce the aggregate

You can find the SQL code for producing this aggregate in [count_events.sql](count_events.sql).

The query [`count_events_per_locality_per_hour`](count_events.sql#L5-L27) is a standalone query which can be run by itself to produce the aggregate.

The first time you run this, you will need to include a timespan of data that includes the period before any mobility restrictions were enforced in your country, or before the first cases of COVID-19 were reported in your country. This is so that you can establish what ‘normal’ baseline behaviour looks like, and then see how this behaviour changed. We recommend that you include at least two weeks of ‘normal’ baseline data (i.e. the two weeks immediately before the announcement of restrictions or the outbreak), and preferably four weeks.

Once you have this baseline data, you can then run the query once every day, only looking at a single day’s data (yesterday).

## Usage and interpretation

It is necessary to count the total number of calls recorded each day in order to check whether any apparent increase/decrease in mobility is actually just due to an increase/decrease in phone usage. This is because we only ‘see’ a subscriber in the dataset when they use their phone. It may be the case that a subscriber normally travels a lot and visits several different localities, but only ever uses their phone when they are at home. Therefore, we would not be able to detect that they have visited other localities. If they start to use their phone more but maintain their normal travel behaviour, then we will start to see them in different localities and may then conclude that they are now travelling more, when in fact they are just using their phone more frequently.

If you observe a significant change in call volumes occurring at the same time that mobility restrictions were introduced, then you should bear this in mind when interpreting any apparent ‘changes’ in mobility behaviour.
