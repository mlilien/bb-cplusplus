FROM debian:10.4-slim

LABEL maintainer="elbb@conplement.de"
LABEL description="This is a builder image for C++ components on x86_64 and armv8 architectures"
LABEL vendor="conplement AG"
LABEL uri="https://github.com/elbb/bb-cplusplus"

RUN apt-get update &&  \
    apt-get install -y --no-install-recommends \
    apt-utils \
    build-essential \
    crossbuild-essential-arm64 \
    cmake \
    gosu \
    python3-pip \
    && \
    apt-get clean
RUN pip3 install setuptools wheel
RUN pip3 install conan

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY conan.armv8.profile .

ENV BUILD_DIR=${BUILD_DIR:-/build}
ENV CONAN_USER_HOME=${BUILD_DIR:-/build}
ENV SRC_DIR=${SRC_DIR:-/source}
ENV INSTALL_DIR=${INSTALL_DIR:-/install}

WORKDIR /build

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
