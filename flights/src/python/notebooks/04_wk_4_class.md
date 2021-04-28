# Week 4

Welcome to the fourth week of MGMT 581. This markdown file will walk through the questions we've answered and exercises we've performed in the class lecture.

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

## Joining data together


```python
# select a sample of flights
join_ex = flights_df.sample(100)
join_ex.head()
```

```python
join_ex.shape
```

```python
# LEFT join on year, month, day
# join_ex is left df
# chicago_temp is right_df
# we end up with 2400 rows in our result
# this is because there are 24 rows per day in chicago_temp and for each of those 
# we duplicate the information about flights
pd.merge(
        join_ex,
        chicago_temp, 
        how = 'left', 
        on = ['YEAR', 'MONTH', 'DAY']
).shape
```

```python
# LEFT join on year, month, day, hour
# join_ex is left df
# chicago_temp is right_df
# we end up with 100 rows in our result
# this is because there is 1 row per day in chicago_temp that matches to the flights 
join_ex.merge(
    chicago_temp, 
    how = 'left', 
    left_on = ['YEAR', 'MONTH', 'DAY', 'SCHEDULED_DEPARTURE_HOUR'], 
    right_on = ['YEAR', 'MONTH', 'DAY', 'HOUR']
).shape
```

```python
# an inner join is the same as a left join for our flights vs temperature data
join_ex.merge(
    chicago_temp, 
    how = 'inner', 
    left_on = ['YEAR', 'MONTH', 'DAY', 'SCHEDULED_DEPARTURE_HOUR'], 
    right_on = ['YEAR', 'MONTH', 'DAY', 'HOUR']
).shape
```

```python
# RIGHT JOIN and LEFT JOIN ARE INVERSES
join_ex.merge(
    chicago_temp, 
    how = 'right', 
    left_on = ['YEAR', 'MONTH', 'DAY', 'SCHEDULED_DEPARTURE_HOUR'], 
    right_on = ['YEAR', 'MONTH', 'DAY', 'HOUR']
).shape
```

```python
chicago_temp.merge(
    join_ex,
    how='left',
    right_on = ['YEAR', 'MONTH', 'DAY', 'SCHEDULED_DEPARTURE_HOUR'],
    left_on = ['YEAR','MONTH', 'DAY', 'HOUR']
).shape
```

```python
# OUTER JOIN
join_ex.merge(
    chicago_temp, 
    how = 'outer', 
    left_on = ['YEAR', 'MONTH', 'DAY', 'SCHEDULED_DEPARTURE_HOUR'], 
    right_on = ['YEAR', 'MONTH', 'DAY', 'HOUR']
)
```

## Heuristics

```python
# The mean is 8 minutes late
# that means our best guess on delay will be 8 minutes
# you could also guess the median (4 minutes early)
flights_df.ARRIVAL_DELAY.describe()
```

```python
# we can use the scheduled departure hour
# to make our heuristic more detailed
# and say if our flight is leaving from 5-9 am, the average delay is only 2 minutes instead of 8
flights_df.groupby(
    # create bins for the departure hour
    pd.cut(
        flights_df.SCHEDULED_DEPARTURE_HOUR, 
        [-1, 5, 9, 13, 18, 25]
    )
).ARRIVAL_DELAY.mean()
```

```python
# 23% of fligths were delayed overall
(flights_df.ARRIVAL_DELAY > 15).sum() / flights_df.shape[0]
```

```python
# are flights delayed at different rates for different hours
for hour in flights_df.SCHEDULED_DEPARTURE_HOUR.unique():
    print(hour)
    print((flights_df.loc[flights_df.SCHEDULED_DEPARTURE_HOUR == hour].ARRIVAL_DELAY > 15).sum() / flights_df.loc[flights_df.SCHEDULED_DEPARTURE_HOUR == hour].shape[0])
    print("--------------------")
```

```python
# measuring error of our heuristics
true_amounts = flights_df.ARRIVAL_DELAY.sort_values().values
```

```python
error_mean = true_amounts - flights_df.ARRIVAL_DELAY.mean()
error_median = true_amounts - flights_df.ARRIVAL_DELAY.median()
```

```python
true_amounts = np.where(true_amounts == 0, .00001, true_amounts)
```

```python
sns.displot(true_amounts, kind='kde', rug=True)
plt.axvline(flights_df.ARRIVAL_DELAY.mean(), color='red')
plt.axvline(flights_df.ARRIVAL_DELAY.median(), color = 'grey')
```

```python
sns.displot(np.log(true_amounts), kind='kde', rug=True)
plt.axvline(np.log(flights_df.ARRIVAL_DELAY.mean()), color='red')
plt.axvline(np.log(flights_df.ARRIVAL_DELAY.median()), color = 'grey')
```

#### Absolute error metrics

```python
np.mean(np.abs(error_mean))
```

```python
np.mean(np.abs(error_median)) 
```

### Percentage error metrics

```python
np.mean(np.abs(error_mean) / true_amounts) * 100
```

```python
np.mean(np.abs(error_median) / true_amounts) * 100
```

```python

```
