# ψᵟ
#
#

FROM    continuumio/anaconda3

LABEL   maintainer="mdAshford"

# USER    root

RUN apt-get update && apt-get install -y libgtk2.0-dev && \
    rm -rf /var/lib/apt/lists/* && \
    /opt/conda/bin/conda install jupyter -y && \
    # /opt/conda/bin/conda install -c menpo opencv3 -y && \
    /opt/conda/bin/conda install numpy pandas matplotlib h5py pint
    # /opt/conda/bin/conda upgrade dask && \
    # pip install tensorflow imutils

RUN ["mkdir", "notebooks"]

COPY jupyter_notebook_config.py /root/.jupyter/
COPY run_jupyter.sh /

# Jupyter and Tensorboard ports
# EXPOSE 8888 6006
EXPOSE 8888

# Store notebooks in this mounted directory
VOLUME /notebooks

CMD ["/run_jupyter.sh"]
