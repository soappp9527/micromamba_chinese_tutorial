#! /usr/bin/env bash
# dependencies: conda, mamba, conda-lock, docker
dir=$(pwd)
repository=$1
project=$2
software=$3
version=$4

mkdir -p ${dir}/${software}

# 1. build environment configuration yaml
echo "name: base" > ${dir}/${software}/env.yml
echo "channels:" >> ${dir}/${software}/env.yml
echo "  - bioconda" >> ${dir}/${software}/env.yml
echo "  - conda-forge" >> ${dir}/${software}/env.yml
echo "dependencies:" >> ${dir}/${software}/env.yml
echo "  - ${software}=${version}" >> ${dir}/${software}/env.yml

# 2. build Dockfile
echo "FROM mambaorg/micromamba:bullseye-slim" > ${dir}/${software}/Dockerfile
echo -e "LABEL ${software}=\"${version}\"" >> ${dir}/${software}/Dockerfile
echo "COPY ./conda-linux-64.lock /tmp/conda-linux-64.lock" >> ${dir}/${software}/Dockerfile
echo "RUN micromamba install -y -n base -f /tmp/conda-linux-64.lock && micromamba clean -ay" >> ${dir}/${software}/Dockerfile

# 3. build image build script: generate conda lock file > build image > push image
echo "#! /usr/bin/env bash" > ${dir}/${software}/build.sh
echo "mamba lock -k explicit -p linux-64 -f env.yml --lockfile conda-linux-64.lock" >> ${dir}/${software}/build.sh
echo "docker build . -t ${repository}/${project}/${software}:${version}" >> ${dir}/${software}/build.sh
echo "docker push ${repository}/${project}/${software}:${version}" >> ${dir}/${software}/build.sh

# 4.execute!
cd ${dir}/${software}
bash build.sh