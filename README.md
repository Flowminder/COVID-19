# Data insights for COVID-19 response: resources for MNOs

The SQL queries in this repository produce basic indicators that may help governments and health experts with their response to the COVID-19 outbreak. A description of each indicator is provided alongside the code, together with suggestions for how it can be used. 

We will continue to add more code to this repository, including code to produce more complex indicators, based on our own expertise and any feedback that we receive. 

The code will need to be adapted to run on your own system. The names of tables and columns will need to be changed, and the code may need to be optimised to suit the structure of your data.

The code has been written assuming that the following tables exist:

`calls` is the call events table, including the columns:
- `msisdn`: SIM identifier
- `date`: event date
- `datetime`: event timestamp
- `location_id`: identifier of the cell tower

`cells` is a table with information about cell towers, including the columns:
- `cell_id`: identifier of the cell tower
- `region`: the administrative region (or other type of region) that the cell tower is in 
