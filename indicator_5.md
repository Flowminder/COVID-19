# Indicator 5: ‘Connectivity’ between pairs of regions - count of unique subscribers seen at each pair of locations, each day

## What is this?

This is the number of ‘connections’ between each pair or regions, each day. This is defined as the number of unique subscribers that have visited each pair or regions, within a day.

## How to produce the indicator

You can find the SQL code for producing this indicator in [indicator_5.sql](indicator_5.sql).

The query [`regional_pair_connections_per_day`](indicator_5.sql#L5-L51) is a standalone query which can be run by itself to produce the indicator.

The first time you run this, you will need to include a timespan of data that includes the period before any mobility restrictions were enforced in your country, or before the first cases of COVID-19 were reported in your country. This is so that you can establish what ‘normal’ baseline behaviour looks like, and then see how this behaviour changed. We recommend that you include at least two weeks of ‘normal’ baseline data (i.e. the two weeks immediately before the announcement of restrictions or the outbreak), and preferably four weeks.

Once you have this baseline data, you can then run the query once every day, only looking at a single day’s data (yesterday).

## Usage and interpretation

This indicator is a simple measure of how much travel is occurring between each pair of regions. We would expect to see a decrease in the number of connections between regions that are affected by travel restrictions. It will be possible to see which regions are still connected with each other, and which ones have become disconnected.
