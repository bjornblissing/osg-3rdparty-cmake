cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# parse the full version number from tiffvers.h and include in
# LIBTIFF_FULL_VERSION
file(STRINGS "${LIBTIFF_SOURCE_DIR}/VERSION" LIBTIFF_FULL_VERSION
     REGEX "[0-9]+\\.[0-9]+\\.[0-9]+")

project(
  libtiff
  VERSION ${LIBTIFF_FULL_VERSION}
  LANGUAGES C)

# Use GNUInstallDirs to install libraries into correct locations on all
# platforms.
include(GNUInstallDirs)

if(MSVC)
  set(tif_config "${LIBTIFF_SOURCE_DIR}/libtiff/tif_config.vc.h")
  set(tiffconf "${LIBTIFF_SOURCE_DIR}/libtiff/tiffconf.vc.h")
endif()

if(MINGW)
  set(tif_config "${CMAKE_CURRENT_SOURCE_DIR}/tif_config.mingw.h")
  set(tiffconf "${CMAKE_CURRENT_SOURCE_DIR}/tiffconf.mingw.h")
endif()

configure_file(${tif_config} tif_config.h @ONLY)
configure_file(${tiffconf} tiffconf.h @ONLY)

configure_file(${LIBTIFF_SOURCE_DIR}/libtiff/tiff.h tiff.h COPYONLY)
configure_file(${LIBTIFF_SOURCE_DIR}/libtiff/tiffio.h tiffio.h COPYONLY)
configure_file(${LIBTIFF_SOURCE_DIR}/libtiff/tiffvers.h tiffvers.h COPYONLY)

set(LIBTIFF_PUBLIC_HEADERS
    ${CMAKE_CURRENT_BINARY_DIR}/tiffconf.h ${CMAKE_CURRENT_BINARY_DIR}/tiff.h
    ${CMAKE_CURRENT_BINARY_DIR}/tiffio.h ${CMAKE_CURRENT_BINARY_DIR}/tiffvers.h)

set(LIBTIFF_PRIVATE_HEADERS
    ${CMAKE_CURRENT_BINARY_DIR}/tif_config.h
    ${LIBTIFF_SOURCE_DIR}/libtiff/tif_dir.h
    ${LIBTIFF_SOURCE_DIR}/libtiff/tif_fax3.h
    ${LIBTIFF_SOURCE_DIR}/libtiff/tif_predict.h
    ${LIBTIFF_SOURCE_DIR}/libtiff/tiffiop.h
    ${LIBTIFF_SOURCE_DIR}/libtiff/t4.h
    ${LIBTIFF_SOURCE_DIR}/libtiff/uvcode.h)

set(LIBTIFF_SRCS
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
    ${LIBTIFF_SOURCE_DIR}/libtiff/tif_zip.c)

# Check if we have SNPRINTF:
include(CheckFunctionExists)
check_function_exists(snprintf HAVE_SNPRINTF)

if(HAVE_SNPRINTF)
  list(APPEND PRIVATE_DEFINITIONS -DHAVE_SNPRINTF)
endif()

if(MSVC)
  list(APPEND PRIVATE_DEFINITIONS -D_CRT_SECURE_NO_WARNINGS) # Disable warnings
                                                             # for unsecure CRT
                                                             # functions
  list(APPEND PRIVATE_DEFINITIONS -D_LIB)
  list(APPEND PRIVATE_OPTIONS /Gy) # Eliminate Duplicate Strings
  list(APPEND PRIVATE_OPTIONS /Oi) # Generate Intrinsic Functions
  list(APPEND PRIVATE_OPTIONS /wd4244) # conversion' conversion from 'type1' to
                                       # 'type2', possible loss of data
  set(CMAKE_DEBUG_POSTFIX "d_i")
  set(CMAKE_RELEASE_POSTFIX "_i")
endif(MSVC)

add_library(libtiff STATIC ${LIBTIFF_SRCS} ${LIBTIFF_PRIVATE_HEADERS}
                           ${LIBTIFF_PUBLIC_HEADERS})

# Dependent include files
target_include_directories(
  libtiff PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
                 $<INSTALL_INTERFACE:include>)

target_compile_definitions(libtiff PRIVATE ${PRIVATE_DEFINITIONS})

target_compile_options(libtiff PRIVATE ${PRIVATE_OPTIONS})

target_link_libraries(libtiff zlib jpeg)

if(MINGW)
  # Static library name
  set_target_properties(${TARGET_LIB} PROPERTIES PREFIX "")
  set_target_properties(${TARGET_LIB} PROPERTIES SUFFIX ".a")
endif()

# INSTALL
install(
  TARGETS libtiff
  EXPORT libtiff_export
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(FILES ${LIBTIFF_PUBLIC_HEADERS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
