cmake_minimum_required(VERSION 3.8)

project(cplusplus_service)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)

add_executable(cplusplus_service src/main.cpp)
target_include_directories(cplusplus_service PRIVATE
  ${CONAN_INCLUDE_DIRS_BOOST}
  /usr/local/include
)
target_link_libraries(cplusplus_service
  pthread
)
install(TARGETS cplusplus_service DESTINATION .)

add_executable(cplusplus_service_unit_test unit_test/hello_world.cpp)
target_include_directories(cplusplus_service_unit_test PRIVATE
  /usr/local/include
)
install(TARGETS cplusplus_service_unit_test DESTINATION .)

