# README for `timescaledb` example

This directory contains example configuration file and scripts to spin up an example `timescaledb` database instance containing example sample CDR data in a Docker container.

*NB The configuration provided here should not be used in a production scenario without security auditing and implementing additional security configuration settings.*

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

