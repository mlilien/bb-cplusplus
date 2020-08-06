cmake_minimum_required(VERSION 3.8)

project(cplusplus_service)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)

add_executable(cplusplus_service src/main.cpp)
target_include_directories(cplusplus_service PRIVATE
  ${CONAN_INCLUDE_DIRS_BOOST}
  /source/include
)
target_link_libraries(cplusplus_service
  pthread
)

IF(${CMAKE_BUILD_TYPE} MATCHES Debug)
  set(RELEASE_COMPILE_OPTIONS -O0 -DDEBUG)
else()
  set(RELEASE_COMPILE_OPTIONS -Os -DNDEBUG)
endif()
target_compile_options(cplusplus_service PRIVATE
  ${RELEASE_COMPILE_OPTIONS}
  -D_FORTIFY_SOURCE=2 -Wall -Werror -ggdb -Wextra -fPIE -Wno-unused-parameter -Wformat=2 -Wformat-security -fstack-protector-all -Wstrict-overflow -fno-omit-frame-pointer -fno-common
)
target_link_options(cplusplus_service PRIVATE
  -ggdb -fno-omit-frame-pointer -pie "SHELL:-z noexecstack" "SHELL:-z relro " "SHELL:-z now " "SHELL:-z nodlopen"
)

install(TARGETS cplusplus_service DESTINATION .)

add_executable(cplusplus_service_unit_test unit_test/ut_main.cpp)
target_include_directories(cplusplus_service_unit_test PRIVATE
  /usr/local/include
  /source/include
)
install(TARGETS cplusplus_service_unit_test DESTINATION .)

