# Intermediate queries

The file [intermediate_queries.sql](intermediate_queries.sql) contains SQL code for some intermediate queries whose results are used to produce some of the aggregates. These intermediate queries produce subscriber-level (i.e. non-aggregated) results, which should kept within the MNO's system to protect subscribers' privacy.

The following intermediate queries are defined:

1. Home locations for all subscribers - [`home_locations`](intermediate_queries.sql#L5-L44)  
    *Description*: This query allocates each subscriber to a region that is defined to be their ‘home location’. We do this by assuming that a subscriber uses their phone for the last time each day in their home region, and then find the modal region (the region with the most counts) over the course of a month. We recommend that you use a period of data that begins one month before travel restrictions or the COVID-19 outbreak was announced in your country, and ends on the day of the announcement.
