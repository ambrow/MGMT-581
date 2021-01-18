# Week 1

Welcome to the first week of MGMT 581. This markdown file will walk through the questions we've answered and exercises we've performed in the class lecture.

## Load the data
```python
# Imports
import pandas as pd
import numpy as np
import seaborn as sns
import os
import sys

# path hack to allow imports from helper function .py files
n_up = os.getcwd().partition("python")[2].count("/")
sys.path.insert(0, os.path.abspath("../"*n_up))

from hmda import HMDAInterface

# Don't want to restart the kernel whenever a module is updated
%load_ext autoreload
%autoreload 2

# Changing Pandas options
pd.options.display.max_rows = 999
pd.options.display.max_columns = 999
pd.set_option('display.float_format', lambda x: '%.5f' % x)
```

```python
years = ["2018", "2019"]
states = ["DC", "MD", "VA"]

# instantiate the object with the list of states and years
interface = HMDAInterface(states, years)
interface.load()
```

```python
interface.data.head(15)
```

## In an ideal world, what question would you want to answer with this dataset?


Poll:
- poll everywhere allows free response + upvote of others
- could also do a mult choice on zoom


## The Business problem 
Financial institutions MUST provide the government a reason for rejecting loans. We at the CFPB wish to determine two things via a data driven approach:
1. For accepted loans, are the banks lending appropriate amounts based on the customer information we have assembled? 
2. For rejected loans are there reasons that are not part of the legally allowable set?

This dataset contains a list of reported loans accepted and rejected within 3 states for 2018 and 2019. It also comes with numerous other columns you might find helpful. Additionally, we have accessed data from the American Community Survey that could provide additional color to your analysis. 


### Translating this problem into something we can solve Analytically

When you hear these questions, what immediately comes to your mind?


- Linear Regression: can we accurately use predictor variables to predict loan amount?
- Tree based models: are there non-linear corner cases in the data that are easy to identify via decision tree based models?
- Clustering: are there specific groups within the data that have different characteristics and as a result have different loan amounts?


## Explore the dataset

- Ask: What checks do you normally perform when you are handed a dataset you've never seen before?


- Ask: What questions do you ask of the people who provided you the data?

```python
interface.data.shape
```

```python
for types in interface.data.dtypes.unique():
    print("--------------------")
    print(f"data type: {types}")
    print("--------------------")
    for col in interface.data.loc[:,interface.data.dtypes == types].columns.tolist():
        print(f"column: {col}")
        print("^^^^^")
```

```python
groups = ["activity_year", "state_code"]

interface.data.groupby(groups).lei.count()
```

```python
groups = ["activity_year", "state_code", "action_taken"]

interface.data.groupby(groups).lei.count()
```

```python
interface.data.isnull().sum().T
```

```python
groups = ["activity_year", "state_code", "action_taken"]
acceptable_actions = [1,3]
interface.data.loc[interface.data.action_taken.isin(acceptable_actions)].groupby(groups).agg(lambda x: sum(x.isnull()))
```

```python
groups = ["action_taken"]
acceptable_actions = [1,3]
agg_dict = {
    'loan_amount':['mean', 'median', 'std', lambda x: np.sum(x.isnull()), lambda x: np.sum(~x.isnull())],
    'income':['mean', 'median', 'std', lambda x: np.sum(x.isnull()), lambda x: np.sum(~x.isnull())],
}

interface.data.loc[
    interface.data.action_taken.isin(acceptable_actions)
].groupby(
    groups
).agg(
    agg_dict
)
```

```python
sns.displot(data = interface.data.loc[
    interface.data.action_taken.isin([1])
].sample(100000), x='income', rug=True, kind="kde")
```

```python
sns.displot(data = interface.data.loc[
    interface.data.action_taken.isin([3])
].sample(100000), x='income', rug=True, kind = 'kde')
```

```python
groups = ["action_taken", "applicant_race_observed"]
acceptable_actions = [1,3]
agg_dict = {
    'loan_amount':['mean', 'median', 'std', lambda x: np.sum(x.isnull()), lambda x: np.sum(~x.isnull())],
    'income':['mean', 'median', 'std', lambda x: np.sum(x.isnull()), lambda x: np.sum(~x.isnull())],
}

interface.data.loc[
    interface.data.action_taken.isin(acceptable_actions)
].groupby(
    groups
).agg(
    agg_dict
)
```

```python
groups = ["action_taken", "applicant_race_observed", "applicant_sex_observed"]
acceptable_actions = [1,3]
agg_dict = {
    'loan_amount':['mean', 'median', 'std', lambda x: np.sum(x.isnull()), lambda x: np.sum(~x.isnull())],
    'income':['mean', 'median', 'std', lambda x: np.sum(x.isnull()), lambda x: np.sum(~x.isnull())],
}

interface.data.loc[
    interface.data.action_taken.isin(acceptable_actions)
].groupby(
    groups
).agg(
    agg_dict
)
```

```python

```
