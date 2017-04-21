# Jupyter Plus RStudio on Windows

## Goal
* On a Windows 7+ system, a desktop with Git, R, RStudio, and Jupyter
* Jupyter kernels for Python 3, R and Julia,
* ***RStudio and Jupyter share the same R executable, system and user libraries***
* RStudio notebook / Jupyter notebook conversion both ways
* R Markdown / knitr documents can mix R, Python 3 and Julia code

* Non-goal: No LaTeX / PDFs ... MikTeX is way overkill for the kinds of documents I'm talking about here.
* Non-goal: No Docker!!!

## Implementation
1. Install R, RStudio and Git for Windows.
2. Start RStudio and point it to R and Git. RStudio should find Git by itself, but you'll have to tell it which R executable to use if you have more than one.
