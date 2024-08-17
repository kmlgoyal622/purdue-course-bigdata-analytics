DROP TABLE `direct-axiom-428510-d6.team2_assigmnent2.flights_with_airline_code`;
CREATE TABLE `direct-axiom-428510-d6.team2_assigmnent2.flights_with_airline_code` AS
SELECT *, 
CONCAT(`Operating_Airline `, Flight_Number_Operating_Airline) as bts_airline_code
FROM `direct-axiom-428510-d6.lab3_bts.Flights`;

DROP TABLE `direct-axiom-428510-d6.flight_stream_data.flight_data_merged_bts_ml`;
CREATE TABLE `direct-axiom-428510-d6.flight_stream_data.flight_data_merged_bts_ml` AS
SELECT DISTINCT tbl1.*, 
  DATE(TIMESTAMP_SECONDS(tbl2.time)) AS flight_date,
  EXTRACT(HOUR FROM TIMESTAMP_SECONDS(tbl2.time)) AS flight_hour,
  tbl2.altitude,
  tbl2.on_ground,
  tbl2.velocity,
  tbl2.heading,
  tbl2.vertical_rate,
  tbl2.baro_altitude,
  tbl2.icao24
FROM
`direct-axiom-428510-d6.team2_assigmnent2.flights_with_airline_code` tbl1
INNER JOIN 
( Select *, SUBSTR(callsign, 1, 2) || SUBSTR(callsign, 4) AS callsign_new from 
`direct-axiom-428510-d6.flight_stream_data.flight_data` ) tbl2
ON tbl1.bts_airline_code = tbl2.callsign_new ;

DROP TABLE `direct-axiom-428510-d6.flight_stream_data.flight_data_merged_bts_category`;
CREATE TABLE `direct-axiom-428510-d6.flight_stream_data.flight_data_merged_bts_category` AS
SELECT * FROM `direct-axiom-428510-d6.flight_stream_data.flight_data_merged_bts_ml` table1
INNER JOIN
(SELECT string_field_0, CASE
  WHEN string_field_1 = 'Light (< 15500 lbs)' THEN 1
  WHEN string_field_1 = 'Small (15500 to 75000 lbs)' THEN 2
  WHEN string_field_1 = 'Large (75000 to 300000 lbs)' THEN 3
  WHEN string_field_1 = 'Heavy (> 300000 lbs)' THEN 4
  WHEN string_field_1 = 'Reserved' THEN 5
  ELSE NULL 
  END AS aircraft_category FROM `direct-axiom-428510-d6.team2_assigmnent2.opensky_categories`) table2
ON table1.icao24 = table2.string_field_0






