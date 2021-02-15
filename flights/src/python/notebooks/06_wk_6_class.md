# Week 6

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
flights_df = pd.read_csv(data_path + "cleaned_data.csv")
flights_df.head()
```

```python
flights_df = flights_df.loc[flights_df.ORIGIN_AIRPORT == 'ORD']
```

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

## Model Evaluation

- Ask How should we measure error?

- Ask Do you have a favorite error metric

- Ask How can we tell if our model is good?

- Ask Why does it matter that we evaluate our model?

- Ask How can we explain our model's performance to non-technical stakeholders

```python
results.rsquared
```

```python
sns.displot(results.predict())
```


## Classification

- Ask What if our client had focused on determining if loans were denied for the correct reasons?

- Ask What is the difference between a regression problem and a classification problem?

- Ask If someone totally random came into our classroom and asked for a loan, what would our best guess be for whether or not this person would receive the loan? (knowing nothing about this person)

- Ask What can be dangerous about classification modeling? What can be beneficial about it?

```python
new_target = (y > 60).astype(int)
```

```python
new_target
```

```python
log_reg = sm.Logit(new_target, X).fit()
log_reg.summary()
```

```python
sns.displot(log_reg.predict())
```

```python
for val in [.1,.2,.3,.4,.5]:
    print(val)
    cm = log_reg.pred_table(val)
    print(cm)
    print(f"accuracy: {(cm[0][0]+ cm[1][1]) / flights_df.shape[0]}, precision: {cm[1][1] / (cm[1][0] + cm[1][1])}, recall: {cm[1][1] / (cm[0][1] + cm[1][1])}")
    print("-----------------------")
```

```python
log_reg.pred_table(.1)
```

```python

```
