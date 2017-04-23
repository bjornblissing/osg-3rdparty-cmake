PROJECT(freetype C)

SET(TARGET_LIB freetype)

# Make sure that we use the correct freetype headers directory
UNSET(FREETYPE_HEADERS_DIR CACHE)
FIND_PATH(FREETYPE_HEADERS_DIR NAMES freetype.h HINTS 
  ${FREETYPE_SOURCE_DIR}/include/freetype
  ${FREETYPE_SOURCE_DIR}/include/)

MARK_AS_ADVANCED(FREETYPE_HEADERS_DIR)

SET(FREETYPE_VERSION_FILE "${FREETYPE_HEADERS_DIR}/freetype.h")
  
IF(EXISTS "${FREETYPE_VERSION_FILE}") 
  FILE(STRINGS "${FREETYPE_VERSION_FILE}" FREETYPE_VERSION_FILE_CONTENTS REGEX "#define FREETYPE_[A-Z]+[ \t]+[0-9]+")

  STRING(REGEX REPLACE ".*#define FREETYPE_MAJOR[ \t]+([0-9]+).*" "\\1" FREETYPE_VERSION_MAJOR ${FREETYPE_VERSION_FILE_CONTENTS})
  STRING(REGEX REPLACE ".*#define FREETYPE_MINOR[ \t]+([0-9]+).*" "\\1" FREETYPE_VERSION_MINOR ${FREETYPE_VERSION_FILE_CONTENTS})
  STRING(REGEX REPLACE ".*#define FREETYPE_PATCH[ \t]+([0-9]+).*" "\\1" FREETYPE_VERSION_PATCH ${FREETYPE_VERSION_FILE_CONTENTS})
  
  SET(FREETYPE_VERSION "${FREETYPE_VERSION_MAJOR}.${FREETYPE_VERSION_MINOR}.${FREETYPE_VERSION_PATCH}")
ENDIF()


IF(MSVC)
  SET(ftdebug "${FREETYPE_SOURCE_DIR}/builds/windows/ftdebug.c")
ENDIF()

IF(MINGW)
  SET(ftdebug "${FREETYPE_SOURCE_DIR}/builds/windows/ftdebug.c")
ENDIF()

# Copy build file to local
CONFIGURE_FILE(${ftdebug} ftdebug.c @ONLY)

# Create new version of ft2build.h to use in include dir
SET(PUBLIC_FT2BUILD_H "${CMAKE_CURRENT_BINARY_DIR}/ft2build.h")
FILE(READ ${FREETYPE_SOURCE_DIR}/include/ft2build.h FT2BUILD_H_FILE_CONTENT)
  # Add freetype to path
  STRING(REGEX REPLACE "#include([ ]+)<"
    "#include\\1<freetype/"
    NEW_FT2BUILD_H_FILE_CONTENT 
    "${FT2BUILD_H_FILE_CONTENT}")
  # Remove duplicate freetypes in path
  STRING(REGEX REPLACE "freetype/freetype/"
    "freetype/" 
    NEW_FT2BUILD_H_FILE_CONTENT
    "${NEW_FT2BUILD_H_FILE_CONTENT}")
FILE(WRITE ${PUBLIC_FT2BUILD_H} "${NEW_FT2BUILD_H_FILE_CONTENT}")

# Make sure that we use the correct freetype config directory
UNSET(FREETYPE_CONFIG_DIR CACHE)

FIND_PATH(FREETYPE_CONFIG_DIR NAMES ftheader.h HINTS 
  ${FREETYPE_SOURCE_DIR}/include/freetype/config
  ${FREETYPE_SOURCE_DIR}/include/config)

# Create new version of ftheader.h to use in include dir
SET(PUBLIC_FTCONFIG_H "${CMAKE_CURRENT_BINARY_DIR}/ftheader.h")
FILE(READ ${FREETYPE_CONFIG_DIR}/ftheader.h FTHEADER_H_FILE_CONTENT)
  # Add freetype to path
  STRING(REGEX REPLACE "#define ([A-Za-z0-9_]+[ ]+)<"
    "#define \\1 <freetype/" 
    NEW_FTHEADER_H_FILE_CONTENT
    "${FTHEADER_H_FILE_CONTENT}")
  # Remove duplicate freetypes in path
  STRING(REGEX REPLACE "freetype/freetype/"
    "freetype/" 
    NEW_FTHEADER_H_FILE_CONTENT
    "${NEW_FTHEADER_H_FILE_CONTENT}")
FILE(WRITE ${PUBLIC_FTCONFIG_H} "${NEW_FTHEADER_H_FILE_CONTENT}")

MARK_AS_ADVANCED(FREETYPE_CONFIG_DIR)

SET(FREETYPE_SRCS
  ftdebug.c
  ${FREETYPE_SOURCE_DIR}/src/autofit/autofit.c
  ${FREETYPE_SOURCE_DIR}/src/bdf/bdf.c
  ${FREETYPE_SOURCE_DIR}/src/cff/cff.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftbase.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftbitmap.c
  ${FREETYPE_SOURCE_DIR}/src/cache/ftcache.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftfstype.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftgasp.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftglyph.c
  ${FREETYPE_SOURCE_DIR}/src/gzip/ftgzip.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftinit.c
  ${FREETYPE_SOURCE_DIR}/src/lzw/ftlzw.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftstroke.c
  ${FREETYPE_SOURCE_DIR}/src/base/ftsystem.c
  ${FREETYPE_SOURCE_DIR}/src/smooth/smooth.c
)

SET(FREETYPE_PRIVATE_HEADERS
  ${FREETYPE_SOURCE_DIR}/include/ft2build.h
  ${FREETYPE_HEADERS_DIR}/config/ftconfig.h
  ${FREETYPE_HEADERS_DIR}/config/ftheader.h
  ${FREETYPE_HEADERS_DIR}/config/ftmodule.h
  ${FREETYPE_HEADERS_DIR}/config/ftoption.h
  ${FREETYPE_HEADERS_DIR}/config/ftstdlib.h
)

IF (${FREETYPE_VERSION} VERSION_LESS 2.6.0)
  # Add FT MODULES
  SET(FREETYPE_SRCS
    ${FREETYPE_SRCS}
    
    ${FREETYPE_SOURCE_DIR}/src/base/ftbbox.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftgxval.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftlcdfil.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftmm.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftotval.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftpatent.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftpfr.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftsynth.c
    ${FREETYPE_SOURCE_DIR}/src/base/fttype1.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftwinfnt.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftxf86.c
    ${FREETYPE_SOURCE_DIR}/src/pcf/pcf.c
    ${FREETYPE_SOURCE_DIR}/src/pfr/pfr.c
    ${FREETYPE_SOURCE_DIR}/src/psaux/psaux.c
    ${FREETYPE_SOURCE_DIR}/src/pshinter/pshinter.c
    ${FREETYPE_SOURCE_DIR}/src/psnames/psmodule.c
    ${FREETYPE_SOURCE_DIR}/src/raster/raster.c
    ${FREETYPE_SOURCE_DIR}/src/sfnt/sfnt.c
    ${FREETYPE_SOURCE_DIR}/src/truetype/truetype.c
    ${FREETYPE_SOURCE_DIR}/src/type1/type1.c
    ${FREETYPE_SOURCE_DIR}/src/cid/type1cid.c
    ${FREETYPE_SOURCE_DIR}/src/type42/type42.c
    ${FREETYPE_SOURCE_DIR}/src/winfonts/winfnt.c
  )
ELSE()
  # Add FT MODULES
  SET(FREETYPE_SRCS
    ${FREETYPE_SRCS}
    
    ${FREETYPE_SOURCE_DIR}/src/base/ftbbox.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftfntfmt.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftgxval.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftlcdfil.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftmm.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftotval.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftpatent.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftpfr.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftsynth.c
    ${FREETYPE_SOURCE_DIR}/src/base/fttype1.c
    ${FREETYPE_SOURCE_DIR}/src/base/ftwinfnt.c
    ${FREETYPE_SOURCE_DIR}/src/pcf/pcf.c
    ${FREETYPE_SOURCE_DIR}/src/pfr/pfr.c
    ${FREETYPE_SOURCE_DIR}/src/psaux/psaux.c
    ${FREETYPE_SOURCE_DIR}/src/pshinter/pshinter.c
    ${FREETYPE_SOURCE_DIR}/src/psnames/psmodule.c
    ${FREETYPE_SOURCE_DIR}/src/raster/raster.c
    ${FREETYPE_SOURCE_DIR}/src/sfnt/sfnt.c
    ${FREETYPE_SOURCE_DIR}/src/truetype/truetype.c
    ${FREETYPE_SOURCE_DIR}/src/type1/type1.c
    ${FREETYPE_SOURCE_DIR}/src/cid/type1cid.c
    ${FREETYPE_SOURCE_DIR}/src/type42/type42.c
    ${FREETYPE_SOURCE_DIR}/src/winfonts/winfnt.c
  )
ENDIF()

# Add all freetype include files
FILE(GLOB FREETYPE_INCLUDE 
  "${FREETYPE_HEADERS_DIR}/*.h"
)
FILE(GLOB FREETYPE_INCLUDE_CONFIG 
  "${FREETYPE_HEADERS_DIR}/config/*.h"
)
# Remove ftheader.h
STRING(REGEX REPLACE "${FREETYPE_HEADERS_DIR}/config/ftheader.h" "" 
  FREETYPE_INCLUDE_CONFIG "${FREETYPE_INCLUDE_CONFIG}")

FILE(GLOB FREETYPE_INCLUDE_INTERNAL 
  "${FREETYPE_HEADERS_DIR}/internal/*.h"
)

FILE(GLOB FREETYPE_INCLUDE_INTERNAL_SERVICES 
  "${FREETYPE_HEADERS_DIR}/internal/services*.h"
)
# Dependent include files
INCLUDE_DIRECTORIES(${FREETYPE_SOURCE_DIR}/include)

IF(MSVC)
  SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /W4 /wd4001 /wd4244 /wd4701 /wd4702 /wd4100")
  SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /GF /Gy /Ob1 /MP")
  SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /MP")

  SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -D_CRT_SECURE_NO_WARNINGS -DFT2_BUILD_LIBRARY")
  SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -D_CRT_SECURE_NO_WARNINGS -DFT2_BUILD_LIBRARY -DFT_DEBUG_LEVEL_ERROR -DFT_DEBUG_LEVEL_TRACE")

  SET(CMAKE_DEBUG_POSTFIX "d")
ENDIF(MSVC)

IF (MINGW)
  ADD_DEFINITIONS(-DFT2_BUILD_LIBRARY)
ENDIF(MINGW)

ADD_LIBRARY(${TARGET_LIB} STATIC ${FREETYPE_SRCS} ${FREETYPE_PRIVATE_HEADERS} ${FREETYPE_PUBLIC_HEADERS})


# Runtime equals DLL-files
# Archive equals static libraries
# Library equals module libraries
IF(NOT SKIP_INSTALL_LIBRARIES AND NOT SKIP_INSTALL_ALL )
  INSTALL(TARGETS ${TARGET_LIB}
    RUNTIME DESTINATION ${EXECUTABLE_OUTPUT_PATH}
    LIBRARY DESTINATION ${LIBRARY_OUTPUT_PATH}
    ARCHIVE DESTINATION ${ARCHIVE_OUTPUT_PATH})
ENDIF()

IF(NOT SKIP_INSTALL_HEADERS AND NOT SKIP_INSTALL_ALL )
  INSTALL(FILES ${PUBLIC_FT2BUILD_H} DESTINATION ${INCLUDE_OUTPUT_PATH})
  INSTALL(FILES ${FREETYPE_INCLUDE} DESTINATION ${INCLUDE_OUTPUT_PATH}/freetype)
  INSTALL(FILES ${FREETYPE_INCLUDE_CONFIG} DESTINATION ${INCLUDE_OUTPUT_PATH}/freetype/config)
  INSTALL(FILES ${PUBLIC_FTCONFIG_H} DESTINATION ${INCLUDE_OUTPUT_PATH}/freetype/config)
  INSTALL(FILES ${FREETYPE_INCLUDE_INTERNAL} DESTINATION ${INCLUDE_OUTPUT_PATH}/freetype/internal)
  INSTALL(FILES ${FREETYPE_INCLUDE_INTERNAL_SERVICES} DESTINATION ${INCLUDE_OUTPUT_PATH}/freetype/internal/services)
ENDIF()
