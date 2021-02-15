# Week 5

Welcome to the fifth week of MGMT 581. This markdown file will walk through the questions we've answered and exercises we've performed in the class lecture.

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
flights_df = pd.read_csv(data_path + "cleaned_data.csv")
flights_df.head()
```

## Pipelines

- Ask What do we mean by a data pipeline?

- Ask Why do we create data pipelines?

- Ask What do we do with data pipelines once the project is done?

```python
flights_df.columns.tolist()
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
pd.get_dummies(flights_df['AIRLINE_CLEANED']).head()
```

```python
flights_df = flights_df.join(pd.get_dummies(flights_df['AIRLINE_CLEANED']))
```

```python
flights_df = flights_df.join(pd.get_dummies(flights_df['DAY_OF_WEEK_CLEANED']))
flights_df = flights_df.join(pd.get_dummies(flights_df['MONTH_CLEANED']))
```

**Are there other variables you would create?**

```python
vars_to_create = [
    # shift
    # overnight
    # into next day
    # west to east
    # east to west
    # north to south
    # south to north
    # normal flight
    # past delays on this route
    # others?
]
```

## Supervised Learning

- Ask What do we mean when we say supervised learning?

- Ask How would you explain a supervised learning model to a non-technical client?

- Ask What supervised learning techniques do you want to try out on our data?

```python
# linear regression
# We will use statsmodels because the output is easy to generate
```

```python
import statsmodels.api as sm
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
    # for dummy variables we must remove one from our variable set in order to avoide multicollinearity
    #  'United Air Lines Inc.',
    'Virgin America',
    'FRI',
    'MON',
    'SAT',
#     'SUN',
    'THU',
    'TUE',
    'WED',
    'APR',
    'AUG',
    'DEC',
    'FEB',
    #  'JAN',
    'JUL',
    'JUN',
    'MAR',
    'MAY',
    'NOV',
    'SEP'
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
X = flights_df[vars_to_keep]
```

```python
X.head()
```

```python
y = flights_df['ARRIVAL_DELAY']
```

```python
y.head()
```

```python
X = sm.add_constant(X)
```

```python
model = sm.OLS(y, X)
results = model.fit()
results.summary()
```

```python

```
