# Indicator 1: Count of unique subscribers, per region per day

## What is this?

This is the number of unique subscribers seen in each region, each day.

## How to produce the indicator

The query ‘count_unique_subscribers_per_region_per_day’ is a standalone query which can be run by itself to produce the indicator.

The first time you run this, you will need to include a timespan of data that includes the period before any mobility restrictions were enforced in your country, or before the first cases of COVID-19 were reported in your country. This is so that you can establish what ‘normal’ baseline behaviour looks like, and then see how this behaviour changed. We recommend that you include at least two weeks of ‘normal’ baseline data (i.e. the two weeks immediately before the announcement of restrictions or the outbreak), and preferably four weeks.

Once you have this baseline data, you can then run the query once every day, only looking at a single day’s data (yesterday).

## Usage and interpretation

Looking at how this indicator changes over time (each day) provides an indication of how government restrictions are affecting people’s mobility behaviour. You will be able to see which regions have seen a decrease in the number of people visiting that region, and the size of the decrease.
