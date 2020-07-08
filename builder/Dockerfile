
FROM conanio/gcc9-armv8:1.26.1

LABEL maintainer="elbb@conplement.de" 
LABEL description="This is a builder image for C++ components on x86_64 and armv8 architectures" 
LABEL vendor="conplement AG"
LABEL uri="https://github.com/elbb/bb-cplusplus"

USER root

RUN apt-get update &&  \
    apt-get install -y --no-install-recommends \
    apt-utils \
    gosu && \
    apt-get clean

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENV BUILD_DIR=${BUILD_DIR:-/build}
ENV CONAN_USER_HOME=${BUILD_DIR:-/build}
ENV SRC_DIR=${SRC_DIR:-/source}
ENV INSTALL_DIR=${INSTALL_DIR:-/install}

WORKDIR /build

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]