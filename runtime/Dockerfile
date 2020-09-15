ARG ARCH
FROM ${ARCH}/debian:buster-slim
LABEL maintainer="elbb@conplement.de"
LABEL description="This is a runtime image for C++ components on ${ARCH} architecture"
LABEL vendor="conplement AG"
LABEL uri="https://github.com/elbb/bb-cplusplus"

ARG DEV
RUN if [ "${DEV}" = "1" ]; then export DEV_PACKAGES="gdbserver"; fi; \
    apt-get update &&  \
    apt-get install -y --no-install-recommends \
    gosu \
    ${DEV_PACKAGES} && \
    apt-get clean

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

RUN useradd -m user
USER user
ENV HOME=/home/user
WORKDIR ${HOME}
