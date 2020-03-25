CREATE TABLE calls(
    msisdn TEXT,
    date DATE,
    datetime TIMESTAMP,
    location_id TEXT
);

CREATE TABLE cells(
    cell_id TEXT,
    region TEXT -- We are able to provide assistance with mapping cell tower locations to administrative (or other) regions, if you do not already have this mapping.
);