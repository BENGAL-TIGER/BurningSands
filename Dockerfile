# ψᵟ
#
#

FROM continuumio/anaconda3

LABEL maintainer="mdAshford"

USER root

RUN     conda update conda && \
        pip install --upgrade pip && \
        conda create -n sands python=3.7 && \
        source activate sands && \
        python --version && \
        conda install -c conda-forge jupyterlab && \
        pip install sos sos-notebook
