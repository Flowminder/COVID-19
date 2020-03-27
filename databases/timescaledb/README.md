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

### Procedure to bring up a `timescaledb` database instance with pre-ingested sample data

To export the default values for the environment variables, build the container image, and spin up the database with sample data:
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
Use `Ctrl-C` key combination to quit.  
To tear down the container:
```
make stop-sample-db
```
To tear down the container _and_ delete the underlying data volume:
```
make stop-sample-db-and-remove-volumes
```

