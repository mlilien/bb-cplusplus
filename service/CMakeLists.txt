cmake_minimum_required(VERSION 3.8)

project(cplusplus_service)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(cplusplus_service src/main.cpp)
install(TARGETS cplusplus_service DESTINATION .)
