cmake_minimum_required(VERSION 3.8)

project(cplusplus_service)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)

add_executable(cplusplus_service src/main.cpp)
target_include_directories(cplusplus_service PUBLIC
  ${CONAN_INCLUDE_DIRS_BOOST}
)
target_link_libraries(cplusplus_service
  pthread
)

install(TARGETS cplusplus_service DESTINATION .)
