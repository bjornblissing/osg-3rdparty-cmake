PROJECT(freetype C)

SET(TARGET_LIB freetype)


IF(MSVC)
	SET(ftdebug "builds/windows/ftdebug.c")
ENDIF()

CONFIGURE_FILE(${ftdebug} ftdebug.c @ONLY)


SET(FREETYPE_VERSION "2.5.2")

SET(FREETYPE_PUBLIC_HEADERS
	ft2build.h
)
SET(FREETYPE_PRIVATE_HEADERS
	${CMAKE_CURRENT_SOURCE_DIR}/include/config/ftconfig.h
	${CMAKE_CURRENT_SOURCE_DIR}/include/config/ftheader.h
	${CMAKE_CURRENT_SOURCE_DIR}/include/config/ftmodule.h
	${CMAKE_CURRENT_SOURCE_DIR}/include/config/ftoption.h
	${CMAKE_CURRENT_SOURCE_DIR}/include/config/ftstdlib.h
)

SET(FREETYPE_SRCS
	${CMAKE_CURRENT_BINARY_DIR}/ftdebug.c
	src/autofit/autofit.c
	src/bdf/bdf.c
	src/cff/cff.c
	src/base/ftbase.c
	src/base/ftbitmap.c
	src/cache/ftcache.c
	src/base/ftfstype.c
	src/base/ftgasp.c
	src/base/ftglyph.c
	src/gzip/ftgzip.c
	src/base/ftinit.c
	src/lzw/ftlzw.c
	src/base/ftstroke.c
	src/base/ftsystem.c
	src/smooth/smooth.c
	src/base/ftbbox.c
	src/base/ftmm.c
	src/base/ftpfr.c
	src/base/ftsynth.c
	src/base/fttype1.c
	src/base/ftwinfnt.c
	src/base/ftxf86.c
	src/base/ftlcdfil.c
	src/base/ftgxval.c
	src/base/ftotval.c
	src/base/ftpatent.c
	src/pcf/pcf.c
	src/pfr/pfr.c
	src/psaux/psaux.c
	src/pshinter/pshinter.c
	src/psnames/psmodule.c
	src/raster/raster.c
	src/sfnt/sfnt.c
	src/truetype/truetype.c
	src/type1/type1.c
	src/cid/type1cid.c
	src/type42/type42.c
	src/winfonts/winfnt.c
)

# Add all freetype include files
FILE(GLOB FREETYPE_INCLUDE 
	"${CMAKE_CURRENT_SOURCE_DIR}/include/*.h"
)

FILE(GLOB FREETYPE_INCLUDE_CONFIG 
	"${CMAKE_CURRENT_SOURCE_DIR}/include/config/*.h"
)

FILE(GLOB FREETYPE_INCLUDE_INTERNAL 
	"${CMAKE_CURRENT_SOURCE_DIR}/include/internal/*.h"
)

FILE(GLOB FREETYPE_INCLUDE_INTERNAL_SERVICES 
	"${CMAKE_CURRENT_SOURCE_DIR}/include/internal/services*.h"
)

# Dependent include files
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/include ${CMAKE_CURRENT_BINARY_DIR})



IF(MSVC)
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /W4 /Za /wd\"4001\"")
	set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /GF /Gy /Ob1 /MP")
	set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}")

	IF(CMAKE_BUILD_TYPE STREQUAL "Debug")
		ADD_DEFINITIONS(-D_CRT_SECURE_NO_WARNINGS -DFT2_BUILD_LIBRARY -DFT_DEBUG_LEVEL_ERROR -DFT_DEBUG_LEVEL_TRACE)
		
	ELSE()
		ADD_DEFINITIONS(-D_CRT_SECURE_NO_WARNINGS -DFT2_BUILD_LIBRARY)
	ENDIF()
	SET(CMAKE_DEBUG_POSTFIX "d")
ENDIF(MSVC)

ADD_LIBRARY(${TARGET_LIB} STATIC ${FREETYPE_SRCS} ${FREETYPE_PRIVATE_HEADERS} ${CMAKE_CURRENT_SOURCE_DIR}/include/${FREETYPE_PUBLIC_HEADERS})


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
	INSTALL(FILES ${CMAKE_CURRENT_SOURCE_DIR}/include/${FREETYPE_PUBLIC_HEADERS} DESTINATION ${INCLUDE_OUTPUT_PATH})
	INSTALL(FILES ${FREETYPE_INCLUDE} DESTINATION ${INCLUDE_OUTPUT_PATH}/freetype)
	INSTALL(FILES ${FREETYPE_INCLUDE_CONFIG} DESTINATION ${INCLUDE_OUTPUT_PATH}/freetype/config)
	INSTALL(FILES ${FREETYPE_INCLUDE_INTERNAL} DESTINATION ${INCLUDE_OUTPUT_PATH}/freetype/internal)
	INSTALL(FILES ${FREETYPE_INCLUDE_INTERNAL_SERVICES} DESTINATION ${INCLUDE_OUTPUT_PATH}/freetype/internal/services)
ENDIF()

