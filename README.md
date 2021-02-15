# Welcome
Greetings! Welcome to the Github repository for MGMT 581 at the McDonough School of Business. This will contain all code samples walked through in class, as well as specific code for each of the datasets you and your team members will be working with. 

## Getting Started
In order to work with this repository locally, you will need to make sure you've done a few things on your machine first.

1. Install Python and/or R on your computer
[R](https://cran.r-project.org/mirrors.html) - Choose your R mirror (any US university will work)
[Rstudio](https://rstudio.com/products/rstudio/download/) - Get the free RStudio desktop
[Python](https://conda.io/) - Installs python 3 and miniconda and adds both to PATH
2. Create an SSH key for your [github account](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/connecting-to-github-with-ssh)
3. Activate your ssh key locally
```
ssh-add path/to/your/key
```
4. Add [git](https://git-scm.com/downloads) to your local machine
5. Navigate to the folder you want to code to be in locally in either anaconda prompt (Windows) or terminal (Mac)
```
cd path/to/your/local/folder
```
6. Run the following command to clone the repository and access it locally
```
git clone git@github.com:ambrow/MGMT-581.git
```
7. Create your own branch to store your local changes
```
git checkout -b name-of-your-branch
```
8. If using Python, test out the code to see if it is working correctly
```
cd flights
pytest tests/unit/test_hello_world.py -s
```
If your terminal returns "Hello MGMT-581!" you have done everything correctly