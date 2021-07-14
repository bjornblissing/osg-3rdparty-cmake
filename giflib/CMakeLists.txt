cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

file(READ ${GIFLIB_SOURCE_DIR}/gif_lib.h _gif_lib_h_contents)
string(REGEX REPLACE ".*#define[ \t]+GIFLIB_MAJOR[ \t]+([0-9]+).*" "\\1"
                     GIFLIB_MAJOR_VERSION ${_gif_lib_h_contents})
string(REGEX REPLACE ".*#define[ \t]+GIFLIB_MINOR[ \t]+([0-9]+).*" "\\1"
                     GIFLIB_MINOR_VERSION ${_gif_lib_h_contents})
string(REGEX REPLACE ".*#define[ \t]+GIFLIB_RELEASE[ \t]+([0-9]+).*" "\\1"
                     GIFLIB_RELEASE_VERSION ${_gif_lib_h_contents})
cmake_policy(SET CMP0115 OLD)
project(
  giflib
  VERSION
    "${GIFLIB_MAJOR_VERSION}.${GIFLIB_MINOR_VERSION}.${GIFLIB_RELEASE_VERSION}"
  LANGUAGES C)

# Use GNUInstallDirs to install libraries into correct locations on all
# platforms.
include(GNUInstallDirs)

set(GIFLIB_PUBLIC_HEADERS ${GIFLIB_SOURCE_DIR}/gif_lib.h)

set(GIFLIB_PRIVATE_HEADERS ${GIFLIB_SOURCE_DIR}/gif_lib_private.h
                           ${GIFLIB_SOURCE_DIR}/gif_hash.h)

set(GIFLIB_SRCS
    ${GIFLIB_SOURCE_DIR}/dgif_lib.c
    ${GIFLIB_SOURCE_DIR}/egif_lib.c
    ${GIFLIB_SOURCE_DIR}/gif_err.c
    ${GIFLIB_SOURCE_DIR}/gif_font.c
    ${GIFLIB_SOURCE_DIR}/gif_hash.c
    ${GIFLIB_SOURCE_DIR}/gifalloc.c
    ${GIFLIB_SOURCE_DIR}/quantize.c
    ${GIFLIB_SOURCE_DIR}/openbsd-reallocarray.c)

if(MSVC)
  # Create file to avoid include file name collision on other platforms
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/unistd.h.in unistd.h @ONLY)

  # Add unistd.h, getopt.h, getopt.c and stdbool.h for windows build getopt
  # from: http://gist.github.com/ashelly/7776712 unistd.h from:
  # http://stackoverflow.com/questions/341817/is-there-a-replacement-for-unistd-h-for-windows-visual-c
  # stdbool.h is just a simple redefinition of bool as int
  set(GIFLIB_PUBLIC_HEADERS ${GIFLIB_PUBLIC_HEADERS}
                            ${CMAKE_CURRENT_SOURCE_DIR}/stdbool.h)

  set(GIFLIB_PRIVATE_HEADERS
      ${GIFLIB_PRIVATE_HEADERS} ${CMAKE_CURRENT_SOURCE_DIR}/getopt.h
      ${CMAKE_CURRENT_SOURCE_DIR}/unistd.h)

  set(GIFLIB_SRCS ${GIFLIB_SRCS} ${CMAKE_CURRENT_SOURCE_DIR}/getopt.c)
endif(MSVC)

if(MSVC)
  list(APPEND PRIVATE_DEFINITIONS -D_CRT_SECURE_NO_WARNINGS) # Disable warnings
                                                             # for unsecure CRT
                                                             # functions
  list(APPEND PRIVATE_DEFINITIONS -D_LIB) #
  list(APPEND PRIVATE_DEFINITIONS -DWIN32) #

  # Supress warnings
  list(APPEND PRIVATE_OPTIONS /wd4018) # expression' : signed/unsigned mismatch
  list(APPEND PRIVATE_OPTIONS /wd4028) # formal parameter 'number' different
                                       # from declaration
  list(APPEND PRIVATE_OPTIONS /wd4244) # conversion' conversion from 'type1' to
                                       # 'type2', possible loss of data
  list(APPEND PRIVATE_OPTIONS /wd4996) # The compiler encountered a deprecated
                                       # declaration.

  set(CMAKE_DEBUG_POSTFIX "d")
endif(MSVC)

if(MINGW)
  list(APPEND PRIVATE_DEFINITIONS -D_CRT_SECURE_NO_WARNINGS) # Disable warnings
                                                             # for unsecure CRT
                                                             # functions
  list(APPEND PRIVATE_DEFINITIONS -D_LIB) #
endif(MINGW)

add_library(giflib STATIC ${GIFLIB_SRCS} ${GIFLIB_PUBLIC_HEADERS}
                          ${GIFLIB_PRIVATE_HEADERS})

# Dependent include files
target_include_directories(
  giflib
  PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
         $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
         $<INSTALL_INTERFACE:include>)

target_compile_definitions(giflib PRIVATE ${PRIVATE_DEFINITIONS})

target_compile_options(giflib PRIVATE ${PRIVATE_OPTIONS})

if(MINGW)
  set_target_properties(${TARGET_LIB} PROPERTIES OUTPUT_NAME gif)
endif()

# INSTALL
install(
  TARGETS giflib
  EXPORT giflib_export
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(FILES ${GIFLIB_PUBLIC_HEADERS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
