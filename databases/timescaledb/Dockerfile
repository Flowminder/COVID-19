# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
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
COPY --chown=postgres ./databases/timescaledb/sql/a01_create_db.sql /docker-entrypoint-initdb.d/
COPY --chown=postgres ./core_tables.sql /docker-entrypoint-initdb.d/
COPY --chown=postgres ./databases/timescaledb/sql/d01_create_hypertable.sql /docker-entrypoint-initdb.d/

# Need to make postgres owner
RUN chown -R postgres /docker-entrypoint-initdb.d

EXPOSE 5432

FROM base AS sample-data

#
#  Copy sql scripts to be run by PostgreSQL on build-time.
#
COPY --chown=postgres ./databases/timescaledb/sql/e01_create_sample_procedure.sql /docker-entrypoint-initdb.d/
#
#  Copy file spinup build scripts to be execed.
#
COPY --chown=postgres ./databases/timescaledb/scripts/e02_add_sample_data.sh /docker-entrypoint-initdb.d/
