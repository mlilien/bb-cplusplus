cmake_minimum_required(VERSION 3.8)

project(hello_world)

include_directories($ENV{ELBB_HEADER_PATH})
add_executable(hello_world src/main.cpp)
install(TARGETS hello_world DESTINATION .)
