PROJECT(libtiff C)

SET(TARGET_LIB libtiff)


IF(MSVC)
	SET(tif_config "${LIFTIFF_SOURCE_DIR}/libtiff/tif_config.vc.h")
	SET(tiffconf "${LIFTIFF_SOURCE_DIR}/libtiff/tiffconf.vc.h")
ENDIF()

IF(MINGW)
	SET(tif_config "${CMAKE_CURRENT_SOURCE_DIR}/tif_config.mingw.h")
	SET(tiffconf "${CMAKE_CURRENT_SOURCE_DIR}/tiffconf.mingw.h")
ENDIF()

CONFIGURE_FILE(${tif_config} tif_config.h @ONLY)
CONFIGURE_FILE(${tiffconf} tiffconf.h @ONLY)


SET(_LIBTIFF_VERSION_FILE "${LIFTIFF_SOURCE_DIR}/VERSION")
	
IF(EXISTS "${_LIBTIFF_VERSION_FILE}") 
	FILE(STRINGS "${_LIBTIFF_VERSION_FILE}" LIBTIFF_VERSION REGEX "[0-9]+\\.[0-9]+\\.[0-9]+")
ENDIF()


SET(LIBTIFF_PUBLIC_HEADERS
	${CMAKE_CURRENT_BINARY_DIR}/tiffconf.h

	${LIFTIFF_SOURCE_DIR}/libtiff/tiff.h
	${LIFTIFF_SOURCE_DIR}/libtiff/tiffio.h
	${LIFTIFF_SOURCE_DIR}/libtiff/tiffvers.h
)
SET(LIBTIFF_PRIVATE_HEADERS
	${CMAKE_CURRENT_BINARY_DIR}/tif_config.h

	${LIFTIFF_SOURCE_DIR}/libtiff/tif_dir.h
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_fax3.h
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_predict.h
	${LIFTIFF_SOURCE_DIR}/libtiff/tiffiop.h
	${LIFTIFF_SOURCE_DIR}/libtiff/t4.h
	${LIFTIFF_SOURCE_DIR}/libtiff/uvcode.h
)
SET(LIBTIFF_SRCS
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_aux.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_close.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_codec.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_color.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_compress.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_dir.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_dirinfo.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_dirread.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_dirwrite.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_dumpmode.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_error.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_extension.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_fax3.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_fax3sm.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_flush.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_getimage.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_jbig.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_jpeg.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_luv.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_lzw.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_next.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_ojpeg.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_open.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_packbits.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_pixarlog.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_predict.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_print.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_read.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_strip.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_swab.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_thunder.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_tile.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_version.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_warning.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_win32.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_write.c
	${LIFTIFF_SOURCE_DIR}/libtiff/tif_zip.c
)

# Dependent include files
INCLUDE_DIRECTORIES("${LIFTIFF_SOURCE_DIR}/libtiff" ${CMAKE_CURRENT_BINARY_DIR})

# Include ZLIB
INCLUDE_DIRECTORIES("${ZLIB_SOURCE_DIR}" "${CMAKE_BINARY_DIR}/zlib")

SET(ZLIB_LIBRARY "${LIBRARY_OUTPUT_PATH}/zlib")
SET(ZLIB_DEBUG_LIBRARY "${LIBRARY_OUTPUT_PATH}/zlibd")

MARK_AS_ADVANCED(ZLIB_LIBRARY ZLIB_DEBUG_LIBRARY)

SET(ZLIB_LIBRARIES optimized ${ZLIB_LIBRARY} debug ${ZLIB_DEBUG_LIBRARY})

# Include LIBJPEG
INCLUDE_DIRECTORIES("${LIBJPEG_SOURCE_DIR}" "${CMAKE_BINARY_DIR}/libjpeg")

SET(JPEG_LIBRARY "${LIBRARY_OUTPUT_PATH}/jpeg")
SET(JPEG_DEBUG_LIBRARY "${LIBRARY_OUTPUT_PATH}/jpegd")

MARK_AS_ADVANCED(JPEG_LIBRARY JPEG_DEBUG_LIBRARY)

SET(JPEG_LIBRARIES optimized ${JPEG_LIBRARY} debug ${JPEG_DEBUG_LIBRARY})

# Check if we have SNPRINTF:
CHECK_C_SOURCE_COMPILES("
#include <stdio.h>
int main(void) {
  char buf[10];
  snprintf(buf, 10, \"Test %d\", 1);
  return 0;
}"
  HAVE_SNPRINTF)

IF(HAVE_SNPRINTF)
	ADD_DEFINITIONS(-DHAVE_SNPRINTF)
ENDIF()
	
IF(MSVC)
	SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /Gy /Oi")
	SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /wd4244")
	ADD_DEFINITIONS(-D_CRT_SECURE_NO_WARNINGS -D_LIB)
	SET(CMAKE_DEBUG_POSTFIX "d")
ENDIF(MSVC)

ADD_LIBRARY(${TARGET_LIB} STATIC ${LIBTIFF_SRCS} ${LIBTIFF_PRIVATE_HEADERS} ${LIBTIFF_PUBLIC_HEADERS})
target_link_libraries(${TARGET_LIB} ${ZLIB_LIBRARIES} ${JPEG_LIBRARIES})

IF(MINGW)
	# Static library name
	SET_TARGET_PROPERTIES(${TARGET_LIB} PROPERTIES PREFIX "")
	SET_TARGET_PROPERTIES(${TARGET_LIB} PROPERTIES SUFFIX ".a")
ENDIF()

ADD_DEPENDENCIES(${TARGET_LIB}
	zlib
)
ADD_DEPENDENCIES(${TARGET_LIB}
	jpeg
)
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
	INSTALL(FILES ${LIBTIFF_PUBLIC_HEADERS} DESTINATION ${INCLUDE_OUTPUT_PATH})
ENDIF()
