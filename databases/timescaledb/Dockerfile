ARG TIMESCALEDB_VERSION=1.6.1-pg11
FROM timescale/timescaledb:${TIMESCALEDB_VERSION} as base

#
#  CONFIGURATION
#  -------------
#
#  In this section packages installed in previous
#  steps are properly configured. That happens by
#  either modifying configuration files (*.config)
#  or by loading *.sh scripts that will gradually
#  do that.
#
RUN mkdir -p /docker-entrypoint-initdb.d

#
#  Copy sql scripts to be run by PostgreSQL on build-time.
#
COPY --chown=postgres ./sql/a01_create_db.sql /docker-entrypoint-initdb.d/

# Need to make postgres owner
RUN chown -R postgres /docker-entrypoint-initdb.d

EXPOSE 5432

FROM base AS sample-data

#
#  Copy sql scripts to be run by PostgreSQL on build-time.
#
COPY --chown=postgres ./sql/b01_create_sample_procedure.sql /docker-entrypoint-initdb.d/
#
#  Copy file spinup build scripts to be execed.
#
COPY --chown=postgres ./scripts/b02_add_sample_data.sh /docker-entrypoint-initdb.d/
