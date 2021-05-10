# Week 2

Welcome to the second week of MGMT 581. This markdown file will walk through the questions we've answered and exercises we've performed in the class lecture.

## Load the data
```python
import pandas as pd
import numpy as np
import os
import matplotlib.pyplot as plt
import seaborn as sns
import pandas_profiling as pp
import datetime

# Changing Pandas options
pd.options.display.max_rows = 999
pd.options.display.max_columns = 999
pd.set_option('display.float_format', lambda x: '%.5f' % x)
```

```python
data_path = os.getcwd().partition("src")[0] + 'data/'
```

```python
flights_df = pd.read_csv(data_path + "flights.csv")
flights_df.head()
```

```python
airports_df = pd.read_csv(data_path + "airports.csv")
airports_df.head()
```

```python
airlines_df = pd.read_csv(data_path + "airlines.csv")
airlines_df
```

## Quality

### Validity

```python
# data types
flights_df.dtypes
```

```python
# Mandatory info
# all flights need a real arrival and takeoff airport
flights_df[['ORIGIN_AIRPORT','DESTINATION_AIRPORT']].isnull().sum()
```

```python
# ranges / conditions
# flight numbers can be repeated on different days
flights_df.FLIGHT_NUMBER.nunique()
```

```python
flights_df.shape[0]
```

### Accuracy

```python
# makings of a date time, but it looks like it should be HHMM formatted
flights_df.SCHEDULED_TIME.head()
```

### Completeness

```python
# lots of missing departure times & other things you would think we would know
# additionally, cancellation reason and the _delay columns are missing when they aren't filled in. 
# these seem to be correct missing values
flights_df.isnull().sum()
```

### Consistency

```python
# missing values for taxi_out and wheels off if flight is cancelled
flights_df.loc[flights_df.DEPARTURE_TIME.isnull()][['SCHEDULED_DEPARTURE','DEPARTURE_TIME','TAXI_OUT','WHEELS_OFF', 'CANCELLED']].head()
```

```python
# departure time + taxi out looks like it should be wheels off (if you make it real time based HHMM variables)
flights_df.loc[~flights_df.DEPARTURE_TIME.isnull()][['SCHEDULED_DEPARTURE','DEPARTURE_TIME','TAXI_OUT','WHEELS_OFF', 'CANCELLED']].head()
```

### Uniformity

```python
# no unit of measurement on distance
flights_df.DISTANCE.head()
```

```python
# quick summary stats make the distances seem reasonable (does a 21 mile flight make sense?)
flights_df.DISTANCE.describe()
```

## Inspection
```python
# Get Chicago Airports (Remember, we are only looking at a Chicago traveler)
flights_df.ORIGIN_AIRPORT.value_counts().head(10)
```
```python
chi_airports = ['ORD', 'MDW']
```

```python
chi_flights = flights_df.loc[
    (flights_df.ORIGIN_AIRPORT.isin(chi_airports)) |
    (flights_df.DESTINATION_AIRPORT.isin(chi_airports))
].copy()
```

```python
chi_flights.shape
```

```python
flights_df.shape[0] - chi_flights.shape[0]
```

```python
##### given data size, let's split outbound and incoming into two separate datasets for now
outbound = chi_flights.loc[chi_flights.ORIGIN_AIRPORT.isin(chi_airports)].copy()
incoming = chi_flights.loc[chi_flights.DESTINATION_AIRPORT.isin(chi_airports)].copy()
```

```python
chi_flights.shape[0] - outbound.shape[0]
```

```python
outbound.profile_report(minimal=True)
```

## Cleaning



### Recoding Categorical variables
```python
outbound.loc[:,outbound.dtypes==object]
```

```python
# cancellation reason 
# A Carrier, B Weather, C NAS, D security
reasons = {'A':'Carrier', 'B':'Weather', 'C':'NAS', 'D':'security'}
outbound["CANCELLATION_REASON_CLEANED"] = outbound.CANCELLATION_REASON.map(reasons)
outbound.CANCELLATION_REASON_CLEANED.value_counts()
```

```python
airline_dict = {}
for r in airlines_df.iterrows():
    airline_dict.update({r[1][0]:r[1][1]})
```

```python
airline_dict
```

```python
# airline_name
outbound['AIRLINE_CLEANED'] = outbound.AIRLINE.map(airline_dict)
outbound.AIRLINE_CLEANED.value_counts()
```

### Recoding Numeric Variables
```python
# day of week
# 4 is Thursday (JANUARY 1 2015)
# demonstrably less Saturday flights
days = {1:'MON',2:'TUE',3:'WED',4:'THU', 5:'FRI',6:'SAT',7:'SUN'}
outbound['DAY_OF_WEEK_CLEANED'] = outbound.DAY_OF_WEEK.map(days)
outbound.DAY_OF_WEEK_CLEANED.value_counts()
```

```python
# month
# no Nov
months = {1:'JAN',2:'FEB',3:'MAR',4:'APR',5:'MAY',6:'JUN',7:'JUL',8:'AUG',9:'SEP',10:'OCT',11:'NOV',12:'DEC'}
outbound['MONTH_CLEANED'] = outbound.MONTH.map(months)
outbound.MONTH_CLEANED.value_counts()
```

### Dealing with Time

```python
# we know that time is on the 0-2400 scale
# lets pull out the hours and minutes to create datetime relationships
def create_four_digit_time(s):
    s = s.apply(int)
    s = s.apply(str)
    s = s.apply(lambda x: x if len(x) ==4 else (4-len(x))*"0" + x)
    return s

def get_hour(s):
    return s.apply(lambda x: x[:2])

def get_minutes(s):
    return s.apply(lambda x: x[2:])
```

```python
outbound = outbound.loc[
    (~outbound.DEPARTURE_TIME.isnull()) &
    (~outbound.ARRIVAL_TIME.isnull()) &
    (outbound.CANCELLED==0) &
    (outbound.DIVERTED==0)
]
```

```python
outbound.shape[0]
```

```python
time_cols = [
    'SCHEDULED_DEPARTURE',
    'DEPARTURE_TIME',
    'SCHEDULED_ARRIVAL',
    'ARRIVAL_TIME'
]
for col in time_cols:
    outbound[f"{col}_cleaned"] = create_four_digit_time(outbound[col])
    outbound[f"{col}_HOUR"] = get_hour(outbound[f"{col}_cleaned"]).apply(int)
    outbound[f"{col}_MINUTES"] = get_minutes(outbound[f"{col}_cleaned"]).apply(int)
    print(outbound[[f"{col}_cleaned", f"{col}_HOUR",f"{col}_MINUTES"]].head())
```

```python
outbound.loc[outbound.DEPARTURE_TIME_HOUR==24]
```

### Data Errors / Unexpected values

```python
outbound.ORIGIN_AIRPORT.value_counts().tail(15)
```

```python
# should we remove some of these small airports that aren't frequent?
outbound.DESTINATION_AIRPORT.value_counts().tail(15)
```

```python
# betting these are international airports, so we will drop because we only care about domestic
outbound = outbound.loc[(outbound.ORIGIN_AIRPORT.apply(str).apply(len) == 3) & (outbound.DESTINATION_AIRPORT.apply(str).apply(len) == 3)]
```

### Merging data together

```python
outbound = outbound.merge(
    airports_df.rename(columns={'AIRPORT':'AIRPORT_FULL'}).add_prefix("ORIGIN_"),
    how = 'left',
    left_on = 'ORIGIN_AIRPORT',
    right_on = 'ORIGIN_IATA_CODE'
).merge(
    airports_df.rename(columns={'AIRPORT':'AIRPORT_FULL'}).add_prefix("DESTINATION_"),
    how = 'left',
    left_on = 'DESTINATION_AIRPORT',
    right_on = 'DESTINATION_IATA_CODE'
)
outbound.head()
```

### Missing Values

- Ask: What are our options for rows with missing data?

```python
outbound.isnull().sum().T
```

## Verifying
**How would you verify this data's accuracy after our checks?**


## Reporting


### Correlation

```python
cols_of_interest = [
    'MONTH',
    'DAY',
    'DAY_OF_WEEK',
    'SCHEDULED_DEPARTURE_HOUR',
    'SCHEDULED_DEPARTURE_MINUTES',
    'SCHEDULED_ARRIVAL_HOUR',
    'SCHEDULED_ARRIVAL_MINUTES',
    'ORIGIN_LATITUDE',
    'ORIGIN_LONGITUDE',
    'DESTINATION_LATITUDE',
    'DESTINATION_LONGITUDE',
    'DISTANCE'
]
outbound[['ARRIVAL_DELAY',*cols_of_interest]].corr().ARRIVAL_DELAY.sort_values(ascending=False)
```


```python
for airline in outbound.AIRLINE_CLEANED.unique():
    print(airline)
    print(outbound.loc[outbound.AIRLINE_CLEANED == airline][['ARRIVAL_DELAY',*cols_of_interest]].corr().ARRIVAL_DELAY.sort_values(ascending=False))
    print("-------------------------------------------------")
```

- **How long should data cleaning normally take?**

- **Ask: Who from the client should we talk with about data cleaning?**


## Output

```python
outbound.to_csv(data_path + "cleaned_outbound_data.csv", index=False)
```

```python

```
