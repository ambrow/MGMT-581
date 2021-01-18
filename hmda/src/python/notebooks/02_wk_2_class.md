# Week 2

Welcome to the second week of MGMT 581. This markdown file will walk through the questions we've answered and exercises we've performed in the class lecture.

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

## Scoping the analytics problem

### Supervised model to predict how much a customer should receive based on the data

Poll How long should we ask for to solve this problem?:
- poll everywhere allows free response + upvote of others
- could also do a mult choice on zoom

Poll Are there specific approaches you'd follow for solving this problem (i.e. Agile, waterfall, etc.)?

Poll Who do you need on your team throughout this project to ensure you are actually answering the question the way the client wants you to?


## Data Cleaning

- Ask: What do we mean by data cleaning?

- Ask: What are the critical steps in data cleaning?

- Ask: How long should data cleaning normally take?

- Ask: Who from the client should we talk with about data cleaning?