DROP TABLE `direct-axiom-428510-d6.team2_assigmnent2.flight_data_with_category`;
CREATE TABLE `direct-axiom-428510-d6.team2_assigmnent2.flight_data_with_category` AS
select *, EXTRACT(HOUR FROM time_bq) as flight_hour FROM `direct-axiom-428510-d6.flight_stream_data.flight_data` table1
INNER JOIN
(SELECT string_field_0, string_field_1 as aircraft_category FROM `direct-axiom-428510-d6.team2_assigmnent2.opensky_categories`) table2
ON table1.icao24 = table2.string_field_0