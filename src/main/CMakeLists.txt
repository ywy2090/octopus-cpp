cmake_minimum_required(VERSION 3.14)

# file(GLOB SRCS *.cpp) # wildcard all x.cpp files of the current dir
file(GLOB_RECURSE SRCS *.cpp) # recurse wildcard all x.cpp files of the current dir

# find_package
find_package(fmt CONFIG REQUIRED)

# executable file
add_executable(${PROJECT_NAME} ${SRCS})

# add_compile_definitions
add_compile_definitions(SPDLOG_ACTIVE_LEVEL=SPDLOG_LEVEL_TRACE)

# link libraris for main excutable
target_link_libraries(${PROJECT_NAME} PRIVATE ${LOGGER_TARGET} nlohmann::json fmt::fmt)
