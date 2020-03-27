# README for `timescaledb` example

This directory contains example configuration file and scripts to spin up an example `timescaledb` database instance containing example sample CDR data in a Docker container.

*NB The configuration provided here should not be used in a production scenario without security auditing and implementing additional security configuration settings.*

### Prerequisites

To spin up the database container, you will need the following installed on your host machine
- [`docker`](https://docs.docker.com/install)`>= 19.03.5`
- [`docker-compose`](https://docs.docker.com/compose/install)`>= 1.24.1`

If you want to access the `timescaledb` (PostgreSQL) database from your host machine (rather than via the containers), then you will need to also install
- [`psql`](https://www.postgresql.org/download/)`>= 9.6.1`


### Using the `Makefile`

```
$ make help
build-all                      Run all build steps
build-flowtimedb               Build DB base image with no sample data included
build-sample-db                Build DB image with sample data
connect-to-db-as-admin-via-container Connect to base database as admin user via container
connect-to-db-via-host         Connect to database as admin user via host
connect-to-sample-db-as-admin-via-container Connect to sample database as admin user via container
sample-db                      Run all build and deploy steps for DB with sample data
start-flowtimedb               Start base database
start-sample-db                Start sample database
stop-flowtimedb-and-remove-volumes Stop base database and remove volumes
stop-flowtimedb                Stop base database
stop-sample-db-and-remove-volumes Stop sample database and remove volumes
stop-sample-db                 Stop sample database but retain volumes

```

### Setting the environment variables

The following default environment variables are used to configure the timescaledb Docker container
```
# Default environment variables
POSTGRES_DB=flowtimedb
POSTGRES_USER=flowtimedb
POSTGRES_PASSWORD=timetime
PORT=5444
POSTGRES_SHM=1G
# sample data characteristics
SAMPLE_COUNT=20
SAMPLE_START_TIME=20200101
SAMPLE_END_TIME=20200107
```
These default values are included in the environment variable file `.env-dev`:
- `SAMPLE_COUNT` defines how many records are generated in the sample data. 
- `SAMPLE_START_TIME` defines the start timestamp from which the sample data will be generated
- `SAMPLE_END_TIME` defines the end timestamp up to which the sample data will be generated. 

Note that sample data is generate on the first time the container is started up, using the settings in these environment variables.

If these environment variables are not set, the Docker compose yml file will fall back to the defaults defined there e.g. `${SAMPLE_COUNT:-7}` will default to 7 if the `SAMPLE_COUNT` environment variable is not defined.

### Procedure to bring up a `timescaledb` database instance with pre-ingested sample data

First we export the default values for the environment variables, build the container image, and spin up the database with sample data:
```
set -a && source ./.env-dev && set +a
make sample-db
```
Check that the container is up and running
```
docker ps
```
To login to the `flowtimedb` database as the admin `flowtimedb` user and count sample cdr data rows and quit from the psql command line:
```
make connect-to-sample-db-as-admin-via-container
flowtimedb=# SELECT COUNT(*) FROM calls;
flowtimedb=# \q
```
To view the container logs:
```
docker logs -f flowtimedb_sample_data
```
Use `Ctrl-C` key combination to quit viewing the container logs.  
To tear down the container:
```
make stop-sample-db
```
To tear down the container _and_ delete the underlying data volume:
```
make stop-sample-db-and-remove-volumes
```

