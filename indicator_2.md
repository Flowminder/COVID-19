# Indicator 2: Count of unique ‘non-residents’, per region per day

## What is this?

This set of queries calculates the number of unique ‘visitors’ seen in each region each day. A subscriber is defined to be a ‘visitor’ in any region that they do not live in.

## How to produce the indicator

You can find the SQL code for producing this indicator in [indicators_1_2.sql](indicators_1_2.sql).

To produce this indicator, you need to run a sequence of queries in the following order. These are:

1. Count of unique subscribers per region per day - [`count_unique_subscribers_per_region_per_day`](indicators_1_2.sql#L5-L20)  
    See [Indicator 1](indicator_1.md) for description

2. Home locations for all subscribers - [`home_locations`](indicators_1_2.sql#L24-L51)  
    *Description*: This query allocates each subscriber to a region that is defined to be their ‘home location’. We do this by assuming that a subscriber uses their phone for the last time each day in their home region, and then find the modal region (the region with the most counts) over the course of a month. We recommend that you use a period of data that begins one month before travel restrictions or the COVID-19 outbreak was announced in your country, and ends on the day of the announcement.

3. Count of unique subscribers seen at their home region, each day - [`count_unique_active_residents_per_day`](indicators_1_2.sql#L54-L70)  
    *Description*: This calculates the number of subscribers that use their phone at their home location (see point (2) above) each day.

4. Subtract (3) from (1) to obtain the number of non-residents seen at each region, each day - [`count_unique_visitors_per_region_per_day`](indicators_1_2.sql#L72-L84)  
    *Description*: For each date and region, this query subtracts the number of active residents (calculated in step 3) from the total number of active subscribers (calculated in step 1) to obtain the number of outside visitors.

## Usage and interpretation

This is similar to [Indicator 1](indicator_1.md), but counts only the people at each location that do not live at that location, and therefore are ‘visitors’. In cases where travel is severely restricted, the number of non-residents seen at each location should drop to close to zero.
