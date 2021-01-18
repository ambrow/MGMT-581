import pandas as pd
import numpy as np
from typing import List


class HMDALoader:
    def __init__(self, states: List[str], years: List[str] = ["2018"]):
        """load data from the cfpb data browser api

        Parameters
        ----------
        states : List[str], optional
            List of states to query
        years : List[str], optional
            List of years to query, by default ["2018"]
        Notes
        -----
        years 2018 and 2019 appear to be working, but 2017 causes problems

        References
        ----------
        https://cfpb.github.io/hmda-platform/#data-browser-api-csv-example

        """
        self.states_string = ",".join([str(elem) for elem in states])
        self.years = years
        self.base = "https://ffiec.cfpb.gov/v2/data-browser-api/view/csv"

    def load(self):

        df_list = []
        for year in self.years:
            url = f"{self.base}?states={self.states_string}&years={str(year)}"
            df = pd.read_csv(url)
            df_list.append(df)

        return pd.concat(df_list)


class HMDACleaner:
    def __init__(self, steps: List[str]):
        self.steps = steps

    def clean_action_taken(self, df: pd.DataFrame):
        clean_df = df.loc[df.action_taken.isin([1, 3]), :].copy()
        replacements = {1: "loan-approved", 3: "loan-rejected"}
        clean_df["action_taken_clean"] = clean_df.action_taken.replace(replacements)

        return clean_df

    def clean_loan_type(self, df: pd.DataFrame):
        clean_df = df.copy()
        replacements = {1: "Conventional", 2: "FHA", 3: "VA", 4: "USDA-or-RHS"}
        clean_df["loan_type_clean"] = df.loan_type.replace(replacements)

        return clean_df

    def clean_loan_purpose(self, df: pd.DataFrame):
        clean_df = df.copy()
        replacements = {
            1: "purchase",
            2: "improvement",
            31: "refinance",
            32: "cash-out-refi",
            4: "other",
            5: "N/A",
        }
        clean_df["loan_purpose_clean"] = df.loan_purpose.replace(replacements)

        return clean_df

    def clean_hoepa(self, df: pd.DataFrame):
        clean_df = df.copy()
        replacements = {1: "high-cost", 2: "not-high-cost", 3: "N/A"}
        clean_df["hoepa_status_clean"] = df.hoepa_status.replace(replacements)

        return clean_df

    def clean_occupancy(self, df: pd.DataFrame):
        clean_df = df.copy()
        replacements = {1: "principal", 2: "second", 3: "investment"}
        clean_df["occupancy_type_clean"] = df.occupancy_type.replace(replacements)

        return clean_df

    def clean_loan_to_value_ratio(self, df: pd.DataFrame):
        clean_df = df.copy()
        replacements = {"Exempt": np.nan}
        clean_df["loan_to_value_ratio_clean"] = df.loan_to_value_ratio.replace(
            replacements
        ).astype("float")
        return clean_df

    def clean_property_value(self, df: pd.DataFrame):
        clean_df = df.copy()
        replacements = {"Exempt": np.nan}
        clean_df["property_value_clean"] = df.property_value.replace(
            replacements
        ).astype("float")
        return clean_df

    def clean(self, df: pd.DataFrame):
        for step in self.steps:
            if hasattr(self, f"clean_{step}"):
                df = getattr(self, f"clean_{step}")(df)

        return df


class HMDAInterface:
    def __init__(self, states: List[str] = ["DC", "VA"], years: List[str] = ["2018"]):
        self.loader = HMDALoader(states, years)

    def load(self):
        self.data = self.loader.load()

    def clean(self, steps: List[str]):
        self.cleaner = HMDACleaner(steps)
        self.data_cleaned = self.cleaner.clean(self.data)
