FROM jlesage/baseimage-gui:ubuntu-22.04-v4.5.2 AS build

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Europe/Berlin
ENV QT_XCB_NO_MITSHM=1 
ENV NVIDIA_VISIBLE_DEVICES "all",
ENV NVIDIA_DRIVER_CAPABILITIES "compute,utility"

RUN apt-get update -y && apt-get install -qqy build-essential 

RUN apt-get install -qqy wget mesa-utils \
                         libgl1-mesa-glx \
                         libglib2.0-0 \
                         libfontconfig1 \
                         libxrender1 \
                         libdbus-1-3 \
                         libxkbcommon-x11-0 \
                         libxi6 \
                         libxcb-icccm4 \
                         libxcb-image0 \
                         libxcb-keysyms1 \
                         libxcb-randr0 \
                         libxcb-render-util0 \
                         libxcb-xinerama0 \
                         libxcb-xinput0 \
                         libxcb-xfixes0 \
                         libxcb-shape0 \
                         fonts-dejavu \
                         libarchive-dev \
                         fontconfig

WORKDIR /tmp
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 

ENV CONDA_BIN_PATH="/opt/conda/bin"
ENV PATH $CONDA_BIN_PATH:$PATH

RUN conda install mamba -n base -c conda-forge 

RUN conda create --yes --name napari python=3.10 
RUN  mamba install -c conda-forge -n napari napari pyqt napari-ome-zarr && \
  mamba update -y -n napari napari 

EXPOSE 5800

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

ENV APP_NAME="Napari"

ENV KEEP_APP_RUNNING=0

ENV TAKE_CONFIG_OWNERSHIP=1


WORKDIR /config