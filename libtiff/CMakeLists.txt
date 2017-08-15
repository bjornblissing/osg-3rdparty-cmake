CMAKE_MINIMUM_REQUIRED(VERSION 3.5 FATAL_ERROR)


# parse the full version number from tiffvers.h and include in LIBTIFF_FULL_VERSION
FILE(STRINGS "${LIBTIFF_SOURCE_DIR}/VERSION" LIBTIFF_FULL_VERSION REGEX "[0-9]+\\.[0-9]+\\.[0-9]+")

PROJECT(libtiff VERSION ${LIBTIFF_FULL_VERSION} LANGUAGES C)

# Use GNUInstallDirs to install libraries into correct
# locations on all platforms.
INCLUDE(GNUInstallDirs)

IF(MSVC)
  SET(tif_config "${LIBTIFF_SOURCE_DIR}/libtiff/tif_config.vc.h")
  SET(tiffconf "${LIBTIFF_SOURCE_DIR}/libtiff/tiffconf.vc.h")
ENDIF()

IF(MINGW)
  SET(tif_config "${CMAKE_CURRENT_SOURCE_DIR}/tif_config.mingw.h")
  SET(tiffconf "${CMAKE_CURRENT_SOURCE_DIR}/tiffconf.mingw.h")
ENDIF()

CONFIGURE_FILE(${tif_config} tif_config.h @ONLY)
CONFIGURE_FILE(${tiffconf} tiffconf.h @ONLY)

CONFIGURE_FILE(${LIBTIFF_SOURCE_DIR}/libtiff/tiff.h tiff.h COPYONLY)
CONFIGURE_FILE(${LIBTIFF_SOURCE_DIR}/libtiff/tiffio.h tiffio.h COPYONLY)
CONFIGURE_FILE(  ${LIBTIFF_SOURCE_DIR}/libtiff/tiffvers.h tiffvers.h COPYONLY)



SET(LIBTIFF_PUBLIC_HEADERS
  ${CMAKE_CURRENT_BINARY_DIR}/tiffconf.h
  ${CMAKE_CURRENT_BINARY_DIR}/tiff.h
  ${CMAKE_CURRENT_BINARY_DIR}/tiffio.h
  ${CMAKE_CURRENT_BINARY_DIR}/tiffvers.h
)

SET(LIBTIFF_PRIVATE_HEADERS
  ${CMAKE_CURRENT_BINARY_DIR}/tif_config.h

  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_dir.h
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_fax3.h
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_predict.h
  ${LIBTIFF_SOURCE_DIR}/libtiff/tiffiop.h
  ${LIBTIFF_SOURCE_DIR}/libtiff/t4.h
  ${LIBTIFF_SOURCE_DIR}/libtiff/uvcode.h
)

SET(LIBTIFF_SRCS
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_aux.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_close.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_codec.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_color.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_compress.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_dir.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_dirinfo.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_dirread.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_dirwrite.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_dumpmode.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_error.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_extension.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_fax3.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_fax3sm.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_flush.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_getimage.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_jbig.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_jpeg.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_luv.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_lzw.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_next.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_ojpeg.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_open.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_packbits.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_pixarlog.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_predict.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_print.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_read.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_strip.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_swab.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_thunder.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_tile.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_version.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_warning.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_win32.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_write.c
  ${LIBTIFF_SOURCE_DIR}/libtiff/tif_zip.c
)


# Check if we have SNPRINTF:
INCLUDE(CheckFunctionExists)
CHECK_FUNCTION_EXISTS(snprintf HAVE_SNPRINTF)

IF(HAVE_SNPRINTF)
  LIST(APPEND PRIVATE_DEFINITIONS -DHAVE_SNPRINTF)
ENDIF()


IF(MSVC)
  LIST(APPEND PRIVATE_DEFINITIONS -D_CRT_SECURE_NO_WARNINGS) # Disable warnings for unsecure CRT functions
  LIST(APPEND PRIVATE_DEFINITIONS -D_LIB)
  LIST(APPEND PRIVATE_OPTIONS /Gy) # Eliminate Duplicate Strings
  LIST(APPEND PRIVATE_OPTIONS /Oi) # Generate Intrinsic Functions
  LIST(APPEND PRIVATE_OPTIONS /wd4244) # conversion' conversion from 'type1' to 'type2', possible loss of data
  SET(CMAKE_DEBUG_POSTFIX "d_i")
  SET(CMAKE_RELEASE_POSTFIX "_i")
ENDIF(MSVC)

ADD_LIBRARY(libtiff STATIC ${LIBTIFF_SRCS} ${LIBTIFF_PRIVATE_HEADERS} ${LIBTIFF_PUBLIC_HEADERS})

# Dependent include files
TARGET_INCLUDE_DIRECTORIES(libtiff PUBLIC 
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}> 
  $<INSTALL_INTERFACE:include>
  )

TARGET_COMPILE_DEFINITIONS(libtiff
  PRIVATE ${PRIVATE_DEFINITIONS}
  )
  
TARGET_COMPILE_OPTIONS(libtiff 
  PRIVATE ${PRIVATE_OPTIONS}
  )
  

TARGET_LINK_LIBRARIES(libtiff zlib jpeg)


IF(MINGW)
  # Static library name
  SET_TARGET_PROPERTIES(${TARGET_LIB} PROPERTIES PREFIX "")
  SET_TARGET_PROPERTIES(${TARGET_LIB} PROPERTIES SUFFIX ".a")
ENDIF()

# INSTALL
INSTALL(TARGETS libtiff EXPORT libtiff_export
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )

INSTALL(FILES 
  ${LIBTIFF_PUBLIC_HEADERS} 
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )

