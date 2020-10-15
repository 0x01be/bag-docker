FROM alpine as build

RUN apk add --no-cache --virtual bag-build-dependencies \
    git \
    build-base \
    python3 \
    py3-setuptools \
    py3-wheel \
    py3-pip \
    py3-numpy \
    geos-dev \
    cython \
    python3-dev \
    pkgconfig \
    hdf5-dev \
    cmake \
    freetype-dev \
    libressl-dev \
    linux-headers

RUN git clone --depth 1 https://github.com/scikit-build/cmake-python-distributions /skbuild

RUN mkdir -p /skbuild/build
WORKDIR /skbuild/build

RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/skbuild \
    ..
RUN make
RUN make install

ENV LD_LIBRARY_PATH /usr/lib:/opt/skbuild/lib/
ENV C_INCLUDE_PATH /usr/include/:/opt/skbuild/include/
ENV PYTHONPATH /usr/lib/python3.8/site-packages/:/opt/skbuild/lib/python3.8/site-packages/
ENV PATH ${PATH}:/opt/skbuild/bin/

RUN pip install --prefix=/opt/bag \
    scikit-build \
    pkgconfig \
    freetype-py

RUN git clone --depth 1 https://github.com/libspatialindex/libspatialindex /libspatialindex

RUN mkdir -p /libspatialindex/build
WORKDIR /libspatialindex/build

RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/libspatialindex \
    ..
RUN make
RUN make install

RUN git clone --depth 1 https://github.com/ucb-art/BAG_framework.git /bag

WORKDIR /bag

ENV LD_LIBRARY_PATH /usr/lib:/opt/libspatialindex/lib/
ENV C_INCLUDE_PATH /usr/include/:/opt/libspatialindex/include/
ENV PYTHONPATH /usr/lib/python3.8/site-packages/:/opt/bag/lib/python3.8/site-packages/

RUN python3 setup.py install --prefix=/opt/bag

