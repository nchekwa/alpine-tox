FROM alpine:3.18.4



WORKDIR /tmp

ENV PIP_BREAK_SYSTEM_PACKAGES=1

RUN apk --update --no-cache add \
        python3 py3-cryptography py3-openssl py3-pip py3-yaml py3-aiohttp py3-pymysql py3-mysqlclient py3-cffi \
        build-base libffi-dev zlib-dev libressl-dev bzip2-dev readline-dev sqlite-dev bash


ARG PYTHON_VERSIONS="3.6.15 3.7.17 3.8.18 3.9.18 3.10.13 3.11.6 3.12.0 3.13.0"


RUN for version in $PYTHON_VERSIONS; do \
                wget https://www.python.org/ftp/python/${version}/Python-${version}.tar.xz && \
                tar -xf Python-${version}.tar.xz && \
                cd Python-${version} && \
                ./configure --enable-optimizations --prefix=/usr/local && \
                make -j$(nproc) && \
                make install && \
                cd .. && \
        rm -rf Python-${version} Python-${version}.tar.xz; \
    done

RUN pip3 install tox flake8

RUN rm -rf /var/cache/apk/* \
    && find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
    && find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf \
    rm -fR /tmp/*


CMD ["python3"]
