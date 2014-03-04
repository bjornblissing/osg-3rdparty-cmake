PROJECT(libtiff C)

SET(TARGET_LIB libtiff)


IF(MSVC)
	SET(tif_config "tif_config.vc.h")
	SET(tiffconf "tiffconf.vc.h")
ENDIF()

CONFIGURE_FILE(${tif_config} tif_config.h @ONLY)
CONFIGURE_FILE(${tiffconf} tiffconf.h @ONLY)


SET(LIBTIFF_VERSION "4.0.3")

SET(LIBTIFF_PUBLIC_HEADERS
	tiff.h
	${CMAKE_CURRENT_BINARY_DIR}/tiffconf.h
	tiffio.h
	tiffvers.h
)
SET(LIBTIFF_PRIVATE_HEADERS
	tif_dir.h
	tif_fax3.h
	tif_predict.h
	${CMAKE_CURRENT_BINARY_DIR}/tif_config.h
	tiffiop.h
	t4.h
	uvcode.h
)
SET(LIBTIFF_SRCS
	tif_aux.c
	tif_close.c
	tif_codec.c
	tif_color.c
	tif_compress.c
	tif_dir.c
	tif_dirinfo.c
	tif_dirread.c
	tif_dirwrite.c
	tif_dumpmode.c
	tif_error.c
	tif_extension.c
	tif_fax3.c
	tif_fax3sm.c
	tif_flush.c
	tif_getimage.c
	tif_jbig.c
	tif_jpeg.c
	tif_luv.c
	tif_lzw.c
	tif_next.c
	tif_ojpeg.c
	tif_open.c
	tif_packbits.c
	tif_pixarlog.c
	tif_predict.c
	tif_print.c
	tif_read.c
	tif_strip.c
	tif_swab.c
	tif_thunder.c
	tif_tile.c
	tif_version.c
	tif_warning.c
	tif_win32.c
	tif_write.c
	tif_zip.c
)

# Dependent include files
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})

# Include ZLIB
INCLUDE_DIRECTORIES("${CMAKE_SOURCE_DIR}/zlib" "${CMAKE_BINARY_DIR}/zlib")

SET(ZLIB_LIBRARY "${LIBRARY_OUTPUT_PATH}/zlib")
SET(ZLIB_DEBUG_LIBRARY "${LIBRARY_OUTPUT_PATH}/zlibd")

MARK_AS_ADVANCED(ZLIB_LIBRARY ZLIB_DEBUG_LIBRARY)

SET(ZLIB_LIBRARIES optimized ${ZLIB_LIBRARY} debug ${ZLIB_DEBUG_LIBRARY})



# Include LIBJPEG
INCLUDE_DIRECTORIES("${CMAKE_SOURCE_DIR}/libjpeg" "${CMAKE_BINARY_DIR}/libjpeg")

SET(JPEG_LIBRARY "${LIBRARY_OUTPUT_PATH}/jpeg")
SET(JPEG_DEBUG_LIBRARY "${LIBRARY_OUTPUT_PATH}/jpegd")

MARK_AS_ADVANCED(JPEG_LIBRARY JPEG_DEBUG_LIBRARY)

SET(JPEG_LIBRARIES optimized ${JPEG_LIBRARY} debug ${JPEG_DEBUG_LIBRARY})

IF(MSVC)
	SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /Gy /Oi")
	ADD_DEFINITIONS(-D_LIB)
	SET(CMAKE_DEBUG_POSTFIX "d")
ENDIF(MSVC)

ADD_LIBRARY(${TARGET_LIB} STATIC ${LIBTIFF_SRCS} ${LIBTIFF_PRIVATE_HEADERS} ${LIBTIFF_PUBLIC_HEADERS})
target_link_libraries(${TARGET_LIB} ${ZLIB_LIBRARIES} ${JPEG_LIBRARIES})

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

