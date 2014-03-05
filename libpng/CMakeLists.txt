# CMakeLists.txt

# Copyright (C) 2007-2013 Glenn Randers-Pehrson

# This code is released under the libpng license.
# For conditions of distribution and use, see the disclaimer
# and license in png.h
project(libpng C)

SET(TARGET_LIB libpng)

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
SET(PNG_LIB_NAME png)

# to distinguish between debug and release lib
SET(CMAKE_DEBUG_POSTFIX "d")

# Use the prebuilt pnglibconf.h file from the scripts folder
# TODO: fix this by building with awk; without this no cmake build can be
# configured directly (to do so indirectly use your local awk to build a
# pnglibconf.h in the build directory.)
CONFIGURE_FILE(${LIBPNG_SOURCE_DIR}/scripts/pnglibconf.h.prebuilt pnglibconf.h @ONLY)

# OUR SOURCES
SET(LIBPNG_PUBLIC_HEADERS
	${LIBPNG_SOURCE_DIR}/png.h
	${LIBPNG_SOURCE_DIR}/pngconf.h
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

# Dependent include files
INCLUDE_DIRECTORIES(${LIBPNG_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})
INCLUDE_DIRECTORIES("${ZLIB_SOURCE_DIR}" "${CMAKE_BINARY_DIR}/zlib")

SET(ZLIB_LIBRARY "${LIBRARY_OUTPUT_PATH}/zlib")
SET(ZLIB_DEBUG_LIBRARY "${LIBRARY_OUTPUT_PATH}/zlibd")

MARK_AS_ADVANCED(ZLIB_LIBRARY ZLIB_DEBUG_LIBRARY)

SET(ZLIB_LIBRARIES optimized ${ZLIB_LIBRARY} debug ${ZLIB_DEBUG_LIBRARY})


# SOME NEEDED DEFINITIONS

IF(MSVC)
	ADD_DEFINITIONS(-D_CRT_SECURE_NO_WARNINGS -DPNG_CONFIGURE_LIBPNG -DPNG_DEBUG -DPNG_BUILD_DLL)
ENDIF(MSVC)

ADD_LIBRARY(${PNG_LIB_NAME} SHARED ${LIBPNG_SOURCES} ${LIBPNG_PUBLIC_HEADERS})

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
	INSTALL(FILES ${LIBPNG_PUBLIC_HEADERS} DESTINATION ${INCLUDE_OUTPUT_PATH})
ENDIF()

