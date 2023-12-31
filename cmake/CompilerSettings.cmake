# add_definitions(-Wno-unused-value -Wunused-parameter)

# C++20
set(CMAKE_CXX_STANDARD 20)

# force C++20
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# disable c++ extensions
set(CMAKE_CXX_EXTENSIONS OFF)

# show compiler system information
message(STATUS "COMPILER_ID => ${CMAKE_CXX_COMPILER_ID}")
message(STATUS "CMAKE_SYSTEM_NAME => ${CMAKE_SYSTEM_NAME}")
message(STATUS "CMAKE_SYSTEM_PROCESSOR => ${CMAKE_SYSTEM_PROCESSOR}")

# GUN or Clang
if(("${CMAKE_CXX_COMPILER_ID}" MATCHES "GNU") OR("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang"))
    # compile cache
    find_program(CCACHE_PROGRAM ccache)

    if(CCACHE_PROGRAM)
        set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${CCACHE_PROGRAM}")
        set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK "${CCACHE_PROGRAM}")
    endif()

    # compiler options
    # add_compile_options(-Werror) # TODO: remove for compile asyncio
    add_compile_options(-Wall)
    add_compile_options(-pedantic)
    add_compile_options(-Wextra)
    add_compile_options(-Wno-unused-parameter)
    add_compile_options(-Wno-unused-variable)
    add_compile_options(-Wno-error=unknown-pragmas)
    add_compile_options(-Wno-error=deprecated-declarations)
    add_compile_options(-fno-omit-frame-pointer)

    if(NOT APPLE)
        set(CMAKE_CXX_VISIBILITY_PRESET hidden)
        set(CMAKE_C_VISIBILITY_PRESET hidden)

        # add_compile_options(-fvisibility=hidden)
        # add_compile_options(-fvisibility-inlines-hidden)
        set(CMAKE_C_FLAGS "-pthread")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden -fvisibility-inlines-hidden -pthread")
    endif()

    # static compiler options
    # if(BUILD_STATIC)
    # SET(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
    # SET(BUILD_SHARED_LIBRARIES OFF)
    # SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}")

    # # Note: If bring the -static option, apple will fail to link
    # if(NOT APPLE)
    # SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static")
    # endif()

    # # SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-Bdynamic -ldl -lpthread -Wl,-Bstatic")
    # endif()

    # Configuration-specific compiler settings.
    # for details: cmake --system-information | grep CMAKE_CXX_FLAGS
    # set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g")
    # set(CMAKE_CXX_FLAGS_MINSIZEREL "-Os -DNDEBUG")
    # set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG")
    # set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g -DNDEBUG")
    if("${LINKER}" MATCHES "gold")
        execute_process(COMMAND ${CMAKE_C_COMPILER} -fuse-ld=gold -Wl,--version ERROR_QUIET OUTPUT_VARIABLE LD_VERSION)

        if("${LD_VERSION}" MATCHES "GNU gold")
            set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fuse-ld=gold")
            set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -fuse-ld=gold")
        endif()
    elseif("${LINKER}" MATCHES "mold")
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fuse-ld=mold")
        set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -fuse-ld=mold")
    endif()

    # GNU
    if("${CMAKE_CXX_COMPILER_ID}" MATCHES "GNU")
        # Check that we've got GCC 10.0 or newer.
        # set(GCC_MIN_VERSION "10.0")
        # execute_process(
        # COMMAND ${CMAKE_CXX_COMPILER} -dumpversion OUTPUT_VARIABLE GCC_VERSION)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${MARCH_TYPE}")
        set(CMAKE_C_FLAGS "-std=c99 -fexceptions ${CMAKE_C_FLAGS} ${MARCH_TYPE}")

        add_compile_options(-fstack-protector-strong)
        add_compile_options(-fstack-protector)

        add_compile_options(-fPIC)
        add_compile_options(-Wno-error=nonnull)
        add_compile_options(-foptimize-sibling-calls)
        add_compile_options(-Wno-stringop-overflow)
        add_compile_options(-Wno-restrict)

    # Clang
    elseif("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
        add_compile_options(-fstack-protector)
        add_compile_options(-Winconsistent-missing-override)

        # Some Linux-specific Clang settings.  We don't want these for OS X.
        if("${CMAKE_SYSTEM_NAME}" MATCHES "Linux")
            # Use fancy colors in the compiler diagnostics
            add_compile_options(-fcolor-diagnostics)
        endif()
    endif()

    # memory analysis
    if(SANITIZE_ADDRESS)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ggdb -fno-omit-frame-pointer -fsanitize=address -fsanitize=undefined -fno-sanitize=alignment -fsanitize-address-use-after-scope -fsanitize-recover=all")
    endif()

    if(SANITIZE_THREAD)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ggdb -fno-omit-frame-pointer -fsanitize=thread")
    endif()

# MSVC
elseif("${CMAKE_CXX_COMPILER_ID}" MATCHES "MSVC")
    add_definitions(-DUSE_STD_RANGES)
    add_compile_options(/std:c++latest)
    add_compile_options(-bigobj)

    # MSVC only support static build
    set(CMAKE_CXX_FLAGS_DEBUG "/MTd /DEBUG")
    set(CMAKE_CXX_FLAGS_MINSIZEREL "/MT /Os")
    set(CMAKE_CXX_FLAGS_RELEASE "/MT")
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "/MT /DEBUG")
    link_libraries(ws2_32 Crypt32 userenv)
else()
    message(WARNING "Your compiler is not tested, if you run into any issues, we'd welcome any patches.")
endif()

# memory allocator
# if(ALLOCATOR STREQUAL "tcmalloc")
# # include(FindPkgConfig)
# # pkg_check_modules(tcmalloc REQUIRED libtcmalloc)
# # link_libraries(${tcmalloc_LINK_LIBRARIES})
# elseif(ALLOCATOR STREQUAL "jemalloc")
# find_library(JEMalloc_LIB jemalloc ${VCPKG_INSTALLED_DIR} REQUIRED)
# link_libraries(${JEMalloc_LIB})
# elseif(ALLOCATOR STREQUAL "mimalloc")
# find_package(mimalloc REQUIRED)
# link_libraries(mimalloc)
# endif()

# message("CMAKE_EXE_LINKER_FLAGS: ${CMAKE_EXE_LINKER_FLAGS}")
# message("CMAKE_SHARED_LINKER_FLAGS: ${CMAKE_SHARED_LINKER_FLAGS}")
set(CMAKE_SKIP_INSTALL_ALL_DEPENDENCY ON)
