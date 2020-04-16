# Home locations

The file [home_locations.sql](home_locations.sql) contains SQL code for an intermediate query that assigns a single 'home' locality to each subscriber. These 'home locations' are used by some of the aggregate queries.

**Note**:This intermediate query produces subscriber-level (i.e. non-aggregated) results, which should kept within the MNO's system to protect subscribers' privacy.

The [`home_locations`](home_locations.sql#L5-L44) query allocates each subscriber to a locality that is defined to be their ‘home location’, based on where they most frequently use their phone for the last time each day, which is assumed to be from ‘home’. We do this using the following steps:

1. Specify a time period. We recommend using the four-week period immediately preceding the date that mobility restrictions were introduced.  
2. For each day in the specified period, identify the region that each subscriber was in when they used their phone for the last time that day. If a subscriber did not use their phone one day, no region is assigned to them for that day.  
3. For each subscriber, identify the modal region from step (2). If there is more than one modal region, the one that is the subscriber’s most recent ‘last location of day’ is selected.  
