# Set build platform; to be written to BuildInfo.h

set(PROJECT_BUILD_OS "${CMAKE_SYSTEM_NAME}")

if(CMAKE_COMPILER_IS_MINGW)
    set(PROJECT_BUILD_COMPILER "mingw")
elseif(CMAKE_COMPILER_IS_MSYS)
    set(PROJECT_BUILD_COMPILER "msys")
elseif(CMAKE_COMPILER_IS_GNUCXX)
    set(PROJECT_BUILD_COMPILER "g++")
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(PROJECT_BUILD_COMPILER "clang")
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "AppleClang")
    set(PROJECT_BUILD_COMPILER "appleclang")
else()
    set(PROJECT_BUILD_COMPILER "unknown")
endif()

set(PROJECT_BUILD_PLATFORM "${PROJECT_BUILD_OS}/${PROJECT_BUILD_COMPILER}")

if(CMAKE_BUILD_TYPE)
    set(PROJECT_BUILD_TYPE ${CMAKE_BUILD_TYPE})
else()
    set(PROJECT_BUILD_TYPE "${CMAKE_CFG_INTDIR}")
endif()

if(NOT PROJECT_BUILD_TYPE)
    set(PROJECT_BUILD_TYPE "unknown")
endif()

execute_process(
    COMMAND git --git-dir=${PROJECT_SOURCE_DIR}/.git --work-tree=${PROJECT_SOURCE_DIR} rev-parse HEAD
    OUTPUT_VARIABLE PROJECT_COMMIT_HASH OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_QUIET
)

if(NOT PROJECT_COMMIT_HASH)
    set(PROJECT_COMMIT_HASH 0)
endif()

execute_process(
    COMMAND git --git-dir=${PROJECT_SOURCE_DIR}/.git --work-tree=${PROJECT_SOURCE_DIR} diff HEAD --shortstat
    OUTPUT_VARIABLE PROJECT_LOCAL_CHANGES OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_QUIET
)

execute_process(
    COMMAND date "+%Y%m%d %H:%M:%S"
    OUTPUT_VARIABLE PROJECT_BUILD_TIME OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_QUIET
)

execute_process(
    COMMAND git rev-parse --abbrev-ref HEAD
    OUTPUT_VARIABLE PROJECT_BUILD_BRANCH OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_QUIET
)

# set(DPROJECT_BUILDINFO_IN "${CMAKE_SOURCE_DIR}/cmake/templates/BuildInfo.h.in")
# set(OUTFILE "${PROJECT_BINARY_DIR}/BuildInfo.h")

# message(STATUS " => DPROJECT_BUILDINFO_IN => ${DPROJECT_BUILDINFO_IN}")
# message(STATUS " => OUTFILE => ${OUTFILE}")
configure_file("${CMAKE_SOURCE_DIR}/cmake/templates/BuildInfo.h.in" "${PROJECT_BINARY_DIR}/include/BuildInfo.h")
include_directories(BEFORE "${PROJECT_BINARY_DIR}/include")
