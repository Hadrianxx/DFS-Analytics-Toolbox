install.packages(c("devtools", "installr", "stringr"))
devtools::install_github("IRkernel/IRkernel")
library(installr)
install.RStudio()
install.URL("https://cran.rstudio.com/bin/windows/Rtools/Rtools34.exe")
install.URL("https://github.com/git-for-windows/git/releases/download/v2.12.2.windows.2/Git-2.12.2.2-32-bit.exe")
install.URL("https://s3.amazonaws.com/julialang/bin/winnt/x86/0.5/julia-0.5.1-win32.exe")
install.URL("https://repo.continuum.io/miniconda/Miniconda3-latest-Windows-x86.exe")
# capture R path
# capture Julia path
# capture Jupyter path
# capture Conda path
# create environment
# install R and Julia kernels
# fire up a notebook!
