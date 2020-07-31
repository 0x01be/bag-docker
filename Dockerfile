FROM alpine:3.12.0 as builder

RUN apk add --no-cache --virtual build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    git \
    build-base \
    python3 \
    py3-setuptools\
    py3-pip \
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

RUN cmake ..
RUN make install

RUN pip install \
    numpy \
    pkgconfig \
    freetype-py

RUN git clone --depth 1 https://github.com/libspatialindex/libspatialindex /libspatialindex

RUN mkdir -p /libspatialindex/build
WORKDIR /libspatialindex/build

RUN cmake ..
RUN make install

RUN git clone --depth 1 https://github.com/ucb-art/BAG_framework.git /bag

WORKDIR /bag

RUN python3 setup.py install

FROM alpine:3.12.0

RUN apk add --no-cache --virtual runtime-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    python3

COPY --from=builder /usr/lib/python3.8/site-packages/ /usr/lib/python3.8/site-packages/

