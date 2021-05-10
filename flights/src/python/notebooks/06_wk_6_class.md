# Week 6

Welcome to the sixth week of MGMT 581. This markdown file will walk through the questions we've answered and exercises we've performed in the class lecture.


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
flights_df = pd.read_csv(data_path + "cleaned_outbound_data.csv")
flights_df.head()
```

### the weather data

```python
chicago_temp = pd.read_csv(data_path + "temperature.csv")[['datetime','Chicago']]
```

```python
chicago_temp
```

```python
# tell python this variable is a date
chicago_temp['datetime'] = pd.to_datetime(chicago_temp.datetime)
```

```python
# use the dt attribute to pull out various elements of the date (year, month, etc)
chicago_temp['YEAR'] = chicago_temp.datetime.dt.year
chicago_temp['MONTH'] = chicago_temp.datetime.dt.month
chicago_temp['DAY'] = chicago_temp.datetime.dt.day
chicago_temp['HOUR'] = chicago_temp.datetime.dt.hour
```

```python
chicago_temp
```

```python
wind_speed = pd.read_csv(data_path + "wind_speed.csv")[['datetime','Chicago']].rename(columns = {'Chicago':'wind_speed'})
weather = pd.read_csv(data_path + "weather_description.csv")[['datetime','Chicago']].rename(columns = {'Chicago':'weather_description'})
```

```python
weather = weather.join(pd.get_dummies(weather.weather_description))
```

```python
wind_speed['datetime'] = pd.to_datetime(wind_speed.datetime)
wind_speed['YEAR'] = wind_speed.datetime.dt.year
wind_speed['MONTH'] = wind_speed.datetime.dt.month
wind_speed['DAY'] = wind_speed.datetime.dt.day
wind_speed['HOUR'] = wind_speed.datetime.dt.hour
```

```python
weather['datetime'] = pd.to_datetime(weather.datetime)
weather['YEAR'] = weather.datetime.dt.year
weather['MONTH'] = weather.datetime.dt.month
weather['DAY'] = weather.datetime.dt.day
weather['HOUR'] = weather.datetime.dt.hour
```

```python
weather.head()
```

## Joining data together - as discussed last week


```python
# LEFT join on year, month, day, hour
# join_ex is left df
# chicago_temp is right_df
# we end up with 100 rows in our result
# this is because there is 1 row per day in chicago_temp that matches to the flights 
flights_df = flights_df.merge(
    chicago_temp, 
    how = 'left', 
    left_on = ['YEAR', 'MONTH', 'DAY', 'SCHEDULED_DEPARTURE_HOUR'], 
    right_on = ['YEAR', 'MONTH', 'DAY', chicago_temp.HOUR.shift(1).fillna(0)]
)
flights_df = flights_df.merge(
    wind_speed, 
    how = 'left', 
    left_on = ['YEAR', 'MONTH', 'DAY', 'SCHEDULED_DEPARTURE_HOUR'], 
    right_on = ['YEAR', 'MONTH', 'DAY', wind_speed.HOUR.shift(1).fillna(0)]
)
flights_df = flights_df.merge(
    weather, 
    how = 'left', 
    left_on = ['YEAR', 'MONTH', 'DAY', 'SCHEDULED_DEPARTURE_HOUR'], 
    right_on = ['YEAR', 'MONTH', 'DAY', weather.HOUR.shift(1).fillna(0)]
)
```

```python
flights_df.head()
```

## Pipelines

```python
flights_df.columns.tolist()
```

```python
flights_df['bad_weather'] = flights_df.apply(
    lambda x: 1 if x['thunderstorm'] == 1 or 
    x['thunderstorm with drizzle'] == 1 or 
    x['thunderstorm with heavy rain'] == 1
    or 
    x['thunderstorm with light drizzle'] == 1
    or 
    x['thunderstorm with light rain'] == 1
    or 
    x['very heavy rain'] == 1
    or 
    x['squalls'] == 1
    or 
    x['snow'] == 1
    or 
    x['proximity shower rain'] == 1
    or 
    x['proximity thunderstorm with drizzle'] == 1
    or 
    x['proximity thunderstorm with rain'] == 1
    or 
    x['proximity thunderstorm'] == 1
    or 
    x['freezing rain'] == 1
    or 
    x['fog'] == 1
    or 
    x['heavy snow'] == 1
    else 0, axis=1)
```

```python
# Let's build a simple model, just for flights leaving Chicago O'Hare
# We want to use facts about the flight itself
```

```python
flights_df = flights_df.loc[flights_df.ORIGIN_AIRPORT == 'ORD']
```

**What variables should we use?**

```python
vars_of_interest = [
    # real continuous
    'DISTANCE',
    # can treat as continuous - maybe do something different?
    'SCHEDULED_DEPARTURE_HOUR',
    'SCHEDULED_DEPARTURE_MINUTES',
    'SCHEDULED_ARRIVAL_HOUR',
    'SCHEDULED_ARRIVAL_MINUTES',
    'DESTINATION_LATITUDE',
    'DESTINATION_LONGITUDE',
    # dummy encode
    'AIRLINE_CLEANED',
    'DAY_OF_WEEK_CLEANED',
    'MONTH_CLEANED',
]
```

#### dummy coding

```python
flights_df['AIRLINE_CLEANED']
```

```python
pd.get_dummies(flights_df['AIRLINE_CLEANED']).head()
```

```python
flights_df.merge(
    pd.get_dummies(flights_df['AIRLINE_CLEANED']), how = 'left', left_index=True, right_index=True
).head()
```

```python
flights_df.join(
    pd.get_dummies(flights_df['AIRLINE_CLEANED'])
).head()
```

```python
flights_df = flights_df.join(pd.get_dummies(flights_df['AIRLINE_CLEANED']))
```

```python
flights_df.DAY_OF_WEEK_CLEANED
```

```python
flights_df.MONTH_CLEANED
```

```python
flights_df = flights_df.join(pd.get_dummies(flights_df['DAY_OF_WEEK_CLEANED']))
flights_df = flights_df.join(pd.get_dummies(flights_df['MONTH_CLEANED']))
```

```python
flights_df.head()
```

**Are there other variables you would create?**

```python
# use the apply function to access the values in the scheduled departure hour column
# use if logic to check various times
# assign various time blocks to certain values
flights_df['departure_shift'] = flights_df.SCHEDULED_DEPARTURE_HOUR.apply(lambda x: 3 if (x > 0) & (x < 6) else 1 if (x>=7) & (x <=13) else 2 if (x > 13) & (x <= 20) else 3)
flights_df['arrival_shift'] = flights_df.SCHEDULED_ARRIVAL_HOUR.apply(lambda x: 3 if (x > 0) & (x < 6) else 1 if (x>=7) & (x <=13) else 2 if (x > 13) & (x <= 20) else 3)
flights_df['shift_change'] = (flights_df.departure_shift != flights_df.arrival_shift).astype(int)
```

```python
# overnight
# use logical conditions and convert the true / false result to an integer
flights_df['change_of_day'] = ((flights_df.SCHEDULED_DEPARTURE_HOUR > 21) & (flights_df.SCHEDULED_ARRIVAL_HOUR > 0)).astype(int)
```

```python
# Directional indicators
flights_df['north_to_south'] = (flights_df.ORIGIN_LATITUDE > flights_df.DESTINATION_LATITUDE).astype(int)
flights_df['south_to_north'] = (flights_df.ORIGIN_LATITUDE < flights_df.DESTINATION_LATITUDE).astype(int)
flights_df['east_to_west'] = (flights_df.ORIGIN_LONGITUDE > flights_df.DESTINATION_LONGITUDE).astype(int)
flights_df['west_to_east'] = (flights_df.ORIGIN_LONGITUDE < flights_df.DESTINATION_LONGITUDE).astype(int)
```

```python
flights_df.groupby(
        ["ORIGIN_AIRPORT", "DESTINATION_AIRPORT"]
    ).apply(
        lambda x: (x.DEPARTURE_DELAY.shift(1)>0).cumsum()
    )
```

```python
# past delays
# group by route combination
# shift function looks at the row immediately before (in time)
# look at the cumulative sum of previously delayed flights
# rename, drop, and join the column
flights_df = flights_df.join(
    flights_df.groupby(
        ["ORIGIN_AIRPORT", "DESTINATION_AIRPORT"]
    ).apply(
        lambda x: (x.DEPARTURE_DELAY.shift(1)>0).cumsum()
    ).reset_index(
    ).set_index("level_2").drop(["ORIGIN_AIRPORT",'DESTINATION_AIRPORT'],axis=1).rename(columns = {'DEPARTURE_DELAY':'PAST_DELAYS'}))
```

## Supervised Learning

```python
# linear regression
# We will use statsmodels because the output is easy to generate
```

```python
import statsmodels.api as sm
```

```python
flights_df.columns.tolist()
```

```python
vars_to_keep = [
    'DISTANCE',
    # can treat as continuous - maybe do something different?
    'SCHEDULED_DEPARTURE_HOUR',
    'SCHEDULED_DEPARTURE_MINUTES',
    'SCHEDULED_ARRIVAL_HOUR',
    'SCHEDULED_ARRIVAL_MINUTES',
    'DESTINATION_LATITUDE',
    'DESTINATION_LONGITUDE',
    'Chicago',
    'Alaska Airlines Inc.',
    'American Airlines Inc.',
    'American Eagle Airlines Inc.',
    'Atlantic Southeast Airlines',
    'Delta Air Lines Inc.',
    'Frontier Airlines Inc.',
    'JetBlue Airways',
    'Skywest Airlines Inc.',
    'Spirit Air Lines',
    'US Airways Inc.',
#     for dummy variables we must remove one from our variable set in order to avoide multicollinearity
#      'United Air Lines Inc.',
#     'Virgin America',
    'FRI',
    'MON',
    'SAT',
    'SUN',
    'THU',
    'TUE',
#     'WED',
    'APR',
    'AUG',
    'DEC',
    'FEB',
     'JAN',
    'JUL',
    'JUN',
    'MAR',
    'MAY',
    'NOV',
#     'SEP',
    'departure_shift',
    'arrival_shift',
    'shift_change',
    'change_of_day',
    'north_to_south',
    'south_to_north',
    'east_to_west',
    'west_to_east',
    'PAST_DELAYS',
    'bad_weather',
    'sky is clear',
    'wind_speed'
]
```

```python
len(vars_to_keep)
```

```python
flights_df.shape[0]
```

```python
# Generally we want 10 observations per variable
84 * 10 < flights_df.shape[0]
```

```python
training_sample = flights_df.sample(frac=.75, random_state = 12)
testing_sample = flights_df.loc[~flights_df.index.isin(training_sample)]
```

```python
X = training_sample[vars_to_keep]
```

```python
X.head()
```

```python
# create target and investigate
y = training_sample['DEPARTURE_DELAY']
```

```python
y.head()
```

```python
y.describe()
```

```python
y.hist()
```
## Modeling


```python
X = sm.add_constant(X)
```

```python
model = sm.OLS(y, X)
results = model.fit()
results.summary()
```

## Model Evaluation

```python
results.rsquared
```

```python
sns.displot(results.predict())
```


```python
x_test = testing_sample[vars_to_keep]
x_test = sm.add_constant(x_test)
y_test = testing_sample['DEPARTURE_DELAY']
```

```python
y_pred = results.predict(x_test)
y_pred[:5]
```

```python
fig, ax = plt.subplots(figsize = (10,6))
ax.set_xlim(-10,600)
ax.set_ylim(-10, 600)
sns.scatterplot(x = y_test, y = y_pred)
```

```python
prediction_error = y_pred - y_test
abs_error = np.abs(prediction_error)
mean_abs_error = np.mean(abs_error)
abs_percentage_error = abs_error / np.where(y_test==0,.001, y_test)
mean_abs_percentage_error = np.mean(abs_percentage_error)
```

```python
using_the_mean = np.mean(y) - y_test
abs_error_mean = np.abs(using_the_mean)
mean_abs_error_mean = np.mean(abs_error_mean)
abs_percentage_error_mean = abs_error_mean / np.where(y_test==0,.001, y_test)
mean_abs_percentage_error_mean = np.mean(abs_percentage_error_mean)
```

```python
mean_abs_error
```

```python
mean_abs_error_mean
```

```python
mean_abs_percentage_error
```

```python
mean_abs_percentage_error_mean
```

```python
sns.distplot(prediction_error)
```

```python
prediction_error.describe()
```

```python
using_the_mean.describe()
```

```python
abs_error.describe()
```

```python
abs_percentage_error.describe()
```

```python

```
