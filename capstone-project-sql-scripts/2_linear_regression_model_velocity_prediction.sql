


-- Objective 2:
Select * FROM
`direct-axiom-428510-d6.flight_stream_data.flight_data_merged_bts` 
where ArrDelay is not NULL limit 10;


create or replace model `direct-axiom-428510-d6.flight_stream_data.linear_reg_velocity`
options (model_type = 'linear_reg',input_label_cols=['velocity']) as
select  
IATA_Code_Marketing_Airline,
TaxiIn, TaxiOut,
altitude,
velocity,
heading,
vertical_rate,
baro_altitude,
ArrDelay from 
`direct-axiom-428510-d6.flight_stream_data.flight_data_merged_bts` 

where  
FlightDate < '2021-01-01';


DROP TABLE `direct-axiom-428510-d6.flight_stream_data.flight_data_merged_bts_predict_2022_vel`;

CREATE TABLE `direct-axiom-428510-d6.flight_stream_data.flight_data_merged_bts_predict_2022_vel` AS
Select * from ML.predict(MODEL `direct-axiom-428510-d6.flight_stream_data.linear_reg_velocity`,
(select  
IATA_Code_Marketing_Airline,
TaxiIn, TaxiOut,
altitude,
heading,
vertical_rate,
baro_altitude,
ArrDelay from 
`direct-axiom-428510-d6.flight_stream_data.flight_data_merged_bts_train`
where  FlightDate > '2021-01-01' 
));

Create Table `direct-axiom-428510-d6.flight_stream_data.flight_data_merged_predicted_velocity_above_200` AS
SELECT *
from `direct-axiom-428510-d6.flight_stream_data.flight_data_merged_bts_predict_2022_vel` 
where predicted_velocity > 200;










-- part 3
SELECT IATA_Code_Marketing_Airline, avg(predicted_ArrDelay)
from `direct-axiom-428510-d6.flight_stream_data.flight_data_merged_bts_predict_2022` 
Group by 1




