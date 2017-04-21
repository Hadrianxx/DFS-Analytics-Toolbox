conda update --yes --all
conda create --yes --name jupyter python=3 jupyter
activate jupyter
R -e "IRkernel::installspec()"
jupyter notebook
