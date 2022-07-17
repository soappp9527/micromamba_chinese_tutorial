FROM mambaorg/micromamba:bullseye-slim
COPY ./conda-linux-64.lock /tmp/conda-linux-64.lock
RUN micromamba install -y -n base -f /tmp/conda-linux-64.lock && micromamba clean -ay
