```python
import pandas as pd
import os
import sys

n_up = os.getcwd().partition("python")[2].count("/")
sys.path.insert(0, os.path.abspath("../"*n_up))

from hdma import HMDALoader

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
hd = HMDALoader(states, years)
```

```python
hd.data.head()
```

```python

```
