cmake_minimum_required(VERSION 3.8)

project(hello_world)

get_filename_component(version_file_path "$ENV{VERSION_HEADER}" DIRECTORY)
include_directories(${version_file_path})
add_executable(hello_world src/main.cpp $ENV{VERSION_HEADER})
install(TARGETS hello_world DESTINATION .)
