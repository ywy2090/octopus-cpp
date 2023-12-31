
# TODO: add global include directories
# include_directories(path/to/include/dir)

include_directories(${THIRD_PARTY_INCLUDE_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src/)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src/libmath/src)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src/libtimewheel/src)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src/logger/src)

# TODO: add global link directories
# link_directories(path/to/library/dir)