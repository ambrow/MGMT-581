# Week 2

Welcome to the second week of MGMT 581. This markdown file will walk through the questions we've answered and exercises we've performed in the class lecture.

## Load the data
```python
import pandas as pd
import numpy as np
import os
import matplotlib.pyplot as plt
import seaborn as sns

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

```python
airline_dict = {}
for r in airlines_df.iterrows():
    airline_dict.update({r[1][0]:r[1][1]})
```

```python
airline_dict
```

## Scoping the analytics problem

### Supervised model to predict how much a customer should receive based on the data

Poll How long should we ask for to solve this problem?:
- poll everywhere allows free response + upvote of others
- could also do a mult choice on zoom

Poll Are there specific approaches you'd follow for solving this problem (i.e. Agile, waterfall, etc.)?

Poll Who do you need on your team throughout this project to ensure you are actually answering the question the way the client wants you to?

Discussion: Workplan - how would we go about planning to solve this problem?


## Data Cleaning

- Ask: What do we mean by data cleaning?

- Ask: What are the critical steps in data cleaning?

### Recoding Categorical variables
```python
flights_df.loc[:,flights_df.dtypes==object]
```

```python
# cancellation reason 
# A Carrier, B Weather, C NAS, D security
reasons = {'A':'Carrier', 'B':'Weather', 'C':'NAS', 'D':'security'}
flights_df["CANCELLATION_REASON_CLEANED"] = flights_df.CANCELLATION_REASON.map(reasons)
flights_df.CANCELLATION_REASON_CLEANED.value_counts()
```

```python
# airline_name
flights_df['AIRLINE_CLEANED'] = flights_df.AIRLINE.map(airline_dict)
flights_df.AIRLINE_CLEANED.value_counts()
```

### Recoding Numeric Variables
```python
# day of week
# 4 is Thursday (JANUARY 1 2015)
days = {1:'MON',2:'TUE',3:'WED',4:'THU', 5:'FRI',6:'SAT',7:'SUN'}
flights_df['DAY_OF_WEEK_CLEANED'] = flights_df.DAY_OF_WEEK.map(days)
flights_df.DAY_OF_WEEK_CLEANED.value_counts()
```

```python
# month
months = {1:'JAN',2:'FEB',3:'MAR',4:'APR',5:'MAY',6:'JUN',7:'JUL',8:'AUG',9:'SEP',10:'OCT',11:'NOV',12:'DEC'}
flights_df['MONTH_CLEANED'] = flights_df.MONTH.map(months)
flights_df.MONTH_CLEANED.value_counts()
```

### Dropping rows
- gotta drop rows that never left
- rows that never arrived
- cancelled
- diverted

```python
flights_df = flights_df.loc[
    (~flights_df.DEPARTURE_TIME.isnull()) &
    (~flights_df.ARRIVAL_TIME.isnull()) &
    (flights_df.CANCELLED==0) &
    (flights_df.DIVERTED==0)
]
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
time_cols = [
    'SCHEDULED_DEPARTURE',
    'DEPARTURE_TIME',
    'SCHEDULED_ARRIVAL',
    'ARRIVAL_TIME'
]
for col in time_cols:
    flights_df[f"{col}_cleaned"] = create_four_digit_time(flights_df[col])
    flights_df[f"{col}_HOUR"] = get_hour(flights_df[f"{col}_cleaned"]).apply(int)
    flights_df[f"{col}_MINUTES"] = get_minutes(flights_df[f"{col}_cleaned"]).apply(int)
    print(flights_df[[f"{col}_cleaned", f"{col}_HOUR",f"{col}_MINUTES"]].head())
```

### Data Errors / Unexpected values

```python
flights_df.ORIGIN_AIRPORT.value_counts().tail(15)
```

```python
flights_df.DESTINATION_AIRPORT.value_counts().tail(15)
```

```python
# betting these are international airports, so we will drop because we only care about domestic
flights_df = flights_df.loc[(flights_df.ORIGIN_AIRPORT.apply(str).apply(len) == 3) & (flights_df.DESTINATION_AIRPORT.apply(str).apply(len) == 3)]
```

### Merging data together

```python
flights_df = flights_df.merge(
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
flights_df.head()
```

### Missing Values

- Ask: What are our options for rows with missing data?

```python
flights_df.isnull().sum().T
```

```python
flights_df.loc[flights_df.ORIGIN_LATITUDE.isnull()].ORIGIN_AIRPORT.value_counts()
```

```python
flights_df.loc[flights_df.DESTINATION_LATITUDE.isnull()].DESTINATION_AIRPORT.value_counts()
```

```python
flights_df.loc[flights_df.ORIGIN_AIRPORT.isin(['ECP','PBG','UST'])].head()
```

<!-- #region -->
for now, let's keep these missing. We can test what imputation strategy has the largest impact when we build predictors. 


we can do this because the number of airports affected is relatively small
<!-- #endregion -->

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
flights_df[['ARRIVAL_DELAY',*cols_of_interest]].corr().ARRIVAL_DELAY.sort_values(ascending=False)
```


```python
for airline in flights_df.AIRLINE_CLEANED.unique():
    print(airline)
    print(flights_df.loc[flights_df.AIRLINE_CLEANED == airline][['ARRIVAL_DELAY',*cols_of_interest]].corr().ARRIVAL_DELAY.sort_values(ascending=False))
    print("-------------------------------------------------")
```

- Ask: How long should data cleaning normally take?

- Ask: Who from the client should we talk with about data cleaning?


## Output

```python
flights_df.to_csv(data_path + "cleaned_data.csv", index=False)
```

```python

```
