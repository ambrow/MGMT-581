# Week 4

Welcome to the fourth week of MGMT 581. This markdown file will walk through the questions we've answered and exercises we've performed in the class lecture.

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

## Model Evaluation

- Ask How should we measure error?

- Ask Do you have a favorite error metric

- Ask How can we tell if our model is good?

- Ask Why does it matter that we evaluate our model?

- Ask How can we explain our model's performance to non-technical stakeholders

## Classification

- Ask What if our client had focused on determining if loans were denied for the correct reasons?

- Ask What is the difference between a regression problem and a classification problem?

- Ask If someone totally random came into our classroom and asked for a loan, what would our best guess be for whether or not this person would receive the loan? (knowing nothing about this person)

- Ask What can be dangerous about classification modeling? What can be beneficial about it?