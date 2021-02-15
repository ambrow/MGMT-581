# Week 3

Welcome to the third week of MGMT 581. This markdown file will walk through the questions we've answered and exercises we've performed in the class lecture.

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

## Visualization

- Ask What are the charts you always build when you get new data sets?

- Ask How do you know what type of chart to present to your clients?


### Basic charts that are always needed


#### Distributions


#### scatter plots

```python
fig, ax = plt.subplots(figsize=(20,12))
sns.scatterplot(data = rejected_df, x='loan_amount', y='income')
```

```python
fig, ax = plt.subplots(figsize=(20,12))
sns.scatterplot(data = rejected_df, x='loan_amount', y='income', hue='denial_reason-1')
```

```python
fig, ax = plt.subplots(figsize=(20,12))
sns.scatterplot(data = accepted_df, x='loan_amount', y='income', hue='loan_purpose_clean')
```

#### group means

```python
fig, ax = plt.subplots(figsize=(20,12))
sns.barplot(data = accepted_df.groupby('loan_purpose_clean').loan_amount.mean().reset_index(), x='loan_purpose_clean', y='loan_amount')
```

```python
fig, ax = plt.subplots(figsize=(20,12))
sns.barplot(data = accepted_df.groupby('loan_purpose_clean').loan_amount.median().reset_index(), x='loan_purpose_clean', y='loan_amount')
```

```python
fig, ax = plt.subplots(figsize=(20,12))
sns.barplot(data = accepted_df.groupby('loan_purpose_clean').income.mean().reset_index(), x='loan_purpose_clean', y='income')
```

```python
fig, ax = plt.subplots(figsize=(20,12))
sns.boxplot(data = accepted_df, x='loan_purpose_clean', y='loan_amount', hue='loan_purpose_clean')
```

#### correlation plots

```python
# Compute the correlation matrix
corr = accepted_df[['income','loan_amount','property_value_clean','loan_to_value_ratio_clean','rate_spread','interest_rate']].corr()
# Generate a mask for the upper triangle
mask = np.zeros_like(corr, dtype=np.bool)
mask[np.triu_indices_from(mask)] = True

# Set up the matplotlib figure
fig, ax = plt.subplots()

# Draw the heatmap with the mask and correct aspect ratio
vmax = np.abs(corr.values[~mask]).max()
sns.heatmap(corr, mask=mask, cmap=plt.cm.PuOr, vmin=-vmax, vmax=vmax,
            square=True, linecolor="lightgray", linewidths=1, ax=ax)
for i in range(len(corr)):
    ax.text(i+0.5,(i+0.5), corr.columns[i], 
            ha="center", va="center", rotation=45)
    for j in range(i+1, len(corr)):
        s = "{:.3f}".format(corr.values[i,j])
        ax.text(j+0.5,(i+0.5),s, 
            ha="center", va="center")
ax.axis("off")
plt.show()
```

#### maps

```python

```
