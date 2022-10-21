# Instruction

## General format:
```python 
python main.py MODE DATAPATH
```
- ```MODE```: Indicate the output needed.
  - 1: Initialize and combine all raw csv files and generate a pickle file.
  - 2: Output the univariate method result across all ids and destinations.
  - 3: Output the univariate method result for 1 single destination with all ids.
  - 4: Output the univariate method result for 1 single id with all destinations.
  - 5: Output the multivariate method result for all ids and destinations.
- ```DATAPATH```: the directory that stored all raw data

## Lists of Scripts:
- ```main.py```
- ```Initialize.py```
- ```des_id.py```
- ```id.py```
- ```des.py```
- ```multivariate.py```

## ```main.py```
The main script to run and change parameters. Including 5 modes to choose.



## ```Initialize.py```
- ```combineCSV```:The script to combine several csv file and clean the data to generate source data for other functions.


## ```des_id.py```
- ```setup_des_id```: set up the working destination and id given by input.
- ```timeGap```: Given the id and destination of one time series, selece entires that have gaps longer than standard time and return the abnormal time gaps as a dataframe 
- ```decompo_ma```: Given a single time series data, return the anomaly detection result from the Moving Average Method as a dataframe
- ```prophet_anomaly_detection```: Given a single time series data, returns the anomaly detection result given by the Prophet model as a dataframe.
- ```anomaly_detection_arima```: Given a single time series data, returns the anomaly detection result given by the Prophet model as a dataframe.
- ```find_point```: Given a signle time series data, returns the anomaly detection result given by the Moving Average, Prophet, and ARIMA model as a dataframe.
- ```changePoint```: Given a time series, return the change point date.
- ```cp_point```: Apply find point anomalies on each period change point found 



## ```id.py```
- ```setup_id```: set up the working id given by input
- ```id_point```: Given one id, this method finds point anomalies across all destinations for this specific ID.
- ```id_coll```: Given one id, this method finds collective anomalies across all destinations for this specific id.
- ```group_day```: Given a signle time series data, returns the number of anomalies each day (date_group), number of anomalies each day under threshold (result) and threshold
- ```anomaly_id_comb```: Given a single id, returns both the point and collective anomaly detection result as a dataframe.

## ```des.py```
- ```setup_des```: set up the working destination given by input
- ```destination_point```: Given one destination, this method finds point anomalies across all IDs for this specific destination.
- ```destination_coll```: Given one destination, this method finds collective anomalies across all IDs for this specific destination.
- ```group_day```: Given a signle time series data, returns the number of anomalies each day (date_group), number of anomalies each day under threshold (result) and threshold
- ```anomaly_des_comb```: Given a single destination, returns both the point and collective anomaly detection result as a dataframe.

## ```multivariate.py```
- ```clean_data```: Clean and resample the given the raw data.
- ```find_anomaly_var```: Given a calculated squared errors, calculate the threshold for anomaly detection and return the corresponding prediction result.
- ```func_var```: Given the cleaned data, return a list of date with an over 20% anomalous point for a single day.
- ```isolation_forest```:
- ```find_anomaly_id_des```:
- ```id_des_stats```:
