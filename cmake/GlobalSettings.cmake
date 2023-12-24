# set global variables
set(MATH_TARGET "math")
set(LOGGER_TARGET "logger")

set(LIB_SPDLOG_TARGET "libspdlog")
set(LIB_CONCURRENTQUQUE_TARGET "libconcurrentqueue")
set(LIB_RWQUQUE_TARGET "librwqueue")

# message(STATUS "CMAKE_SOURCE_DIR => ${CMAKE_SOURCE_DIR}")
# message(STATUS "CMAKE_BINARY_DIR => ${CMAKE_BINARY_DIR}")

# third party include dir && library dir
set(THIRD_PARTY_DIR ${CMAKE_BINARY_DIR}/third_party/)
set(THIRD_PARTY_LIBS_DIR ${THIRD_PARTY_DIR}/lib/)
set(THIRD_PARTY_INCLUDE_DIR ${THIRD_PARTY_DIR}/include/)