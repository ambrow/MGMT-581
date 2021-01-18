# Week 5

Welcome to the fifth week of MGMT 581. This markdown file will walk through the questions we've answered and exercises we've performed in the class lecture.

## Load the data
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

```python
# probably change this to the intermediate file saved locally in the data folder or something like that
years = ["2018", "2019"]
states = ["DC", "MD", "VA"]

# instantiate the object with the list of states and years
interface = HMDAInterface(states, years)
interface.load()
```

```python
interface.data.head(15)
```

## Pipelines

- Ask What do we mean by a data pipeline?

- Ask Why do we create data pipelines?

- Ask What do we do with data pipelines once the project is done?

## Supervised Learning

- Ask What do we mean when we say supervised learning?

- Ask How would you explain a supervised learning model to a non-technical client?

- Ask What supervised learning techniques do you want to try out on our data?