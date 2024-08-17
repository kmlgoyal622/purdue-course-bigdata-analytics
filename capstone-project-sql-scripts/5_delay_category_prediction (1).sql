CREATE OR REPLACE MODEL `direct-axiom-428510-d6.flight_stream_data.linear_reg_category`
options (model_type = 'linear_reg',input_label_cols=['ArrDelay']) as
select  
IATA_Code_Marketing_Airline,
TaxiIn, TaxiOut,
altitude,
velocity,
heading,
vertical_rate,
baro_altitude,
aircraft_category,
ArrDelay from 
`direct-axiom-428510-d6.flight_stream_data.flight_data_merged_bts_category`
WHERE
FlightDate < '2021-01-01' AND aircraft_category IS NOT NULL AND ArrDelay IS NOT NULL;

DROP TABLE `direct-axiom-428510-d6.flight_stream_data.flight_data_predict_category`;
CREATE TABLE `direct-axiom-428510-d6.flight_stream_data.flight_data_predict_category` AS
Select * from ML.predict(MODEL `direct-axiom-428510-d6.flight_stream_data.linear_reg_category`,
(select  
IATA_Code_Marketing_Airline,
TaxiIn, TaxiOut,
altitude,
velocity,
heading,
vertical_rate,
baro_altitude,
aircraft_category from 
`direct-axiom-428510-d6.flight_stream_data.flight_data_merged_bts_category`
where  FlightDate > '2021-01-01' AND aircraft_category IS NOT NULL
));

CREATE TABLE `direct-axiom-428510-d6.flight_stream_data.flight_data_predict_category_labels` AS
SELECT *, CASE
  WHEN aircraft_category = 3 THEN 'Large (75000 to 300000 lbs)'
  WHEN aircraft_category = 4 THEN 'Heavy (> 300000 lbs)'
  ELSE NULL
  END AS category_label
FROM `direct-axiom-428510-d6.flight_stream_data.flight_data_predict_category`


