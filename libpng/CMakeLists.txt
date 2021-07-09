cmake_minimum_required(VERSION 3.5 FATAL_ERROR)
# parse the full version number from png.h and include in PNG_FULL_VERSION
file(READ ${LIBPNG_SOURCE_DIR}/png.h _png_h_contents)
string(
  REGEX
  REPLACE ".*#define[ \t]+PNG_LIBPNG_VER_STRING[ \t]+\"([-0-9A-Za-z.]+)\".*"
          "\\1" PNG_FULL_VERSION ${_png_h_contents})

project(
  libpng
  VERSION ${PNG_FULL_VERSION}
  LANGUAGES C)

# Use GNUInstallDirs to install libraries into correct locations on all
# platforms.
include(GNUInstallDirs)

if(UNIX
   AND NOT APPLE
   AND NOT BEOS
   AND NOT HAIKU)
  find_library(M_LIBRARY m)
else()
  # libm is not needed and/or not available
  set(M_LIBRARY "")
endif()

# set definitions and sources for intel
if(CMAKE_SYSTEM_PROCESSOR MATCHES "^i?86"
   OR CMAKE_SYSTEM_PROCESSOR MATCHES "^x86_64*"
   OR CMAKE_SYSTEM_PROCESSOR MATCHES "AMD64")
  set(LIBPNG_INTEL_SSE
      true
      CACHE BOOL "INTEL_SSE optimizations")
  if(LIBPNG_INTEL_SSE)
    set(libpng_intel_sources
        ${LIBPNG_SOURCE_DIR}/intel/intel_init.c
        ${LIBPNG_SOURCE_DIR}/intel/filter_sse2_intrinsics.c)
    list(APPEND PRIVATE_DEFINITIONS -DPNG_INTEL_SSE_OPT=1)
  else()
    list(APPEND PRIVATE_DEFINITIONS -DPNG_INTEL_SSE_OPT=0)
  endif()
endif()

# to distinguish between debug and release lib
set(CMAKE_DEBUG_POSTFIX "d")

# Use the prebuilt pnglibconf.h file from the scripts folder TODO: fix this by
# building with awk; without this no cmake build can be configured directly (to
# do so indirectly use your local awk to build a pnglibconf.h in the build
# directory.)
configure_file(${LIBPNG_SOURCE_DIR}/scripts/pnglibconf.h.prebuilt pnglibconf.h
               @ONLY)
configure_file(${LIBPNG_SOURCE_DIR}/png.h png.h COPYONLY)
configure_file(${LIBPNG_SOURCE_DIR}/pngconf.h pngconf.h COPYONLY)

# OUR SOURCES
set(LIBPNG_PUBLIC_HEADERS
    ${CMAKE_CURRENT_BINARY_DIR}/png.h ${CMAKE_CURRENT_BINARY_DIR}/pngconf.h
    ${CMAKE_CURRENT_BINARY_DIR}/pnglibconf.h)
set(LIBPNG_SOURCES
    ${LIBPNG_SOURCE_DIR}/pngpriv.h
    ${LIBPNG_SOURCE_DIR}/pngdebug.h
    ${LIBPNG_SOURCE_DIR}/pnginfo.h
    ${LIBPNG_SOURCE_DIR}/pngstruct.h
    ${LIBPNG_SOURCE_DIR}/png.c
    ${LIBPNG_SOURCE_DIR}/pngerror.c
    ${LIBPNG_SOURCE_DIR}/pngget.c
    ${LIBPNG_SOURCE_DIR}/pngmem.c
    ${LIBPNG_SOURCE_DIR}/pngpread.c
    ${LIBPNG_SOURCE_DIR}/pngread.c
    ${LIBPNG_SOURCE_DIR}/pngrio.c
    ${LIBPNG_SOURCE_DIR}/pngrtran.c
    ${LIBPNG_SOURCE_DIR}/pngrutil.c
    ${LIBPNG_SOURCE_DIR}/pngset.c
    ${LIBPNG_SOURCE_DIR}/pngtrans.c
    ${LIBPNG_SOURCE_DIR}/pngwio.c
    ${LIBPNG_SOURCE_DIR}/pngwrite.c
    ${LIBPNG_SOURCE_DIR}/pngwtran.c
    ${LIBPNG_SOURCE_DIR}/pngwutil.c
    ${libpng_intel_sources})

if(NOT MINGW)
  set(LIBPNG_DLL_SRCS ${LIBPNG_SOURCE_DIR}/scripts/pngwin.rc)
endif()

# Needed definitions for windows

if(MSVC)
  list(APPEND PRIVATE_DEFINITIONS -D_CRT_SECURE_NO_WARNINGS) # Disable warnings
                                                             # for unsecure CRT
                                                             # functions
  # LIST(APPEND PRIVATE_DEFINITIONS -DPNG_CONFIGURE_LIBPNG)
  list(APPEND PRIVATE_DEFINITIONS -DPNG_DEBUG)
  list(APPEND PRIVATE_DEFINITIONS -DPNG_BUILD_DLL)
endif(MSVC)

add_library(png SHARED ${LIBPNG_SOURCES} ${LIBPNG_PUBLIC_HEADERS}
                       ${LIBPNG_DLL_SRCS})
target_include_directories(
  png PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
             $<INSTALL_INTERFACE:include>)

target_compile_definitions(png PRIVATE ${PRIVATE_DEFINITIONS})

target_link_libraries(png zlib ${M_LIBRARY})

if(MSVC)
  # msvc does not append 'lib' - do it here to have consistent name
  set_target_properties(png PROPERTIES PREFIX "lib")
  set_target_properties(png PROPERTIES IMPORT_PREFIX "lib")
endif()

if(MINGW)
  # Static library name
  set_target_properties(png PROPERTIES IMPORT_SUFFIX ".a")
  # Shared library name
  set_target_properties(png PROPERTIES SUFFIX ".dll")
endif(MINGW)

if(WIN32)
  set_target_properties(png PROPERTIES DEFINE_SYMBOL PNG_BUILD_DLL)
endif()

# INSTALL
install(
  TARGETS png
  EXPORT png_export
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(FILES ${LIBPNG_PUBLIC_HEADERS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
