# INTRO

This notebook will walk you through the basics of the dataset we will be using in class. I've pulled this data from kaggle, so you can find more about it [here](https://www.kaggle.com/usdot/flight-delays)


## Imports

```python
import pandas as pd
import os
import matplotlib.pyplot as plt
import seaborn as sns

# Changing Pandas options
pd.options.display.max_rows = 999
pd.options.display.max_columns = 999
pd.set_option('display.float_format', lambda x: '%.5f' % x)
```

## Load Data

```python
data_path = os.getcwd().partition("src")[0] + 'data/'
```

### Airlines

```python
airlines_df = pd.read_csv(data_path + "airlines.csv")
airlines_df
```

```python
airlines_df.shape
```

**Airlines data notes**
- 14 airlines registered in 2015


### Airports

```python
airports_df = pd.read_csv(data_path + "airports.csv")
airports_df.head()
```

```python
airports_df.shape
```

```python
fig, ax = plt.subplots(figsize=(20,12))
sns.scatterplot(data=airports_df, x='LATITUDE', y='LONGITUDE')
```

```python
airports_df.loc[airports_df.LONGITUDE < -140]
```

**Airports data notes**
- 322 airports registered in 2015
- latitude and longitude need to be reflected for a map to make sense in python


### Flights

```python
flights_df = pd.read_csv(data_path + "flights.csv")
flights_df.head()
```

```python
flights_df.shape
```

```python
flights_df.ORIGIN_AIRPORT.value_counts().head(50)
```

```python
flights_df.loc[flights_df.ORIGIN_AIRPORT == '10397']
```

```python
'10397' in airports_df.IATA_CODE.tolist()
```

```python
flights_df.AIRLINE.value_counts()
```

**Flights data notes**
- 5.8 M flights registered in 2015
- top airports make sense (ATL, ORD, DFW, LAX, SFO)
- Southwest is top airline in terms of flights registered
- some weird airline codes showing up

```python

```
