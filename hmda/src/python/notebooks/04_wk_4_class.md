# Week 4

Welcome to the fourth week of MGMT 581. This markdown file will walk through the questions we've answered and exercises we've performed in the class lecture.

## Load the data
```python
# Imports
import pandas as pd
import numpy as np
import os
import sys

import matplotlib.pyplot as plt
import seaborn as sns


# Changing Pandas options
pd.options.display.max_rows = 999
pd.options.display.max_columns = 999
pd.set_option('display.float_format', lambda x: '%.5f' % x)
```

```python
data_path = os.getcwd().partition("src")[0] + "data/"
accepted = "accepted_loans.csv"
rejected = "rejected_loans.csv"
```

```python
accepted_df = pd.read_csv(data_path + accepted)
accepted_df.head()
```

## Joining data together

- Ask What experience do you have with joins?

- Ask How do you check joins?

- Ask What should our joins look like for this project?

## Heuristics

- Ask How do you summarize large datasets to non-technical stakeholders?

- Ask What heuristics are you familiar with?

- Ask If someone totally random came into our classroom and asked for a loan, what would our best guess be for that loan amount (knowing nothing about this person)
