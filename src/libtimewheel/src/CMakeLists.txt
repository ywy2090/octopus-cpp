cmake_minimum_required(VERSION 3.14)

# wildcard
# file(GLOB SRCS *.cpp)
file(GLOB_RECURSE SRCS *.cpp)

set(TIME_WHEEL_TARGET timewheel)

add_library(${TIME_WHEEL_TARGET} ${SRCS})
# target_include_directories(${TIME_WHEEL_TARGET} PUBLIC .)
# target_link_libraries(${TIME_WHEEL_TARGET} PUBLIC jsoncpp_static OpenSSL::SSL OpenSSL::Crypto)

# install library
# install(TARGETS ${TIME_WHEEL_TARGET} EXPORT mathTargets ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}")
install(TARGETS ${TIME_WHEEL_TARGET} ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}")
# install head files
install(DIRECTORY ${TIME_WHEEL_TARGET} DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/" FILES_MATCHING PATTERN "*.h")