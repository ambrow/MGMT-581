```python
# Imports
import pandas as pd
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

# Python Introduction to the HMDA data

In this notebook, you'll find a quick tutorial of the functions & classes I've coded up to access the HMDA notebook. It will be updated as the class moves forward.


## Load the data

You might be wondering, how do I load the data? Given this dataset is so large, I don't want each of you to download it locally and have to resolve various path issues. Instead, we will load directly from the web via a free API call.

```python
# Simply define the years (after 2018)
years = ["2018", "2019"]
# and the states (a small subset is usually enough)
states = ["DC", "MD", "VA"]

# instantiate the object with the list of states and years
interface = HMDAInterface(states, years)
```

```python
interface.load()
```

The data attribute of the interface contains our dataset. We can access it directly in python via the . notation and use it just like a normal pandas dataframe

```python
interface.data.shape
```

```python
interface.data.describe().T
```

```python
for col in interface.data.loc[:,interface.data.dtypes == object]:
    print(col)
    print(interface.data[col].value_counts().sort_values(ascending=False).reset_index().head(6))
```

As you can see from the above glances at the dataset, *there is quite a bit to unpack in this dataset*. In fact, if you actually tried to look through what is above without being immediately overwhelmed, you are among very few folks who will do that type of search into quick and dirty checks like that. 

**99 columns** is large to go through, and on top of that we have **> 500K rows** as well. Thankfully, python is built to simplify a dataset like this into critical insights for a business. 

Below we will showcase a few quick things about this dataset:
- Filtering to a certain subset of outcomes
- Changing data types and coded values for particular variables
- Honing in to the specific set of variables we will need moving forward

```python
# The action_taken column is interesting
interface.data.action_taken.value_counts(ascending=False).reset_index()

# 1 indicates approval and 3 indicates rejection. The others are coded for other behaviors that might be interesting but we won't explore for this course
```

```python
# to filter, we simply use the .loc command on the dataframe

interface.data.loc[interface.data.action_taken.isin([1,3]),:]
```

We can also define a set of cleaning functions to do this any time we need to. Since this data will be continuously used, I've defined a `HMDACleaner` class to do just that. An example of the `HMDAInterface` class using the cleaner is shown below to filter the dataset, change column values to something more interpretable.

```python
steps = ["action_taken","loan_type","loan_purpose","hoepa","occupancy"]
interface.clean(steps)
```

```python
subset_cols = ["activity_year", "lei", "action_taken", "loan_type","loan_purpose","hoepa_status", "occupancy_type"]

for col in interface.data_cleaned.filter(like="_clean", axis = 1).columns.tolist():
    subset_cols.append(col)

interface.data_cleaned[subset_cols].head()
```

Changing data types is nearly always something we will need to be comfortable with because of its prevalence in real world datasets
As you've seen above, it is easier to store a semi-complex category attribute as integers from 1-8 because you ultimately save memory

```python

```
