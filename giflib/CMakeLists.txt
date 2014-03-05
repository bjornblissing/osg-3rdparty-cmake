PROJECT(giflib C)

SET(TARGET_LIB libgif)

SET(GIFLIB_PUBLIC_HEADERS
	${GIFLIB_SOURCE_DIR}/lib/gif_lib.h
)
SET(GIFLIB_PRIVATE_HEADERS
	${GIFLIB_SOURCE_DIR}/lib/gif_lib_private.h
	${GIFLIB_SOURCE_DIR}/lib/gif_hash.h
)

SET(GIFLIB_SRCS
	${GIFLIB_SOURCE_DIR}/lib/dgif_lib.c
	${GIFLIB_SOURCE_DIR}/lib/egif_lib.c
	${GIFLIB_SOURCE_DIR}/lib/gif_err.c
	${GIFLIB_SOURCE_DIR}/lib/gif_font.c
	${GIFLIB_SOURCE_DIR}/lib/gif_hash.c
	${GIFLIB_SOURCE_DIR}/lib/gifalloc.c
	${GIFLIB_SOURCE_DIR}/lib/quantize.c
)

IF(MSVC)
	# Add unistd.h, getopt.h, getopt.c and stdbool.h for windows build
	# getopt from: http://gist.github.com/ashelly/7776712
	# unistd.h from: http://stackoverflow.com/questions/341817/is-there-a-replacement-for-unistd-h-for-windows-visual-c
	# stdbool.h is just a simple redefinition of bool as int
	SET(GIFLIB_PUBLIC_HEADERS
		${GIFLIB_PUBLIC_HEADERS}
		${CMAKE_CURRENT_SOURCE_DIR}/stdbool.h
	)

	SET(GIFLIB_PRIVATE_HEADERS
		${GIFLIB_PRIVATE_HEADERS}
		${CMAKE_CURRENT_SOURCE_DIR}/getopt.h
		${CMAKE_CURRENT_SOURCE_DIR}/unistd.h
	)

	SET(GIFLIB_SRCS
		${GIFLIB_SRCS}
		${CMAKE_CURRENT_SOURCE_DIR}/getopt.c
	)
ENDIF(MSVC)


# Dependent include files
INCLUDE_DIRECTORIES(${GIFLIB_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})

IF(MSVC)
	SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /wd4018 /wd4028 /wd4244 /wd4996")
	ADD_DEFINITIONS(-D_CRT_SECURE_NO_WARNINGS -D_LIB)
	SET(CMAKE_DEBUG_POSTFIX "d")
ENDIF(MSVC)

ADD_LIBRARY(${TARGET_LIB} STATIC ${GIFLIB_SRCS} ${GIFLIB_PRIVATE_HEADERS} ${GIFLIB_PUBLIC_HEADERS})

# Runtime equals DLL-files
# Archive equals static libraries
# Library equals module libraries
IF(NOT SKIP_INSTALL_LIBRARIES AND NOT SKIP_INSTALL_ALL )
	install(TARGETS ${TARGET_LIB}
		RUNTIME DESTINATION ${EXECUTABLE_OUTPUT_PATH}
		LIBRARY DESTINATION ${LIBRARY_OUTPUT_PATH}
		ARCHIVE DESTINATION ${ARCHIVE_OUTPUT_PATH})
ENDIF()
IF(NOT SKIP_INSTALL_HEADERS AND NOT SKIP_INSTALL_ALL )
	install(FILES ${GIFLIB_PUBLIC_HEADERS} DESTINATION ${INCLUDE_OUTPUT_PATH})
ENDIF()

