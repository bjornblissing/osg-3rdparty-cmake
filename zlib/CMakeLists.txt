PROJECT(zlib C)

SET(TARGET_LIB zlib)

SET(ZLIB_VERSION "1.2.8")

OPTION(ZLIB_USE_ASM686 "Enable building i686 assembly implementation" OFF)
OPTION(ZLIB_USE_AMD64 "Enable building amd64 assembly implementation" OFF)

MARK_AS_ADVANCED(ZLIB_USE_ASM686 ZLIB_USE_AMD64)

INCLUDE(CheckTypeSize)
INCLUDE(CheckFunctionExists)
INCLUDE(CheckIncludeFile)
INCLUDE(CheckCSourceCompiles)

CHECK_INCLUDE_FILE(sys/types.h HAVE_SYS_TYPES_H)
CHECK_INCLUDE_FILE(stdint.h	HAVE_STDINT_H)
CHECK_INCLUDE_FILE(stddef.h	HAVE_STDDEF_H)

#
# Check for fseeko
#
check_function_exists(fseeko HAVE_FSEEKO)
IF(NOT HAVE_FSEEKO)
	ADD_DEFINITIONS(-DNO_FSEEKO)
ENDIF()

# Visual studio options
IF(MSVC)
	SET(CMAKE_DEBUG_POSTFIX "d")
	ADD_DEFINITIONS(-D_CRT_SECURE_NO_DEPRECATE)
	ADD_DEFINITIONS(-D_CRT_NONSTDC_NO_DEPRECATE)
ENDIF()

SET(ZLIB_PC zlib.pc)
CONFIGURE_FILE(${ZLIB_SOURCE_DIR}/zlib.pc.cmakein ${ZLIB_PC} @ONLY)
CONFIGURE_FILE(${ZLIB_SOURCE_DIR}/zconf.h.cmakein zconf.h @ONLY)


#============================================================================
# zlib
#============================================================================

SET(ZLIB_PUBLIC_HDRS
	${CMAKE_CURRENT_BINARY_DIR}/zconf.h
	${ZLIB_SOURCE_DIR}/zlib.h
)
SET(ZLIB_PRIVATE_HDRS
	${ZLIB_SOURCE_DIR}/crc32.h
	${ZLIB_SOURCE_DIR}/deflate.h
	${ZLIB_SOURCE_DIR}/gzguts.h
	${ZLIB_SOURCE_DIR}/inffast.h
	${ZLIB_SOURCE_DIR}/inffixed.h
	${ZLIB_SOURCE_DIR}/inflate.h
	${ZLIB_SOURCE_DIR}/inftrees.h
	${ZLIB_SOURCE_DIR}/trees.h
	${ZLIB_SOURCE_DIR}/zutil.h
)
SET(ZLIB_SRCS
	${ZLIB_SOURCE_DIR}/adler32.c
	${ZLIB_SOURCE_DIR}/compress.c
	${ZLIB_SOURCE_DIR}/crc32.c
	${ZLIB_SOURCE_DIR}/deflate.c
	${ZLIB_SOURCE_DIR}/gzclose.c
	${ZLIB_SOURCE_DIR}/gzlib.c
	${ZLIB_SOURCE_DIR}/gzread.c
	${ZLIB_SOURCE_DIR}/gzwrite.c
	${ZLIB_SOURCE_DIR}/inflate.c
	${ZLIB_SOURCE_DIR}/infback.c
	${ZLIB_SOURCE_DIR}/inftrees.c
	${ZLIB_SOURCE_DIR}/inffast.c
	${ZLIB_SOURCE_DIR}/trees.c
	${ZLIB_SOURCE_DIR}/uncompr.c
	${ZLIB_SOURCE_DIR}/zutil.c
)

# Dependent include files
INCLUDE_DIRECTORIES(${ZLIB_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})

IF(NOT MINGW)
	SET(ZLIB_DLL_SRCS
		${ZLIB_SOURCE_DIR}/win32/zlib1.rc # If present will override custom build rule below.
	)
ENDIF()

IF(CMAKE_COMPILER_IS_GNUCC)
	IF(ZLIB_USE_ASM686)
		SET(ZLIB_ASMS ${ZLIB_SOURCE_DIR}/contrib/asm686/match.S)
	ELSEIF (ZLIB_USE_AMD64)
		SET(ZLIB_ASMS ${ZLIB_SOURCE_DIR}/contrib/amd64/amd64-match.S)
	ENDIF ()

	IF(ZLIB_ASMS)
		add_definitions(-DASMV)
		set_source_files_properties(${ZLIB_ASMS} PROPERTIES LANGUAGE C COMPILE_FLAGS -DNO_UNDERLINE)
	ENDIF()
ENDIF()

IF(MSVC)
	IF(ZLIB_USE_ASM686)
		ENABLE_LANGUAGE(ASM_MASM)
		SET(ZLIB_ASMS
			${ZLIB_SOURCE_DIR}/contrib/masmx86/inffas32.asm
			${ZLIB_SOURCE_DIR}/contrib/masmx86/match686.asm
		)
	ELSEIF (ZLIB_USE_AMD64)
		ENABLE_LANGUAGE(ASM_MASM)
		SET(ZLIB_ASMS
			${ZLIB_SOURCE_DIR}/contrib/masmx64/gvmat64.asm
			${ZLIB_SOURCE_DIR}/contrib/masmx64/inffasx64.asm
		)
	ENDIF()

	IF(ZLIB_ASMS)
		add_definitions(-DASMV -DASMINF)
	ENDIF()
ENDIF()

# parse the full version number from zlib.h and include in ZLIB_FULL_VERSION
FILE(READ ${ZLIB_SOURCE_DIR}/zlib.h _zlib_h_contents)
STRING(REGEX REPLACE ".*#define[ \t]+ZLIB_VERSION[ \t]+\"([-0-9A-Za-z.]+)\".*"
	"\\1" ZLIB_FULL_VERSION ${_zlib_h_contents})

IF(MINGW)
	# This gets us DLL resource information when compiling on MinGW.
	IF(NOT CMAKE_RC_COMPILER)
		SET(CMAKE_RC_COMPILER windres.exe)
	ENDIF()

	ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/zlib1rc.obj
					   COMMAND ${CMAKE_RC_COMPILER}
							-D GCC_WINDRES
							-I ${ZLIB_SOURCE_DIR}
							-I ${CMAKE_CURRENT_BINARY_DIR}
							-o ${CMAKE_CURRENT_BINARY_DIR}/zlib1rc.obj
							-i ${ZLIB_SOURCE_DIR}/win32/zlib1.rc)
	SET(ZLIB_DLL_SRCS ${CMAKE_CURRENT_BINARY_DIR}/zlib1rc.obj)
ENDIF(MINGW)

ADD_LIBRARY(zlib SHARED ${ZLIB_SRCS} ${ZLIB_ASMS} ${ZLIB_DLL_SRCS} ${ZLIB_PUBLIC_HDRS} ${ZLIB_PRIVATE_HDRS})
SET_TARGET_PROPERTIES(zlib PROPERTIES DEFINE_SYMBOL ZLIB_DLL)
SET_TARGET_PROPERTIES(zlib PROPERTIES SOVERSION 1)

IF(NOT CYGWIN)
	# This property causes shared libraries on Linux to have the full version
	# encoded into their final filename.  We disable this on Cygwin because
	# it causes cygz-${ZLIB_FULL_VERSION}.dll to be created when cygz.dll
	# seems to be the default.
	#
	# This has no effect with MSVC, on that platform the version info for
	# the DLL comes from the resource file win32/zlib1.rc
	SET_TARGET_PROPERTIES(zlib PROPERTIES ZLIB_VERSION ${ZLIB_FULL_VERSION})
ENDIF()

IF(UNIX)
	# On unix-like platforms the library is almost always called libz
   SET_TARGET_PROPERTIES(zlib PROPERTIES OUTPUT_NAME z)
   IF(NOT APPLE)
	 SET_TARGET_PROPERTIES(zlib PROPERTIES LINK_FLAGS "-Wl,--version-script,\"${CMAKE_CURRENT_SOURCE_DIR}/zlib.map\"")
   ENDIF()
ELSEIF(BUILD_SHARED_LIBS AND WIN32)
	# Creates zlib1.dll when building shared library version
	SET_TARGET_PROPERTIES(zlib PROPERTIES SUFFIX "1.dll")
ENDIF()

IF(MINGW)
	# Static library name
	SET_TARGET_PROPERTIES(zlib PROPERTIES IMPORT_PREFIX "")
	SET_TARGET_PROPERTIES(zlib PROPERTIES IMPORT_SUFFIX "1.a")
	# Shared library name
	SET_TARGET_PROPERTIES(zlib PROPERTIES PREFIX "")
	SET_TARGET_PROPERTIES(zlib PROPERTIES SUFFIX "1.dll")
ENDIF()

# Runtime equals DLL-files
# Archive equals static libraries
# Library equals module libraries
IF(NOT SKIP_INSTALL_LIBRARIES AND NOT SKIP_INSTALL_ALL )
	INSTALL(TARGETS zlib
		RUNTIME DESTINATION ${EXECUTABLE_OUTPUT_PATH}
		LIBRARY DESTINATION ${LIBRARY_OUTPUT_PATH}
		ARCHIVE DESTINATION ${ARCHIVE_OUTPUT_PATH})
ENDIF()
IF(NOT SKIP_INSTALL_HEADERS AND NOT SKIP_INSTALL_ALL )
	INSTALL(FILES ${ZLIB_PUBLIC_HDRS} DESTINATION ${INCLUDE_OUTPUT_PATH})
ENDIF()

