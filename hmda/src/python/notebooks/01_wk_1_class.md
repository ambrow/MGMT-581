# Week 1

Welcome to the first week of MGMT 581. This markdown file will walk through the questions we've answered and exercises we've performed in the class lecture.

## In an ideal world, what question would you want to answer with this dataset?
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
years = ["2018", "2019"]
states = ["DC", "MD", "VA"]

# instantiate the object with the list of states and years
interface = HMDAInterface(states, years)
interface.load()
```

```python
interface.data.head(15)
```

Poll?
Free response?
list out answers

## The Business problem we are going to solve
Financial institutions MUST provide the government a reason for rejecting loans. We at the CFPB wish to determine if institutions are rejecting loans for reasons within the boundaries the regulators have set for them using a data-driven approach.

This dataset contains a list of reported loans accepted and rejected within 3 states for 2018 and 2019. It also comes with numerous other columns you might find helpful. Additionally, we have accessed data from the American Community Survey that could provide additional color to your analysis. 

PROBABLY NEED TO DEFINE THIS MORE CLEARLY

### Translating this problem into something we can solve Analytically

Ask for interaction
Define a few ways we could analyze this

## Explore the dataset

Ask: What checks do you normally perform when you are handed a dataset you've never seen before?

Ask: What questions do you ask of the people who provided you the data?

