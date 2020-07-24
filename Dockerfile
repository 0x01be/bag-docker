FROM alpine:3.12.0 as builder

RUN apk add --no-cache --virtual build-deprendencies \
    git \
    build-base \
    python3 \
    py3-setuptools\
    py3-pip \
    geos-dev \
    cython

RUN apk add python3-dev
RUN pip install numpy

RUN git clone --depth 1 https://github.com/ucb-art/BAG_framework.git /bag

WORKDIR /bag

RUN python3 setup.py install

FROM alpine:3.12.0

RUN apk add --no-cache --virtual runtime-dependencies \
    python3

COPY --from=builder /usr/lib/python3.8/site-packages/ /usr/lib/python3.8/site-packages/

