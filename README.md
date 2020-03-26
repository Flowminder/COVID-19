# Data insights for COVID-19 response: resources for producing mobility indicators and analysis from CDR data

## Overview

The code in this repository produces indicators from CDR data that by themselves, or in combination with other data sources,
can support governments and health experts with their response to the COVID-19 outbreak. 
A description of each indicator is provided alongside the code, together with suggestions for how it can be used. 
We will start to add guidelines on how to analyse these indicators in the coming days. 

We have initially focused on producing code and guidelines for mobile network operators that may have limited technical capacity, 
especially those in low- and middle-income countries. This means that the code we have provided is both simple to modify, 
and also should not be extremely computationally intensive to run. However, we will continually add more resources to the repository, 
including material that is suitable for settings where more capacity is available, and where higher phone usage results in higher frequency
 data. In these cases, it will be possible to produce more complex outputs and analyses. 

## Technical usage

The code will need to be adapted to each MNO's system. 
The names of tables and columns will need to be changed, and the code may need to be optimised to suit the structure of the data.

The code has been written assuming that the following tables exist:

`calls` is the call events table, including the columns:
- `msisdn`: SIM identifier,
- `date`: event date,
- `datetime`: event timestamp,
- `location_id`: identifier of the cell tower.

`cells` is a table with information about cell towers, including the columns:
- `cell_id`: identifier of the cell tower,
- `region`: the administrative region (or other type of region) that the cell tower is in. We are able to provide assistance with mapping cell tower locations to administrative (or other) regions, if you do not already have this mapping.

[core_tables.sql](core_tables.sql) contains definitions of the expected `calls` and `cells` tables.

## Content

This repository currently contains SQL code and descriptions for the following indicators:
- [Indicator 1: Count of unique subscribers, per region per day](indicator_1.md)
- [Indicator 2: Count of unique ‘non-residents’, per region per day](indicator_2.md)
- [Indicator 3: Count of unique subscribers, per region per week](indicator_3.md)
- [Indicator 4: Count of unique ‘non-residents’, per region per week](indicator_4.md)
- [Indicator 5: ‘Connectivity’ between pairs of regions - count of unique subscribers seen at each pair of locations, each day](indicator_5.md)

We will soon be adding analysis code and guidelines.

## Privacy

All indicators included in this repository produce aggregated outputs (i.e. one result per region, not one result per subscriber), to protect subscribers' privacy and personal data. Additionally, the queries only produce outputs for regions with more than 15 subscribers.

Note that some intermediate queries (including `home_locations`) produce per-subscriber data. These intermediate results should not be shared outside of the MNO's system.

## Feedback

We welcome all suggestions and feedback. Please open an issue, submit a pull request, or contact the team at covid19@flowminder.org.