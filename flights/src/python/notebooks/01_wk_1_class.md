# Week 1

Welcome to the first week of MGMT 581. This markdown file will walk through the questions we've answered and exercises we've performed in the class lecture.

## Load the data
```python
import pandas as pd
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

## In an ideal world, what question would you want to answer with this dataset?


Poll:
- poll everywhere allows free response + upvote of others
- could also do a mult choice on zoom


## The Business problem 
Delayed flights are an absolutely miserable customer experience. As a customer, I'm curious to avoid flights that are likely to be delayed when making purchasing decisions. We can use this data to build a model that helps me feel confident in those decisions (and that my flight won't be delayed!)

There are two approaches we will follow in this course:
1. Can we predict how delayed a flight will be (continuous target variable)
2. Can we predict whether or not a flight will be delayed by 30 minutes or more? (binary target)


### Translating this problem into something we can solve Analytically

When you hear these questions, what immediately comes to your mind?


- Linear Regression: can we accurately use predictor variables to predict loan amount?
- Tree based models: are there non-linear corner cases in the data that are easy to identify via decision tree based models?
- Clustering: are there specific groups within the data that have different characteristics and as a result have different delay times?


## Explore the dataset

- Ask: What checks do you normally perform when you are handed a dataset you've never seen before?


- Ask: What questions do you ask of the people who provided you the data?

```python
flights_df.shape
```

```python
for types in flights_df.dtypes.unique():
    print("--------------------")
    print(f"data type: {types}")
    print("--------------------")
    for col in flights_df.loc[:,flights_df.dtypes == types].columns.tolist():
        print(f"column: {col}")
        print("^^^^^")
```

```python
groups = ["ORIGIN_AIRPORT", "DESTINATION_AIRPORT"]

flights_df.groupby(groups).FLIGHT_NUMBER.count()
```

```python
groups = ["ORIGIN_AIRPORT", "DESTINATION_AIRPORT", "MONTH"]

flights_df.groupby(groups).FLIGHT_NUMBER.count()
```

```python
flights_df.isnull().sum().T
```



```python
fig,ax = plt.subplots(figsize=(20,12))
sns.scatterplot(data = flights_df, x='SCHEDULED_DEPARTURE', y='SCHEDULED_ARRIVAL')
```

```python
p = sns.FacetGrid(data=flights_df, col='DAY_OF_WEEK')
p.map(sns.scatterplot,'SCHEDULED_DEPARTURE', 'SCHEDULED_ARRIVAL')
p.add_legend()
```

```python
flights_df.CANCELLED.sum()
```

```python
flights_df.groupby(['MONTH','DAY_OF_WEEK']).CANCELLED.sum()
```

```python
flights_df.DIVERTED.sum()
```

```python
flights_df.groupby(['MONTH','DAY_OF_WEEK']).DIVERTED.sum()
```

```python
fig,ax = plt.subplots(figsize=(20,12))
sns.scatterplot(data = flights_df, x='WHEELS_ON', y='WHEELS_OFF')
```

```python
fig,ax = plt.subplots(figsize=(8,6))
sns.scatterplot(data = flights_df, x='SCHEDULED_TIME', y='ELAPSED_TIME', hue='DISTANCE')
```

```python
(flights_df.DEPARTURE_TIME + flights_df.TAXI_OUT == flights_df.WHEELS_OFF).sum() == flights_df.shape[0]
```

```python
(flights_df.DEPARTURE_TIME + flights_df.TAXI_OUT == flights_df.WHEELS_OFF).sum() / flights_df.shape[0]
```

```python
(flights_df.SCHEDULED_DEPARTURE + flights_df.DEPARTURE_DELAY == flights_df.DEPARTURE_TIME).sum() == flights_df.shape[0]
```

```python
flights_df.loc[flights_df.DEPARTURE_TIME + flights_df.TAXI_OUT != flights_df.WHEELS_OFF].head()
```

```python
(flights_df.SCHEDULED_DEPARTURE + flights_df.DEPARTURE_DELAY == flights_df.DEPARTURE_TIME).sum() / flights_df.shape[0]
```

```python
flights_df.loc[flights_df.SCHEDULED_DEPARTURE + flights_df.DEPARTURE_DELAY != flights_df.DEPARTURE_TIME].head()
```

```python
flights_df.CANCELLATION_REASON.value_counts()
```

```python

```
