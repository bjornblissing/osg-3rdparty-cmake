CMAKE_MINIMUM_REQUIRED(VERSION 3.5 FATAL_ERROR)
# parse the full version number from png.h and include in PNG_FULL_VERSION
FILE(READ ${LIBPNG_SOURCE_DIR}/png.h _png_h_contents)
STRING(REGEX REPLACE ".*#define[ \t]+PNG_LIBPNG_VER_STRING[ \t]+\"([-0-9A-Za-z.]+)\".*" "\\1" PNG_FULL_VERSION ${_png_h_contents})

PROJECT(libpng VERSION ${PNG_FULL_VERSION} LANGUAGES C)

# Use GNUInstallDirs to install libraries into correct
# locations on all platforms.
INCLUDE(GNUInstallDirs)

IF(NOT WIN32)
  FIND_LIBRARY(M_LIBRARY
    NAMES m
    PATHS /usr/lib /usr/local/lib
  )
  IF(NOT M_LIBRARY)
    MESSAGE(STATUS
      "math library 'libm' not found - floating point support disabled")
  ENDIF()
else()
  # not needed on windows
  SET(M_LIBRARY "")
ENDIF()


# to distinguish between debug and release lib
SET(CMAKE_DEBUG_POSTFIX "d")

# Use the prebuilt pnglibconf.h file from the scripts folder
# TODO: fix this by building with awk; without this no cmake build can be
# configured directly (to do so indirectly use your local awk to build a
# pnglibconf.h in the build directory.)
CONFIGURE_FILE(${LIBPNG_SOURCE_DIR}/scripts/pnglibconf.h.prebuilt pnglibconf.h @ONLY)
CONFIGURE_FILE(${LIBPNG_SOURCE_DIR}/png.h png.h COPYONLY)
CONFIGURE_FILE(${LIBPNG_SOURCE_DIR}/pngconf.h pngconf.h COPYONLY)

# OUR SOURCES
SET(LIBPNG_PUBLIC_HEADERS
  ${CMAKE_CURRENT_BINARY_DIR}/png.h
  ${CMAKE_CURRENT_BINARY_DIR}/pngconf.h
  ${CMAKE_CURRENT_BINARY_DIR}/pnglibconf.h
)
SET(LIBPNG_SOURCES
  ${LIBPNG_SOURCE_DIR}/pngdebug.h
  ${LIBPNG_SOURCE_DIR}/pnginfo.h
  ${LIBPNG_SOURCE_DIR}/pngpriv.h
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
)

IF(NOT MINGW)
  SET(LIBPNG_DLL_SRCS
    ${LIBPNG_SOURCE_DIR}/scripts/pngwin.rc
  )
ENDIF()

# Needed definitions for windows

IF(MSVC)
  LIST(APPEND PRIVATE_DEFINITIONS -D_CRT_SECURE_NO_WARNINGS) # Disable warnings for unsecure CRT functions
  LIST(APPEND PRIVATE_DEFINITIONS -DPNG_CONFIGURE_LIBPNG)
  LIST(APPEND PRIVATE_DEFINITIONS -DPNG_DEBUG)
  LIST(APPEND PRIVATE_DEFINITIONS -DPNG_BUILD_DLL)
ENDIF(MSVC)

ADD_LIBRARY(png SHARED ${LIBPNG_SOURCES} ${LIBPNG_PUBLIC_HEADERS} ${LIBPNG_DLL_SRCS})
TARGET_INCLUDE_DIRECTORIES(png PUBLIC 
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}> 
  $<INSTALL_INTERFACE:include>
  )

TARGET_COMPILE_DEFINITIONS(png
  PRIVATE ${PRIVATE_DEFINITIONS}
  )

TARGET_LINK_LIBRARIES(png zlib ${M_LIBRARY})

IF(MSVC)
  # msvc does not append 'lib' - do it here to have consistent name
  SET_TARGET_PROPERTIES(png PROPERTIES PREFIX "lib")
  SET_TARGET_PROPERTIES(png PROPERTIES IMPORT_PREFIX "lib")
ENDIF()

IF(MINGW)
  # Static library name
  SET_TARGET_PROPERTIES(png PROPERTIES IMPORT_SUFFIX ".a")
  # Shared library name
  SET_TARGET_PROPERTIES(png PROPERTIES SUFFIX ".dll")
ENDIF(MINGW)

IF(WIN32)
  SET_TARGET_PROPERTIES(png PROPERTIES DEFINE_SYMBOL PNG_BUILD_DLL)
ENDIF()

# INSTALL
INSTALL(TARGETS png EXPORT png_export
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )

INSTALL(FILES 
  ${LIBPNG_PUBLIC_HEADERS} 
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )

