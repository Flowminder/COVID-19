/*
EVENTS ---------------------------------------------------
This schema collection organizes data provided by operators
into a predictable format.

-----------------------------------------------------------
*/
CREATE extension IF NOT EXISTS timescaledb cascade;

CREATE TABLE IF NOT EXISTS regions (
    region TEXT
);

CREATE TABLE IF NOT EXISTS subscribers (
    msisdn TEXT
);

CREATE TABLE IF NOT EXISTS cells (
    cell_id TEXT,
    region TEXT
);

CREATE TABLE IF NOT EXISTS calls (
    date                 DATE,
	datetime             TIMESTAMP NOT NULL, 
	msisdn               TEXT,
	location_id          TEXT
);

/*
Typically recommend setting the interval so that these chunk(s) comprise no more 
than 25% of main memory.
If you are writing 10GB per day and have 64GB of memory, setting the time interval 
to a day would be appropriate.
If you are writing 190GB per day and have 128GB of memory, setting the time interval 
to 4 hours would be appropriate.
*/
SELECT create_hypertable('calls', 'datetime', chunk_time_interval => interval '1 day', associated_schema_name => 'public');
/*
A view which provides a list of the dates available in calls hypertable
*/
CREATE VIEW available_dates AS (
    WITH chunk_ranges_as_strings AS (
        SELECT unnest(ranges) as ranges
        FROM chunk_relation_size_pretty('calls')
    ),
    chunk_ranges AS (
        SELECT
            substring(ranges, 2, 24)::TIMESTAMPTZ as chunk_start,
            substring(ranges, 25, 24)::TIMESTAMPTZ as chunk_end
        FROM chunk_ranges_as_strings
    )
    SELECT
        chunk_start::DATE as cdr_date
    FROM chunk_ranges
    ORDER BY cdr_date
);