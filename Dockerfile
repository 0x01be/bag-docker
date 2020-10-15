FROM 0x01be/libspatialindex:build as libspatialindex

FROM alpine as build

RUN apk add --no-cache --virtual bag-build-dependencies \
    git \
    build-base \
    python3-dev \
    py3-setuptools \
    py3-wheel \
    py3-pip \
    geos-dev \
    cython \
    pkgconfig \
    hdf5-dev \
    freetype-dev

RUN apk add --no-cache --virtual bag-runtime-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    py3-numpy-dev

COPY --from=libspatialindex /opt/libspatialindex/ /opt/libspatialindex/

ENV LD_LIBRARY_PATH /usr/lib:/opt/libspatialindex/lib/
ENV C_INCLUDE_PATH /usr/include/:/opt/libspatialindex/include/:/usr/lib/python3.8/site-packages/numpy/core/include/

RUN pip install --no-deps scikit-build --prefix=/opt/bag

ENV PYTHONPATH /usr/lib/python3.8/site-packages/:/opt/bag/lib/python3.8/site-packages/

ENV BAG_REVISION master
RUN git clone --depth 1 --branch ${BAG_REVISION} https://github.com/ucb-art/BAG_framework.git /bag

WORKDIR /bag

RUN python3 setup.py install --prefix=/opt/bag

