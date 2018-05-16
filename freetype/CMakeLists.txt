CMAKE_MINIMUM_REQUIRED(VERSION 3.5 FATAL_ERROR)
FILE(STRINGS "${FREETYPE_SOURCE_DIR}/include/freetype/freetype.h" FREETYPE_VERSION_FILE_CONTENTS REGEX "#define FREETYPE_[A-Z]+[ \t]+[0-9]+")

STRING(REGEX REPLACE ".*#define FREETYPE_MAJOR[ \t]+([0-9]+).*" "\\1" FREETYPE_VERSION_MAJOR ${FREETYPE_VERSION_FILE_CONTENTS})
STRING(REGEX REPLACE ".*#define FREETYPE_MINOR[ \t]+([0-9]+).*" "\\1" FREETYPE_VERSION_MINOR ${FREETYPE_VERSION_FILE_CONTENTS})
STRING(REGEX REPLACE ".*#define FREETYPE_PATCH[ \t]+([0-9]+).*" "\\1" FREETYPE_VERSION_PATCH ${FREETYPE_VERSION_FILE_CONTENTS})
  

PROJECT(freetype VERSION "${FREETYPE_VERSION_MAJOR}.${FREETYPE_VERSION_MINOR}.${FREETYPE_VERSION_PATCH}" LANGUAGES C)

# Use GNUInstallDirs to install libraries into correct
# locations on all platforms.
INCLUDE(GNUInstallDirs)


IF(MSVC OR MINGW)
  SET(FTDEBUG "${FREETYPE_SOURCE_DIR}/builds/windows/ftdebug.c")
ELSE()
  SET(FTDEBUG "${FREETYPE_SOURCE_DIR}/src/base/ftdebug.c")
ENDIF()

SET(PUBLIC_FT2BUILD_H "${FREETYPE_SOURCE_DIR}/include/ft2build.h")

SET(FREETYPE_BASE_SRCS
  ${FTDEBUG}
  ${FREETYPE_SOURCE_DIR}/src/autofit/autofit.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftbase.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftbbox.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftbdf.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftbitmap.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftcid.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftfntfmt.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftfstype.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftgasp.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftglyph.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftgxval.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftinit.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftlcdfil.c
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
  ${FREETYPE_SOURCE_DIR}/src/winfonts/winfnt.c
  )

SET(FREETYPE_PUBLIC_CONFIG_HEADERS
  ${FREETYPE_SOURCE_DIR}/include/freetype/config/ftheader.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/config/ftconfig.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/config/ftmodule.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/config/ftoption.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/config/ftstdlib.h
  )

SET(FREETYPE_PUBLIC_HEADERS
  ${FREETYPE_SOURCE_DIR}/include/freetype/freetype.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftadvanc.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftbbox.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftbdf.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftbitmap.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftbzip2.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftcache.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftchapters.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftcid.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/fterrdef.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/fterrors.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftfntfmt.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftgasp.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftglyph.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftgxval.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftgzip.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftimage.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftincrem.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftlcdfil.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftlist.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftlzw.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftmac.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftmm.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftmodapi.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftmoderr.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftotval.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftoutln.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftpfr.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftrender.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftsizes.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftsnames.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftstroke.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftsynth.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftsystem.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/fttrigon.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/fttypes.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ftwinfnt.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/t1tables.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/ttnameid.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/tttables.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/tttags.h
  )

SET(FREETYPE_PRIVATE_HEADERS 
  ${FREETYPE_SOURCE_DIR}/include/freetype/internal/autohint.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/internal/ftcalc.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/internal/ftdebug.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/internal/ftgloadr.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/internal/fthash.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/internal/ftmemory.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/internal/ftobjs.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/internal/ftpic.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/internal/ftrfork.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/internal/ftserv.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/internal/ftstream.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/internal/fttrace.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/internal/ftvalid.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/internal/internal.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/internal/psaux.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/internal/pshints.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/internal/sfnt.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/internal/t1types.h
  ${FREETYPE_SOURCE_DIR}/include/freetype/internal/tttypes.h
  )

IF(MSVC)
  LIST(APPEND PRIVATE_DEFINITIONS -D_CRT_SECURE_NO_WARNINGS) # Disable warnings for unsecure CRT functions
  LIST(APPEND PRIVATE_DEFINITIONS -DFT2_BUILD_LIBRARY)
  
  LIST(APPEND PRIVATE_DEBUG_DEFINITIONS -DFT_DEBUG_LEVEL_ERROR)
  LIST(APPEND PRIVATE_DEBUG_DEFINITIONS -DFT_DEBUG_LEVEL_TRACE)
  
  LIST(APPEND PRIVATE_OPTIONS /W4) # Warning Level 4
  # Supress warnings
  LIST(APPEND PRIVATE_OPTIONS /wd4001) # nonstandard extension 'single line comment' was used
  LIST(APPEND PRIVATE_OPTIONS /wd4244) # conversion' conversion from 'type1' to 'type2', possible loss of data
  LIST(APPEND PRIVATE_OPTIONS /wd4701) # Potentially uninitialized local variable 'name' used
  LIST(APPEND PRIVATE_OPTIONS /wd4702) # unreachable code
  LIST(APPEND PRIVATE_OPTIONS /wd4100) # identifier' : unreferenced formal parameter
  
  LIST(APPEND PRIVATE_OPTIONS /MP) # Build with Multiple Processes
  
  LIST(APPEND PRIVATE_RELEASE_OPTIONS /GF) # Enable Function-Level Linking
  LIST(APPEND PRIVATE_RELEASE_OPTIONS /Gy) # Eliminate Duplicate Strings
  LIST(APPEND PRIVATE_RELEASE_OPTIONS /Ob1) # Allows expansion only of functions marked inline, __inline, or __forceinline
  
  SET(CMAKE_DEBUG_POSTFIX "d")
ENDIF(MSVC)

IF (MINGW)
  LIST(APPEND PRIVATE_DEFINITIONS -DFT2_BUILD_LIBRARY)
ENDIF(MINGW)


ADD_LIBRARY(freetype STATIC 
  ${PUBLIC_FT2BUILD_H}
  ${FREETYPE_PUBLIC_HEADERS}
  ${FREETYPE_PUBLIC_CONFIG_HEADERS}
  ${FREETYPE_PRIVATE_HEADERS}
  ${FREETYPE_BASE_SRCS}
  )

# Dependent include files
TARGET_INCLUDE_DIRECTORIES(freetype PUBLIC 
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}> 
  $<BUILD_INTERFACE:${FREETYPE_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:include>
  )

TARGET_COMPILE_DEFINITIONS(freetype
  PRIVATE ${PRIVATE_DEFINITIONS}
  )

  TARGET_COMPILE_DEFINITIONS(freetype
  PRIVATE "$<$<CONFIG:DEBUG>:${PRIVATE_DEBUG_DEFINITIONS}>"
  )
  
TARGET_COMPILE_OPTIONS(freetype 
  PRIVATE ${PRIVATE_OPTIONS}
  "$<$<CONFIG:RELEASE>:${PRIVATE_RELEASE_OPTIONS}>"
  )
  


# INSTALL
INSTALL(TARGETS freetype EXPORT freetype_export
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )


INSTALL(FILES ${PUBLIC_FT2BUILD_H} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
INSTALL(FILES ${FREETYPE_PUBLIC_HEADERS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/freetype)
INSTALL(FILES ${FREETYPE_PUBLIC_CONFIG_HEADERS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/freetype/config)
