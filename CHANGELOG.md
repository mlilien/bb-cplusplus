# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

-  added versioning output for hello world service
-  updated ci pipeline tagging (reintegrated bb-buildingblock)
-  added static code analyse environment(CodeChecker, clang-sa, clang-tidy)
-  default compiler/linker settings for cplusplus_service
-  added doctest and a unit test example
-  added doxygen to generate source code documentation
-  added gdbserver to start debugging the hello world service

## [0.1.0] - 2020-06-08

Initial Version

### Added

-   C++ builder and runtime images for x86_64
-   'hello world' service example
-   concourse environment for ci/cd builds
-   dobi environment for local builds
-   automated versioning with elbb/bb-gitversion 0.5.0
-   integrated bb-buildingblock 0.2.1
