# Data insights for COVID-19 response: resources for MNOs

## Overview

The SQL queries in this repository produce basic indicators that may help governments and health experts with their response to the COVID-19 outbreak. A description of each indicator is provided alongside the code, together with suggestions for how it can be used. 

We will continue to add more code to this repository, including code to produce more complex indicators, based on our own expertise and any feedback that we receive. 

The code will need to be adapted to run on your own system. The names of tables and columns will need to be changed, and the code may need to be optimised to suit the structure of your data.

The code has been written assuming that the following tables exist:

`calls` is the call events table, including the columns:
- `msisdn`: SIM identifier,
- `date`: event date,
- `datetime`: event timestamp,
- `location_id`: identifier of the cell tower.

`cells` is a table with information about cell towers, including the columns:
- `cell_id`: identifier of the cell tower,
- `region`: the administrative region (or other type of region) that the cell tower is in. We are able to provide assistance with mapping cell tower locations to administrative (or other) regions, if you do not already have this mapping.

## Content

This repository contains SQL code and descriptions for the following indicators:
- [Indicator 1: Count of unique subscribers, per region per day](indicator_1.md)
- [Indicator 2: Count of unique ‘non-residents’, per region per day](indicator_2.md)
- [Indicator 3: Count of unique subscribers, per region per week](indicator_3.md)
- [Indicator 4: Count of unique ‘non-residents’, per region per week](indicator_4.md)
- [Indicator 5: ‘Connectivity’ between pairs of regions - count of unique subscribers seen at each pair of locations, each day](indicator_5.md)
