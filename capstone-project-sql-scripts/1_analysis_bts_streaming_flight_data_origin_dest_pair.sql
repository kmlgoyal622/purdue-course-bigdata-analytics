-- 1. Fetch BTS data for an origin destination pair
-- Washington DC, 12264
-- Newark, 11618
DROP TABLE `direct-axiom-428510-d6.lab3_bts.Flights_with_airline_code`;
CREATE TABLE `direct-axiom-428510-d6.lab3_bts.Flights_with_airline_code` AS
SELECT *, 
CONCAT(`Operating_Airline `, Flight_Number_Operating_Airline) as bts_airline_code
FROM `direct-axiom-428510-d6.lab3_bts.Flights` 
Where IATA_Code_Operating_Airline in ('AA', 'UA', 'DL')
 AND OriginAirportID = 12264 and DestAirportID = 11618 ;



-- 2. Fetch Streaming data for specific airlines
DROP TABLE `direct-axiom-428510-d6.flight_stream_data.flight_data_specific_airlines`;
CREATE TABLE `direct-axiom-428510-d6.flight_stream_data.flight_data_specific_airlines` AS
select * 
FROM `direct-axiom-428510-d6.flight_stream_data.flight_data`
WHERE callsign LIKE 'DAL%' OR callsign LIKE 'AAL%' OR callsign LIKE 'UAL%'
ORDER BY icao24 ASC, time ASC;

-- 3. Merge data on call sign
-- We were able to merge data for only 2 airlines. UA1958, UA1974
DROP TABLE `direct-axiom-428510-d6.flight_stream_data.flight_data_merged_bts`;
CREATE TABLE `direct-axiom-428510-d6.flight_stream_data.flight_data_merged_bts` AS
SELECT DISTINCT tbl1.*, 
  DATE(TIMESTAMP_SECONDS(tbl2.time)) AS flight_date,
  EXTRACT(HOUR FROM TIMESTAMP_SECONDS(tbl2.time)) AS flight_hour,
  tbl2.altitude,
  tbl2.on_ground,
  tbl2.velocity,
  tbl2.heading,
  tbl2.vertical_rate,
  tbl2.baro_altitude
FROM
`direct-axiom-428510-d6.lab3_bts.Flights_with_airline_code` tbl1
INNER JOIN 
( Select *, SUBSTR(callsign, 1, 2) || SUBSTR(callsign, 4) AS callsign_new from 
`direct-axiom-428510-d6.flight_stream_data.flight_data_specific_airlines` ) tbl2
ON tbl1.bts_airline_code = tbl2.callsign_new ;


--4. Average, Max, Min Velocity for origin-dest pair
CREATE TABLE `direct-axiom-428510-d6.flight_stream_data.velocity_stats_for_Washington_Newark` AS
SELECT bts_airline_code, flight_hour, OriginCityName, DestCityName, Round(AVG(velocity), 2) AS Average_velocity, MIN(velocity) AS Mini_velocity, MAX(velocity) AS Max_velocity
FROM `flight_stream_data.flight_data_merged_bts`
GROUP BY 1, 2, 3, 4
order by 2 ASC;


