# 2015 US Flights
The DOT maintains information on flight delays all across the country. Click [here](https://www.kaggle.com/usdot/flight-delays) for more info on the data.

## Intended Usage
We will use this repository to answer 3 overarching questions:

1. Can we predict how much time a flight's arrival will be delayed?
2. Can we reliably predict whether a flight will be delayed at all?
3. Do the observed patterns related to time or delay differ based on where the flight is departing from?

Along the way, we will walk through a number of topics within data-driven decision making that are critical to understand for any data scientist, business analyst, or corporate strategist. A few are listed below:

- Defining the business problem
- Translating that problem to an Analytics problem that can be solved with data
- Data Exploration and Visualization
- Common Data Errors (and how to fix them)
- Feature Engineering
- Building a predictive model
- Investigating (potential) unsupervised solutions to a problem
- Communicating results to technical and non-technical stakeholders

## Quick Start

This repository contains code in both R and Python. Below you will see sections for each. However, before you do anything, you will need to follow the instructions in the root directory to make sure you have R and/or Python installed on your local machine.

### Python Quick Start
Below you will see what to do to access this code using python on your own machine.
1. Open an Anaconda prompt (Windows) or Terminal (Mac) and locate the HMDA directory
```
cd path/to/this/directory/flights
```
2. Use conda to create a virtual environment for this project (this ensures reproducibility across different computers / end users) 
```
conda env create -f environment.yml
```
3. Activate the environment
```
conda activate flights
```
4. Build jupyter lab (if you haven't already in this environment)
```
jupyter lab build
```
5. Navigate to the Notebooks folder
```
cd src/python/notebooks
```
6. Open jupyter lab
```
jupyter lab
```
7. Run the code (and write your own!). To open notebooks, just right click and select open with notebook and you can run it like any other python code right in your browser!

### R Quick Start
1. Open Rstudio from the directory you wish this to be in locally
2. Run `00-1-initialize_env.R` to create the renv and Rproject files for reproducibility
3. Run `00-2-install_packages.R` to install the packages you will need for this project's code
4. Run the code (and write your own!)

## Credits
### Lead Dev
- Alec Brown

### Support
- Dr. Dasmohapatra
- TA to be named later
