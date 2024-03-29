cmake_minimum_required(VERSION 3.5 FATAL_ERROR)
file(STRINGS "${FREETYPE_SOURCE_DIR}/include/freetype/freetype.h"
     FREETYPE_VERSION_FILE_CONTENTS REGEX "#define FREETYPE_[A-Z]+[ \t]+[0-9]+")

string(REGEX REPLACE ".*#define FREETYPE_MAJOR[ \t]+([0-9]+).*" "\\1"
                     FREETYPE_VERSION_MAJOR ${FREETYPE_VERSION_FILE_CONTENTS})
string(REGEX REPLACE ".*#define FREETYPE_MINOR[ \t]+([0-9]+).*" "\\1"
                     FREETYPE_VERSION_MINOR ${FREETYPE_VERSION_FILE_CONTENTS})
string(REGEX REPLACE ".*#define FREETYPE_PATCH[ \t]+([0-9]+).*" "\\1"
                     FREETYPE_VERSION_PATCH ${FREETYPE_VERSION_FILE_CONTENTS})

project(
  freetype
  VERSION
    "${FREETYPE_VERSION_MAJOR}.${FREETYPE_VERSION_MINOR}.${FREETYPE_VERSION_PATCH}"
  LANGUAGES C)

# Use GNUInstallDirs to install libraries into correct locations on all
# platforms.
include(GNUInstallDirs)

set(PUBLIC_FT2BUILD_H "${FREETYPE_SOURCE_DIR}/include/ft2build.h")

set(FREETYPE_BASE_SRCS
    ${FREETYPE_SOURCE_DIR}/src/autofit/autofit.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftbase.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftbbox.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftbdf.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftbitmap.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftcid.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftfstype.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftgasp.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftglyph.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftgxval.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftinit.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftmm.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftotval.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftpatent.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftpfr.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftstroke.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftsynth.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftsystem.c
    ${FREETYPE_SOURCE_DIR}/src/base/fttype1.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftwinfnt.c
    ${FREETYPE_SOURCE_DIR}/src/bdf/bdf.c
    ${FREETYPE_SOURCE_DIR}/src/bzip2/ftbzip2.c
    ${FREETYPE_SOURCE_DIR}/src/cache/ftcache.c
    ${FREETYPE_SOURCE_DIR}/src/cff/cff.c
    ${FREETYPE_SOURCE_DIR}/src/cid/type1cid.c
    ${FREETYPE_SOURCE_DIR}/src/gzip/ftgzip.c
    ${FREETYPE_SOURCE_DIR}/src/lzw/ftlzw.c
    ${FREETYPE_SOURCE_DIR}/src/pcf/pcf.c
    ${FREETYPE_SOURCE_DIR}/src/pfr/pfr.c
    ${FREETYPE_SOURCE_DIR}/src/psaux/psaux.c
    ${FREETYPE_SOURCE_DIR}/src/pshinter/pshinter.c
    ${FREETYPE_SOURCE_DIR}/src/psnames/psnames.c
    ${FREETYPE_SOURCE_DIR}/src/raster/raster.c
    ${FREETYPE_SOURCE_DIR}/src/sfnt/sfnt.c
    ${FREETYPE_SOURCE_DIR}/src/smooth/smooth.c
    ${FREETYPE_SOURCE_DIR}/src/truetype/truetype.c
    ${FREETYPE_SOURCE_DIR}/src/type1/type1.c
    ${FREETYPE_SOURCE_DIR}/src/type42/type42.c
    ${FREETYPE_SOURCE_DIR}/src/winfonts/winfnt.c)

set(FREETYPE_PUBLIC_CONFIG_HEADERS
    ${FREETYPE_SOURCE_DIR}/include/freetype/config/ftheader.h
    ${FREETYPE_SOURCE_DIR}/include/freetype/config/ftconfig.h
    ${FREETYPE_SOURCE_DIR}/include/freetype/config/ftmodule.h
    ${FREETYPE_SOURCE_DIR}/include/freetype/config/ftoption.h
    ${FREETYPE_SOURCE_DIR}/include/freetype/config/ftstdlib.h)

if(MSVC OR MINGW)
  enable_language(RC)
  list(APPEND FREETYPE_BASE_SRCS
       "${FREETYPE_SOURCE_DIR}/builds/windows/ftdebug.c"
       "${FREETYPE_SOURCE_DIR}/src/base/ftver.rc")
else()
  list(APPEND FREETYPE_BASE_SRCS "${FREETYPE_SOURCE_DIR}/src/base/ftdebug.c")
endif()

file(GLOB FREETYPE_PUBLIC_HEADERS "${FREETYPE_SOURCE_DIR}/include/freetype/*.h")
file(GLOB FREETYPE_PUBLIC_CONFIG_HEADERS
     "${FREETYPE_SOURCE_DIR}/include/freetype/config/*.h")
file(GLOB FREETYPE_PRIVATE_HEADERS
     "${FREETYPE_SOURCE_DIR}/include/freetype/internal/*.h")

if(MSVC)
  list(APPEND PRIVATE_DEFINITIONS -D_CRT_SECURE_NO_WARNINGS) # Disable warnings
                                                             # for unsecure CRT
                                                             # functions
  list(APPEND PRIVATE_DEFINITIONS -DFT2_BUILD_LIBRARY)

  list(APPEND PRIVATE_DEBUG_DEFINITIONS -DFT_DEBUG_LEVEL_ERROR)
  list(APPEND PRIVATE_DEBUG_DEFINITIONS -DFT_DEBUG_LEVEL_TRACE)

  list(APPEND PRIVATE_OPTIONS /W4) # Warning Level 4
  # Supress warnings
  list(APPEND PRIVATE_OPTIONS /wd4001) # nonstandard extension 'single line
                                       # comment' was used
  list(APPEND PRIVATE_OPTIONS /wd4244) # conversion' conversion from 'type1' to
                                       # 'type2', possible loss of data
  list(APPEND PRIVATE_OPTIONS /wd4701) # Potentially uninitialized local
                                       # variable 'name' used
  list(APPEND PRIVATE_OPTIONS /wd4702) # unreachable code
  list(APPEND PRIVATE_OPTIONS /wd4100) # identifier' : unreferenced formal
                                       # parameter

  list(APPEND PRIVATE_OPTIONS /MP) # Build with Multiple Processes

  list(APPEND PRIVATE_RELEASE_OPTIONS /GF) # Enable Function-Level Linking
  list(APPEND PRIVATE_RELEASE_OPTIONS /Gy) # Eliminate Duplicate Strings
  list(APPEND PRIVATE_RELEASE_OPTIONS /Ob1) # Allows expansion only of functions
                                            # marked inline, __inline, or
                                            # __forceinline

  set(CMAKE_DEBUG_POSTFIX "d")
endif(MSVC)

if(MINGW)
  list(APPEND PRIVATE_DEFINITIONS -DFT2_BUILD_LIBRARY)
endif(MINGW)

add_library(
  freetype STATIC
  ${PUBLIC_FT2BUILD_H} ${FREETYPE_PUBLIC_HEADERS}
  ${FREETYPE_PUBLIC_CONFIG_HEADERS} ${FREETYPE_PRIVATE_HEADERS}
  ${FREETYPE_BASE_SRCS})

# Dependent include files
target_include_directories(
  freetype
  PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
         $<BUILD_INTERFACE:${FREETYPE_SOURCE_DIR}/include>
         $<INSTALL_INTERFACE:include>)

target_compile_definitions(freetype PRIVATE ${PRIVATE_DEFINITIONS})

target_compile_definitions(
  freetype PRIVATE "$<$<CONFIG:DEBUG>:${PRIVATE_DEBUG_DEFINITIONS}>")

target_compile_options(
  freetype PRIVATE ${PRIVATE_OPTIONS}
                   "$<$<CONFIG:RELEASE>:${PRIVATE_RELEASE_OPTIONS}>")

set_target_properties(freetype PROPERTIES C_VISIBILITY_PRESET hidden)

# INSTALL
install(
  TARGETS freetype
  EXPORT freetype_export
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(FILES ${PUBLIC_FT2BUILD_H} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
install(FILES ${FREETYPE_PUBLIC_HEADERS}
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/freetype)
install(FILES ${FREETYPE_PUBLIC_CONFIG_HEADERS}
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/freetype/config)
