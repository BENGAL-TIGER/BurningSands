# ψᵟ
#
#

FROM    continuumio/anaconda3

LABEL   maintainer="mdAshford"

USER    root

# create a new user
ARG     NB_USER="marcvs"
ARG     NB_UID="1000"
ARG     NB_GID="100"

# Configure environment
ENV     CONDA_DIR=/opt/conda \
        SHELL=/bin/bash \
        NB_USER=$NB_USER \
        NB_UID=$NB_UID \
        NB_GID=$NB_GID \
        LC_ALL=en_US.UTF-8 \
        LANG=en_US.UTF-8 \
        LANGUAGE=en_US.UTF-8
ENV     PATH=$CONDA_DIR/bin:$PATH \
        HOME=/home/$NB_USER

RUN        useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
        chown $NB_USER:$NB_GID $CONDA_DIR && \
        chmod g+w /etc/passwd

# build and activate the specified conda environment from a file (defaults to 'environment.yml')
#ARG environment=environment.yml
#COPY ${environment} .
#RUN conda env create --file ${environment} && \
#    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
#    echo "conda activate $(head -1 ${environment} | cut -d' ' -f2)" >> ~/.bashrc

#RUN     conda update conda && \
#        pip install --upgrade pip && \
#        conda create -n sands python=3.7 && \
#        source activate sands && \
#        conda install -c conda-forge jupyterlab && \
#s        pip install sos sos-notebook

RUN     $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
        $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
        $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
        $CONDA_DIR/bin/conda install --quiet --yes conda="${MINICONDA_VERSION%.*}.*" && \
        $CONDA_DIR/bin/conda update --all --quiet --yes && \
        conda clean -tipsy && \
        rm -rf /home/$NB_USER/.cache/yarn


# Install Tini
RUN     conda install --quiet --yes 'tini=0.18.0' && \
        conda list tini | grep tini | tr -s ' ' | cut -d ' ' -f 1,2 >> $CONDA_DIR/conda-meta/pinned && \
        conda clean -tipsy

# Install Jupyter Notebook, Lab, and Hub
# Generate a notebook server config
# Cleanup temporary files
# Correct permissions
# Do all this in a single RUN command to avoid duplicating all of the
# files across image layers when the permissions change
RUN     conda install --quiet --yes \
        'notebook=5.7.2' \
        'jupyterhub=0.9.4' \
        'jupyterlab=0.35.4' && \
         conda clean -tipsy && \
         jupyter labextension install @jupyterlab/hub-extension@^0.12.0 && \
         npm cache clean --force && \
         jupyter notebook --generate-config
