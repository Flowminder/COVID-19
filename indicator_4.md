# Indicator 4: Count of unique ‘non-residents’, per region per week

## What is this?

This set of queries calculates the number of unique ‘visitors’ seen in each region each week. A subscriber is defined to be a ‘visitor’ in any region that they do not live in.

## How to produce the indicator

You can find the SQL code for producing this indicator in [indicators_3_4.sql](indicators_3_4.sql).

To produce this indicator, you need to run a sequence of queries. These are:

1. Count of unique subscribers per region per week - `unique_subscribers_per_region_per_week`
    See [Indicator 3](indicator_3.md) for description

2. Home locations for all subscribers - `home_locations`
    See description under [Indicator 2](indicator_2.md), and SQL code in [indicators_1_2.sql](indicators_1_2.sql)

3. Count of unique subscribers seen at their home region, each day - `count_unique_subscribers_home_region_per_week`
    *Description*: This calculates the number of subscribers that use their phone at their home location (see point (2) above) each week. When specifying the dates in the query, take care to include entire weeks in the date range. (E.g. the inbuilt `extract(‘week’)` function in Postgres assigns a number to each week, with weeks starting on Monday and ending on Sunday).

4. Subtract (3) from (1) to obtain the number of non-residents seen at each region, each day - `count_unique_residents_per_region_per_week`
    *Description*: For each date and region, this query subtracts the number of non-resident visitors from the total number of visitors.

## Usage and interpretation

This is similar to [Indicator 3](indicator_3.md), but excludes residents from the count in order to establish the degree of ‘outside traffic’ that the region receives from visitors. In cases where travel is severely restricted, the number of non-residents seen at each location should drop to close to zero. Indicators 2 and 4 can be analysed together to compare how locations with higher or lower degrees of ‘mixing’ have been affected by restrictions.
