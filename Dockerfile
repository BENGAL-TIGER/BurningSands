# ψᵟ
#
#

FROM continuumio/anaconda3

LABEL maintainer="mdAshford"

USER root

RUN     source activate sands && \
        conda install -c conda-forge jupyterlab && \
