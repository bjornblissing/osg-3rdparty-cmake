# CMakeLists.txt

# Copyright (C) 2007-2013 Glenn Randers-Pehrson

# This code is released under the libpng license.
# For conditions of distribution and use, see the disclaimer
# and license in png.h
project(libpng C)

SET(TARGET_LIB libpng)

SET(PNGLIB_MAJOR 1)
SET(PNGLIB_MINOR 6)
SET(PNGLIB_RELEASE 9)
SET(PNGLIB_NAME libpng${PNGLIB_MAJOR}${PNGLIB_MINOR})
SET(PNGLIB_VERSION ${PNGLIB_MAJOR}.${PNGLIB_MINOR}.${PNGLIB_RELEASE})

IF(NOT WIN32)
	find_library(M_LIBRARY
		NAMES m
		PATHS /usr/lib /usr/local/lib
	)
	IF(NOT M_LIBRARY)
		message(STATUS
			"math library 'libm' not found - floating point support disabled")
	ENDIF()
else()
	# not needed on windows
	SET(M_LIBRARY "")
ENDIF()


# SET LIBNAME
#SET(PNG_LIB_NAME png${PNGLIB_MAJOR}${PNGLIB_MINOR})
SET(PNG_LIB_NAME png)

# to distinguish between debug and release lib
SET(CMAKE_DEBUG_POSTFIX "d")

# Use the prebuilt pnglibconf.h file from the scripts folder
# TODO: fix this by building with awk; without this no cmake build can be
# configured directly (to do so indirectly use your local awk to build a
# pnglibconf.h in the build directory.)
CONFIGURE_FILE(scripts/pnglibconf.h.prebuilt pnglibconf.h @ONLY)

# OUR SOURCES
SET(libpng_public_hdrs
	png.h
	pngconf.h
	${CMAKE_CURRENT_BINARY_DIR}/pnglibconf.h
)
SET(libpng_sources
	pngdebug.h
	pnginfo.h
	pngpriv.h
	pngstruct.h
	png.c
	pngerror.c
	pngget.c
	pngmem.c
	pngpread.c
	pngread.c
	pngrio.c
	pngrtran.c
	pngrutil.c
	pngset.c
	pngtrans.c
	pngwio.c
	pngwrite.c
	pngwtran.c
	pngwutil.c
)

# Dependent include files
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})
INCLUDE_DIRECTORIES("${CMAKE_SOURCE_DIR}/zlib" "${CMAKE_BINARY_DIR}/zlib")

SET(ZLIB_LIBRARY "${LIBRARY_OUTPUT_PATH}/zlib")
SET(ZLIB_DEBUG_LIBRARY "${LIBRARY_OUTPUT_PATH}/zlibd")

MARK_AS_ADVANCED(ZLIB_LIBRARY ZLIB_DEBUG_LIBRARY)

SET(ZLIB_LIBRARIES optimized ${ZLIB_LIBRARY} debug ${ZLIB_DEBUG_LIBRARY})


# SOME NEEDED DEFINITIONS

IF(MSVC)
	ADD_DEFINITIONS(-D_CRT_SECURE_NO_WARNINGS -DPNG_CONFIGURE_LIBPNG -DPNG_DEBUG -DPNG_BUILD_DLL)
ENDIF(MSVC)

ADD_LIBRARY(${PNG_LIB_NAME} SHARED ${libpng_sources} ${libpng_public_hdrs})

IF(MSVC)
	# msvc does not append 'lib' - do it here to have consistent name
	SET_TARGET_PROPERTIES(${PNG_LIB_NAME} PROPERTIES PREFIX "lib")
	SET_TARGET_PROPERTIES(${PNG_LIB_NAME} PROPERTIES IMPORT_PREFIX "lib")
ENDIF()
TARGET_LINK_LIBRARIES(${PNG_LIB_NAME} ${ZLIB_LIBRARIES} ${M_LIBRARY})

#Dependencies
ADD_DEPENDENCIES(${PNG_LIB_NAME}
	zlib
)

IF(WIN32)
	SET_TARGET_PROPERTIES(${PNG_LIB_NAME} PROPERTIES DEFINE_SYMBOL PNG_BUILD_DLL)
ENDIF()

# INSTALL
IF(NOT SKIP_INSTALL_LIBRARIES AND NOT SKIP_INSTALL_ALL )
	INSTALL(TARGETS ${PNG_LIB_NAME}
			RUNTIME DESTINATION ${EXECUTABLE_OUTPUT_PATH}
			LIBRARY DESTINATION ${LIBRARY_OUTPUT_PATH}
			ARCHIVE DESTINATION ${ARCHIVE_OUTPUT_PATH})
ENDIF()


IF(NOT SKIP_INSTALL_HEADERS AND NOT SKIP_INSTALL_ALL )
	INSTALL(FILES ${libpng_public_hdrs} DESTINATION ${INCLUDE_OUTPUT_PATH})
ENDIF()

