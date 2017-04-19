# Jupyter Plus RStudio on Windows

## Goal
On a Windows 7+ system, a command script that
1. Installs Julia from upstream binary,
2. Uses Julia to install (Python 2) Miniconda,
3. Creates a Conda environment with Jupyter / Julia, Python 2 and R kernels,
4. Installs RStudio desktop for Windows and points it at the R executable in the Jupyter environment,
5. Provides a translator from RStudio notebooks to Jupyter notebooks and vice versa, and
6. Allows mixing Julia, Python and R in both kinds of notebooks.

* Non-goal: No LaTeX / PDFs ... MikTeX is way overkill for the kinds of documents I'm talking about here.
* Non-goal: No Docker!!!

