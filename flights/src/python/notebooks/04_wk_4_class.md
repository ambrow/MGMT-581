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
chicago_temp['datetime'] = pd.to_datetime(chicago_temp.datetime)
```

```python
chicago_temp['YEAR'] = chicago_temp.datetime.dt.year
chicago_temp['MONTH'] = chicago_temp.datetime.dt.month
chicago_temp['DAY'] = chicago_temp.datetime.dt.day
chicago_temp['HOUR'] = chicago_temp.datetime.dt.hour
```

## Joining data together


```python
join_ex = flights_df.sample(100)
```

```python
join_ex.merge(chicago_temp, how = 'left', left_on = ['YEAR', 'MONTH', 'DAY'], right_on = ['YEAR', 'MONTH', 'DAY'])
```

```python
# do some joins
join_ex.merge(chicago_temp, how = 'left', left_on = ['YEAR', 'MONTH', 'DAY', 'SCHEDULED_DEPARTURE_HOUR'], right_on = ['YEAR', 'MONTH', 'DAY', 'HOUR'])
```

```python
join_ex.merge(chicago_temp, how = 'inner', left_on = ['YEAR', 'MONTH', 'DAY', 'SCHEDULED_DEPARTURE_HOUR'], right_on = ['YEAR', 'MONTH', 'DAY', 'HOUR'])
```

```python
join_ex.merge(chicago_temp, how = 'right', left_on = ['YEAR', 'MONTH', 'DAY', 'SCHEDULED_DEPARTURE_HOUR'], right_on = ['YEAR', 'MONTH', 'DAY', 'HOUR'])
```

```python
join_ex.merge(chicago_temp, how = 'outer', left_on = ['YEAR', 'MONTH', 'DAY', 'SCHEDULED_DEPARTURE_HOUR'], right_on = ['YEAR', 'MONTH', 'DAY', 'HOUR'])
```

## Heuristics

- Ask How do you summarize large datasets to non-technical stakeholders?

```python
np.quantile(flights_df.ARRIVAL_DELAY,[x for x in np.arange(0.1,1,.1)])
```

```python
np.quantile(flights_df.DISTANCE,[x for x in np.arange(0.1,1,.1)])
```

```python
flights_df.SCHEDULED_DEPARTURE_HOUR.describe()
```

- Ask What heuristics are you familiar with?

```python
flights_df.AIRLINE_DELAY.value_counts()
```

```python
(flights_df.ARRIVAL_DELAY > 15).sum() / flights_df.shape[0]
```

```python
for hour in flights_df.SCHEDULED_DEPARTURE_HOUR.unique():
    print(hour)
    print((flights_df.loc[flights_df.SCHEDULED_DEPARTURE_HOUR == hour].ARRIVAL_DELAY > 15).sum() / flights_df.loc[flights_df.SCHEDULED_DEPARTURE_HOUR == hour].shape[0])
    print("--------------------")
```

- Ask If someone totally random came into our classroom and asked which flight to purchase, what would our best guess be for the length of that flight's delay

```python
flights_df.ARRIVAL_DELAY.mean()
```

```python
flights_df.ARRIVAL_DELAY.median()
```

```python
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
