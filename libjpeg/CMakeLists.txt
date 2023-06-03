cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# parse the full version number from jversion.h and include in JPEG_FULL_VERSION
file(READ ${LIBJPEG_SOURCE_DIR}/jversion.h _jversion_h_contents)

string(REGEX REPLACE ".*#define[ \t]+JVERSION[ \t]+\"([0-9]+[a-z]+).+\".*"
                     "\\1" JPEG_FULL_VERSION ${_jversion_h_contents})
string(REGEX REPLACE "([0-9]+)[a-z]+" "\\1" JPEG_MAJOR_VERSION
                     ${JPEG_FULL_VERSION})
string(REGEX REPLACE "[0-9]+([a-z]+)" "\\1" JPEG_MINOR_VERSION
                     ${JPEG_FULL_VERSION})
# Convert minor version letter to number
if("${JPEG_MINOR_VERSION}" MATCHES [aA])
  set(JPEG_MINOR_VERSION 0)
elseif("${JPEG_MINOR_VERSION}" MATCHES [bB])
  set(JPEG_MINOR_VERSION 1)
elseif("${JPEG_MINOR_VERSION}" MATCHES [cC])
  set(JPEG_MINOR_VERSION 2)
elseif("${JPEG_MINOR_VERSION}" MATCHES [dD])
  set(JPEG_MINOR_VERSION 3)
elseif("${JPEG_MINOR_VERSION}" MATCHES [eE])
  set(JPEG_MINOR_VERSION 4)
elseif("${JPEG_MINOR_VERSION}" MATCHES [fF])
  set(JPEG_MINOR_VERSION 5)
elseif("${JPEG_MINOR_VERSION}" MATCHES [gG])
  set(JPEG_MINOR_VERSION 6)
elseif("${JPEG_MINOR_VERSION}" MATCHES [hH])
  set(JPEG_MINOR_VERSION 7)
else()
  message(FATAL_ERROR "Minor JPEG version exceeds version H")
endif()


project(
  jpeg
  VERSION ${JPEG_MAJOR_VERSION}.${JPEG_MINOR_VERSION}
  LANGUAGES C)

# Use GNUInstallDirs to install libraries into correct locations on all
# platforms.
include(GNUInstallDirs)

set(jconfig "${LIBJPEG_SOURCE_DIR}/jconfig.txt")
if(MSVC)
  set(jconfig "${LIBJPEG_SOURCE_DIR}/jconfig.vc")
endif()

if(MINGW)
  set(jconfig "${LIBJPEG_SOURCE_DIR}/jconfig.vc")
endif()

configure_file(${jconfig} jconfig.h @ONLY)
configure_file(${LIBJPEG_SOURCE_DIR}/jerror.h jerror.h COPYONLY)
configure_file(${LIBJPEG_SOURCE_DIR}/jmorecfg.h jmorecfg.h COPYONLY)
configure_file(${LIBJPEG_SOURCE_DIR}/jpeglib.h jpeglib.h COPYONLY)

set(LIBJPEG_PUBLIC_HEADERS
    ${CMAKE_CURRENT_BINARY_DIR}/jconfig.h ${CMAKE_CURRENT_BINARY_DIR}/jerror.h
    ${CMAKE_CURRENT_BINARY_DIR}/jmorecfg.h
    ${CMAKE_CURRENT_BINARY_DIR}/jpeglib.h)

set(LIBJPEG_PRIVATE_HEADERS
    ${LIBJPEG_SOURCE_DIR}/jdct.h ${LIBJPEG_SOURCE_DIR}/jinclude.h
    ${LIBJPEG_SOURCE_DIR}/jmemsys.h ${LIBJPEG_SOURCE_DIR}/jpegint.h
    ${LIBJPEG_SOURCE_DIR}/jversion.h)

set(LIBJPEG_SRCS
    ${LIBJPEG_SOURCE_DIR}/jaricom.c
    ${LIBJPEG_SOURCE_DIR}/jcapimin.c
    ${LIBJPEG_SOURCE_DIR}/jcapistd.c
    ${LIBJPEG_SOURCE_DIR}/jcarith.c
    ${LIBJPEG_SOURCE_DIR}/jccoefct.c
    ${LIBJPEG_SOURCE_DIR}/jccolor.c
    ${LIBJPEG_SOURCE_DIR}/jcdctmgr.c
    ${LIBJPEG_SOURCE_DIR}/jchuff.c
    ${LIBJPEG_SOURCE_DIR}/jcinit.c
    ${LIBJPEG_SOURCE_DIR}/jcmainct.c
    ${LIBJPEG_SOURCE_DIR}/jcmarker.c
    ${LIBJPEG_SOURCE_DIR}/jcmaster.c
    ${LIBJPEG_SOURCE_DIR}/jcomapi.c
    ${LIBJPEG_SOURCE_DIR}/jcparam.c
    ${LIBJPEG_SOURCE_DIR}/jcprepct.c
    ${LIBJPEG_SOURCE_DIR}/jcsample.c
    ${LIBJPEG_SOURCE_DIR}/jctrans.c
    ${LIBJPEG_SOURCE_DIR}/jdapimin.c
    ${LIBJPEG_SOURCE_DIR}/jdapistd.c
    ${LIBJPEG_SOURCE_DIR}/jdarith.c
    ${LIBJPEG_SOURCE_DIR}/jdatadst.c
    ${LIBJPEG_SOURCE_DIR}/jdatasrc.c
    ${LIBJPEG_SOURCE_DIR}/jdcoefct.c
    ${LIBJPEG_SOURCE_DIR}/jdcolor.c
    ${LIBJPEG_SOURCE_DIR}/jddctmgr.c
    ${LIBJPEG_SOURCE_DIR}/jdhuff.c
    ${LIBJPEG_SOURCE_DIR}/jdinput.c
    ${LIBJPEG_SOURCE_DIR}/jdmainct.c
    ${LIBJPEG_SOURCE_DIR}/jdmarker.c
    ${LIBJPEG_SOURCE_DIR}/jdmaster.c
    ${LIBJPEG_SOURCE_DIR}/jdmerge.c
    ${LIBJPEG_SOURCE_DIR}/jdpostct.c
    ${LIBJPEG_SOURCE_DIR}/jdsample.c
    ${LIBJPEG_SOURCE_DIR}/jdtrans.c
    ${LIBJPEG_SOURCE_DIR}/jerror.c
    ${LIBJPEG_SOURCE_DIR}/jfdctflt.c
    ${LIBJPEG_SOURCE_DIR}/jfdctfst.c
    ${LIBJPEG_SOURCE_DIR}/jfdctint.c
    ${LIBJPEG_SOURCE_DIR}/jidctflt.c
    ${LIBJPEG_SOURCE_DIR}/jidctfst.c
    ${LIBJPEG_SOURCE_DIR}/jidctint.c
    ${LIBJPEG_SOURCE_DIR}/jmemmgr.c
    ${LIBJPEG_SOURCE_DIR}/jmemnobs.c
    ${LIBJPEG_SOURCE_DIR}/jquant1.c
    ${LIBJPEG_SOURCE_DIR}/jquant2.c
    ${LIBJPEG_SOURCE_DIR}/jutils.c)

# Dependent include files
include_directories(${LIBJPEG_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})

if(MSVC)
  list(APPEND PRIVATE_DEFINITIONS -D_CRT_SECURE_NO_WARNINGS) # Disable warnings
                                                             # for unsecure CRT
                                                             # functions
  list(APPEND PRIVATE_DEFINITIONS -D_LIB)
  list(APPEND PRIVATE_OPTIONS /Gy) # Eliminate Duplicate Strings
  set(CMAKE_DEBUG_POSTFIX "d")
endif(MSVC)

add_library(jpeg STATIC ${LIBJPEG_SRCS} ${LIBJPEG_PRIVATE_HEADERS}
                        ${LIBJPEG_PUBLIC_HEADERS})

# Dependent include files
target_include_directories(
  jpeg PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
              $<INSTALL_INTERFACE:include>)

target_compile_definitions(jpeg PRIVATE ${PRIVATE_DEFINITIONS})

target_compile_options(jpeg PRIVATE ${PRIVATE_OPTIONS})

# INSTALL
install(
  TARGETS jpeg
  EXPORT jpeg_export
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(FILES ${LIBJPEG_PUBLIC_HEADERS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
