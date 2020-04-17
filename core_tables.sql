-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

CREATE TABLE calls(
    msisdn TEXT,
    call_date DATE,
    call_datetime TIMESTAMP,
    location_id TEXT
);

CREATE TABLE cells(
    cell_id TEXT,
    locality TEXT -- We are able to provide assistance with mapping cell tower locations to administrative (or other) localities, if you do not already have this mapping.
);