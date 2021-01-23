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

Discussion: Workplan - how would we go about planning to solve this problem?


## Data Cleaning

- Ask: What do we mean by data cleaning?

- Ask: What are the critical steps in data cleaning?

### Recoding Categorical variables
```python
steps = ["action_taken","loan_type","loan_purpose","hoepa","occupancy"]
interface.clean(steps)
```

```python
interface.data_cleaned.columns.tolist()
```

```python
interface.data_cleaned.applicant_age.value_counts()
```

```python
subset_cols = ["activity_year", "lei", "action_taken", "loan_type","loan_purpose","hoepa_status", "occupancy_type"]

for col in interface.data_cleaned.filter(like="_clean", axis = 1).columns.tolist():
    subset_cols.append(col)

interface.data_cleaned[subset_cols].head()
```

```python
groups = ["activity_year", "state_code"]

interface.data_cleaned.groupby(groups).lei.count()
```

```python
groups = ["activity_year", "state_code", "action_taken_clean"]

interface.data_cleaned.groupby(groups).lei.count()
```

```python
groups = ["activity_year", "state_code", "action_taken_clean", "loan_purpose_clean"]

interface.data_cleaned.groupby(groups).lei.count()
```

### Recoding Numeric Variables
```python
interface.data_cleaned[["income", "loan_amount", "loan_term", "action_taken_clean","loan_to_value_ratio",'property_value']].dtypes
```

```python
interface.data_cleaned.head()[["income","loan_amount", "loan_term", "action_taken_clean","loan_to_value_ratio",'property_value']]
```

```python
steps = ["action_taken","loan_type","loan_purpose","hoepa","occupancy", "property_value", "loan_to_value_ratio"]
interface.clean(steps)
```

```python
subset_cols = ["activity_year", "lei", "action_taken", "loan_type","loan_purpose","hoepa_status", "occupancy_type", "property_value", "loan_to_value_ratio"]

for col in interface.data_cleaned.filter(like="_clean", axis = 1).columns.tolist():
    subset_cols.append(col)

interface.data_cleaned[subset_cols].head()
```

```python
interface.data_cleaned[subset_cols].dtypes
```

### Data Errors / Unexpected values

```python
subset_cols = ["activity_year", "state_code", "action_taken_clean","loan_amount","income", "loan_type_clean","loan_purpose_clean"]
interface.data_cleaned.loc[interface.data_cleaned.income < 0].head(15)[subset_cols]
```

```python
interface.data_cleaned.loc[interface.data_cleaned.loan_amount < 10000].head(15)[subset_cols]
```

```python
interface.data_cleaned.loc[interface.data_cleaned.applicant_age.isin(["8888", "9999"])].head(15)[[*subset_cols, "applicant_age"]]
```

### Missing Values

- Ask: What are our options for rows with missing data?

```python
interface.data_cleaned.isnull().sum().T
```

### Correlation

```python
cols_of_interest = ["loan_amount","income","property_value_clean","loan_to_value_ratio_clean","tract_population","tract_minority_population_percent","tract_median_age_of_housing_units"]
interface.data_cleaned.loc[interface.data_cleaned.action_taken == 1][cols_of_interest].corr()
```


```python
interface.data_cleaned.loc[interface.data_cleaned.action_taken == 3][cols_of_interest].corr()
```

- Ask: How long should data cleaning normally take?

- Ask: Who from the client should we talk with about data cleaning?


## Output

```python
keep_cols = ['activity_year',
 'lei',
 'derived_msa-md',
 'state_code',
 'county_code',
 'census_tract',
 'conforming_loan_limit',
 'derived_loan_product_type',
 'derived_dwelling_category',
 'action_taken',
 'purchaser_type',
 'preapproval',
 'loan_type',
 'loan_purpose',
 'lien_status',
 'reverse_mortgage',
 'open-end_line_of_credit',
 'business_or_commercial_purpose',
 'loan_amount',
 'loan_to_value_ratio',
 'interest_rate',
 'rate_spread',
 'hoepa_status',
 'total_loan_costs',
 'loan_term',
 'prepayment_penalty_term',
 'intro_rate_period',
 'property_value',
 'construction_method',
 'occupancy_type',
 'total_units',
 'income',
 'debt_to_income_ratio',
 'applicant_credit_score_type',
 'co-applicant_credit_score_type',
 'applicant_ethnicity_observed',
 'co-applicant_ethnicity_observed',
 'applicant_race_observed',
 'co-applicant_race_observed',
 'applicant_sex_observed',
 'co-applicant_sex_observed',
 'applicant_age',
 'co-applicant_age',
 'denial_reason-1',
 'denial_reason-2',
 'denial_reason-3',
 'denial_reason-4',
 'tract_population',
 'tract_minority_population_percent',
 'tract_median_age_of_housing_units',
 'action_taken_clean',
 'loan_type_clean',
 'loan_purpose_clean',
 'hoepa_status_clean',
 'occupancy_type_clean',
 'property_value_clean',
 'loan_to_value_ratio_clean']
```

```python
data_path = os.getcwd().partition("src")[0] + "data/"
accepted_file = data_path + "accepted_loans.csv"
rejected_file = data_path + "rejected_loans.csv"
```

```python
interface.data_cleaned.loc[interface.data_cleaned.action_taken == 1][keep_cols].to_csv(accepted_file, index=False)
```

```python
interface.data_cleaned.loc[interface.data_cleaned.action_taken == 3][keep_cols].to_csv(rejected_file, index=False)
```

```python

```
