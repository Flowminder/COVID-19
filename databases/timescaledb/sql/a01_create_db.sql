-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
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
