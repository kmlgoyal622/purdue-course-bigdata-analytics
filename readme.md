# Problem Statement

1. Identify relationships and patterns between flight characteristics and delays/cancellations to optimize flight performance and enhance operational efficiency.

2. Understand persistent issues with airline operations to improve passenger experience.

## Objective
Determine whether there are specific times during the day where flights between Washington, DC, and Newark, NJ, experience significant variations in velocity. 

- Predict flight delays using aircraft type and other characteristics to examine how aircraft type may affect delays.​

- Investigate relationships between flight velocities and arrival delays for selected origin-destination pairs.​

- Explore correlations between cancellations/delays and flight origins to identify problem airports.​

- Analyze whether particular aircrafts were consistently delayed and/or delayed for longer periods


## Data pre-processing and Model Training with predictions
1. We obtained the flight data from BTS archives from the year 2018 untill 2021.

2. We designed a cloud function to download the real-time streaming dataset from OpenSky API.

3. We merged both the datasets for the Washington-Neward origin-destination pair and analyzed average velocities by each hour.

4. Then, we built a linear regression model to predict aircraft velocities based on following features on dataset before year 2021.
	- IATA_Code_Marketing_Airline
	- TaxiIn
	- TaxiOut
	- Altitude
	- heading
	- vertical_rate
	- baro_altitude
	- ArrDelay

5. We used the train model to predict over flight dataset from year 2021. We also subset the prediction data where the predicted velocities were > 200 knots.


## Analysis and Findings
The analysis revealed that specific times during the day, particularly early morning and late-night flights, tend to experience lower average velocities, indicating potential inefficiencies or increased congestion during these hours.

- There is less fluctuation in aircraft velocity during off-peak hours (12AM to 5AM) compared to aircrafts later in the day (based on the difference in minimum and maximum velocity by hour).

- It suggests that operational performance varies significantly depending on the time of day. ​

- It may potentially be the reason for the arrival delays.
