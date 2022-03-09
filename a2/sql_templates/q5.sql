-- Q5. Flight Hopping

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO air_travel, public;
DROP TABLE IF EXISTS q5 CASCADE;

CREATE TABLE q5 (
	destination CHAR(3),
	num_flights INT
);

-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS intermediate_step CASCADE;
DROP VIEW IF EXISTS day CASCADE;
DROP VIEW IF EXISTS n CASCADE;

CREATE VIEW day AS
SELECT day::date as day FROM q5_parameters;
-- can get the given date using: (SELECT day from day)

CREATE VIEW n AS
SELECT n FROM q5_parameters;
-- can get the given number of flights using: (SELECT n from n)

-- HINT: You can answer the question by writing one recursive query below, without any more views.
-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q5
With recursive q5flight AS (
SELECT id, flight_num, outbound, inbound, s_arv, 1 AS num_flight
From flight
where outbound = 'YYZ' and date_trunc('day', s_dep)= (SELECT day from day)
Union
select f.id, f.flight_num, f.outbound, f.inbound, f.s_arv, num_flight + 1 
From flight f
Inner JOIN q5flight s ON s.inbound = f.outbound and s.s_arv <= f.s_dep and s.s_arv + '24 hour' > f.s_dep
Where num_flight < (SELECT n from n))
SELECT inbound, num_flight
FROM q5flight;