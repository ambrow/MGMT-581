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

```python
rejected_df = pd.read_csv(data_path + rejected)
rejected_df.head()
```

## Joining data together

- Ask What experience do you have with joins?

- Ask How do you check joins?

- Ask What should our joins look like for this project?

```python
# do some joins
```

## Heuristics

- Ask How do you summarize large datasets to non-technical stakeholders?

```python
np.quantile(accepted_df.loan_amount,[x for x in np.arange(0.1,1,.1)])
```

```python
np.quantile(accepted_df.income.dropna(),[x for x in np.arange(0.1,1,.1)])
```

```python
rejected_df.loan_amount.describe()
```

- Ask What heuristics are you familiar with?

```python
rejected_df['denial_reason-1'].value_counts()
```

```python
pd.concat([accepted_df, rejected_df]).action_taken_clean.value_counts() / pd.concat([accepted_df, rejected_df]).shape[0]
```

- Ask If someone totally random came into our classroom and asked for a loan, what would our best guess be for that loan amount (knowing nothing about this person)

```python
accepted_df.loan_amount.mean()
```

```python
accepted_df.loan_amount.median()
```

```python
true_amounts = accepted_df.loan_amount.sort_values().values
```

```python
error_mean = true_amounts - accepted_df.loan_amount.mean()
error_median = true_amounts - accepted_df.loan_amount.median()
```

#### Absolute error metrics

```python
np.mean(np.abs(error_mean))
```

```python
np.mean(np.abs(error_median))
```

### Percentage error metrics

```python
np.mean(np.abs(error_mean) / true_amounts) * 100
```

```python
np.mean(np.abs(error_median) / true_amounts) * 100
```
