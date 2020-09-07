FROM python:3.7-slim-buster as codecheckerbuilder

ARG CC_VERSION=v6.13.0

ARG DEBIAN_FRONTEND=noninteractive
RUN set -x && apt-get update -qq \
  && apt-get install -qqy --no-install-recommends \
    ca-certificates \
    curl \
    gcc \
    git \
    make \
    python-virtualenv \
    python3-dev \
    python3-pip

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

# Download CodeChecker release.
RUN git clone --branch ${CC_VERSION} https://github.com/Ericsson/CodeChecker.git /codechecker
WORKDIR /codechecker

RUN pip3 install virtualenv

# Create a Python virtualenv and set it as your environment.
RUN bash -c "make venv && source $PWD/venv/bin/activate"

# Build CodeChecker

RUN BUILD_LOGGER_64_BIT_ONLY=YES make -C /codechecker package


###############################################################################
FROM debian:buster-slim

LABEL maintainer="elbb@conplement.de"
LABEL description="This is a builder image for C++ components on x86_64 and armv8 architectures"
LABEL vendor="conplement AG"
LABEL uri="https://github.com/elbb/bb-cplusplus"


COPY --from=codecheckerbuilder /codechecker/build/CodeChecker /codechecker

# Copy python requirements.
COPY --from=codecheckerbuilder /codechecker/web/requirements_py /tmp/requirements_py
COPY --from=codecheckerbuilder /codechecker/web/requirements.txt /tmp/requirements_py

RUN apt-get update &&  \
    apt-get install -y --no-install-recommends \
    apt-utils \
    build-essential \
    clang \
    clang-tidy \
    crossbuild-essential-arm64 \
    cmake \
    gosu \
    python3-dev \
    python3-pip \
    wget \
    doxygen \
    graphviz \
    && \
    apt-get clean
RUN pip3 install setuptools wheel \
    && pip3 install conan \
    && pip3 install -r /tmp/requirements_py/requirements.txt

# install doctest
ARG DOCTEST_VERSION='2.4.0'
ENV DOCTEST_INCLUDE_DIR='/usr/local/include'
RUN wget --no-check-certificate https://raw.githubusercontent.com/onqtam/doctest/${DOCTEST_VERSION}/doctest/doctest.h -O ${DOCTEST_INCLUDE_DIR}/doctest.h


COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY conan.*.profile ./

ENV PATH="/codechecker/bin:$PATH"
ENV BUILD_DIR=${BUILD_DIR:-/build}
ENV CONAN_USER_HOME=${BUILD_DIR:-/build}
ENV SRC_DIR=${SRC_DIR:-/source}
ENV INSTALL_DIR=${INSTALL_DIR:-/install}

WORKDIR /build

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
