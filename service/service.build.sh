#!/bin/bash
echo ARCH=${ARCH}
if [ ! "${BB_GITVERSION_INCLUDE_DIR:0:1}" = "/" ]; then BB_GITVERSION_INCLUDE_DIR=$(pwd)/${BB_GITVERSION_INCLUDE_DIR}; fi
echo BB_GITVERSION_INCLUDE_DIR=${BB_GITVERSION_INCLUDE_DIR}
if [ ! "${BUILD_DIR:0:1}" = "/" ]; then BUILD_DIR=$(pwd)/${BUILD_DIR}; fi
echo BUILD_DIR=${BUILD_DIR}
echo CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
export CONAN_CPU_COUNT=$(nproc --all)
echo CONAN_CPU_COUNT=${CONAN_CPU_COUNT}
echo CONAN_REMOTE=${CONAN_REMOTE}
echo CONAN_SSL_VERIFICATION=${CONAN_SSL_VERIFICATION}
if [ ! "${CONAN_USER_HOME:0:1}" = "/" ]; then CONAN_USER_HOME=$(pwd)/${CONAN_USER_HOME}; fi
echo CONAN_USER_HOME=${CONAN_USER_HOME}
if [ ! "${INSTALL_DIR:0:1}" = "/" ]; then INSTALL_DIR=$(pwd)/${INSTALL_DIR}; fi
echo INSTALL_DIR=${INSTALL_DIR}
if [ ! "${SOURCE_DIR:0:1}" = "/" ]; then SOURCE_DIR=$(pwd)/${SOURCE_DIR}; fi
echo SOURCE_DIR=${SOURCE_DIR}

if [ -z ${CONAN_REMOTE} ]; then CONAN_REMOTE=http://artifactory-cpp-ce:8082/artifactory/api/conan/conan-local; fi
conan remote add conan-local ${CONAN_REMOTE} ${CONAN_SSL_VERIFICATION} -f

if [ "${ARCH}" = armv7hf ]; then
    CMAKE_CXX_COMPILER=/usr/bin/arm-linux-gnueabihf-g++
    STRIP_CMD=/usr/bin/arm-linux-gnueabihf-strip
else
    CMAKE_CXX_COMPILER=/usr/bin/${ARCH}-linux-gnu-g++
    STRIP_CMD=${ARCH}-linux-gnu-strip
fi

mkdir -p ${BUILD_DIR} \
&& cd ${BUILD_DIR} \
&& ( conan install ${SOURCE_DIR} --profile=/conan.${ARCH}.profile --build missing -r conan-local || (conan install ${SOURCE_DIR} --profile=/conan.${ARCH}.profile --build missing ) \
&& conan upload "*" -r conan-local --all -c; )

cmake ${SOURCE_DIR} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}  \
&& make -j${CONAN_CPU_COUNT} \
&& if [ ${CMAKE_BUILD_TYPE,,} == "release" ]; then ${STRIP_CMD} cplusplus_service; fi \
&& make install;
