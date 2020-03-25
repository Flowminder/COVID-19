<a href='https://flowminder.org/'><img src='https://github.com/Flowminder/GridSample2.0/blob/master/flowminder.png?raw=true' align="right" width="200" /></a>
# Data insights for COVID-19 response resources for MNOs 

[![License: MIT](https://img.shields.io/github/license/Flowminder/COVID-19.svg?style=flat-square)](https://www.gnu.org/licenses/quick-guide-gplv3.html)
<img src="https://img.shields.io/github/last-commit/Flowminder/COVID-19.svg" />
<img src="https://img.shields.io/github/stars/Flowminder/COVID-19.svg" />

## Overview

The SQL queries in this repository produce basic indicators from mobile operator data that by themselves, in combination with each other and in combination with other data sources can support governments and health experts to better respond to the COVID-19 outbreak. 

We are adding indicators here as we are producing them. Many of the indicators below can be seen as building blocks of final indicators, which will also take into account analysis of how patterns change over time. A first version will be ready soon, at the latest during the week of 30 March alongside methodical notes.

A description of each indicator is provided with the code, together with suggestions for how it can be used.

The indicators we have initially focused on are relevant for low and lower middle-income country settings where most subscribers have a low frequency of events (e.g.calls and data downloads). Other indicators which can take advantages of the higher frequency data in high-income settings will be added. 

MNOs will need to adapt to run on your own system. The names of tables and columns will need to be changed, and the code may need to be optimised to suit the structure of your data.The code has been written assuming that the following tables exist:

`calls` is the call events table, including the columns:
- `msisdn`: SIM identifier,
- `date`: event date,
- `datetime`: event timestamp,
- `location_id`: identifier of the cell tower.

`cells` is a table with information about cell towers, including the columns:
- `cell_id`: identifier of the cell tower,
- `region`: the administrative region (or other type of region) that the cell tower is in. We are able to provide assistance with mapping cell tower locations to administrative (or other) regions, if you do not already have this mapping.

[core_tables.sql](core_tables.sql) contains definitions of the expected `calls` and `cells` tables.

We welcome [suggestions and feedback](https://github.com/Flowminder/COVID-19/issues/new/choose).

## Content

This repository contains SQL code and descriptions for the following indicators:
- [Indicator 1: Count of unique subscribers, per region per day](indicator_1.md)
- [Indicator 2: Count of unique ‘non-residents’, per region per day](indicator_2.md)
- [Indicator 3: Count of unique subscribers, per region per week](indicator_3.md)
- [Indicator 4: Count of unique ‘non-residents’, per region per week](indicator_4.md)
- [Indicator 5: ‘Connectivity’ between pairs of regions - count of unique subscribers seen at each pair of locations, each day](indicator_5.md)
