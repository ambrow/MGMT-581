import pandas as pd
from typing import List


class HMDALoader:
    def __init__(self, states: List = ["DC", "VA"], years: List = ["2018"]):
        """load data from the cfpb data browser api

        Parameters
        ----------
        states : List, optional
            [description], by default ["DC", "VA", "MD"]
        years : List, optional
            [description], by default ["2018"]
        Notes
        -----
        years 2018 and 2019 appear to be working, but 2017 causes problems

        References
        ----------
        https://cfpb.github.io/hmda-platform/#data-browser-api-csv-example

        """
        states_string = ",".join([str(elem) for elem in states])

        for year in years:
            base = "https://ffiec.cfpb.gov/v2/data-browser-api/view/csv"
            url = f"{base}?states={states_string}&years={str(year)}"
            df = pd.read_csv(url)
            if hasattr(self, "data"):
                pd.concat([self.data, df])
            else:
                self.data = df
