cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(OpenscenegraphThirdParty)

# Only enable release and debug builds
if(CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_CONFIGURATION_TYPES Debug Release)
  set(CMAKE_CONFIGURATION_TYPES
      "${CMAKE_CONFIGURATION_TYPES}"
      CACHE STRING "Reset the configurations to what we need" FORCE)
endif()

# Generate folder name for install
if(${CMAKE_SIZEOF_VOID_P} EQUAL 8)
  set(BITS "x64")
elseif(${CMAKE_SIZEOF_VOID_P} EQUAL 4)
  set(BITS "x86")
endif()

if(MSVC)
  if(${MSVC_VERSION} EQUAL 1600)
    set(TOOLSET "v100") # Visual Studio 2010
  elseif(${MSVC_VERSION} EQUAL 1700)
    set(TOOLSET "v110") # Visual Studio 2012
  elseif(${MSVC_VERSION} EQUAL 1800)
    set(TOOLSET "v120") # Visual Studio 2013
  elseif(${MSVC_VERSION} EQUAL 1900)
    set(TOOLSET "v140") # Visual Studio 2015
  elseif(${MSVC_VERSION} GREATER 1910 AND ${MSVC_VERSION} LESS 1920)
    set(TOOLSET "v141") # Visual Studio 2017
  elseif(${MSVC_VERSION} GREATER 1919)
    set(TOOLSET "v142") # Visual Studio 2019
  endif()
endif()

if(MINGW)
  set(TOOLSET "mingw")
endif()

set(dirname "${TOOLSET}-${BITS}")

# Set directories if not set explicitly
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX
      "${PROJECT_BINARY_DIR}/3rdParty/${dirname}"
      CACHE "Force change of path" STRING FORCE)
endif()

set(ZLIB_SOURCE_DIR CACHE PATH "Path where to find ZLIB source")
set(LIBPNG_SOURCE_DIR CACHE PATH "Path where to find LIBPNG source")
set(LIBJPEG_SOURCE_DIR CACHE PATH "Path where to find LIBJPEG source")
set(LIBTIFF_SOURCE_DIR CACHE PATH "Path where to find LIBTIFF source")
set(FREETYPE_SOURCE_DIR CACHE PATH "Path where to find FREETYPE source")
set(GLUT_SOURCE_DIR CACHE PATH "Path where to find GLUT source")
set(GIFLIB_SOURCE_DIR CACHE PATH "Path where to find GIFLIB source")
set(CURL_SOURCE_DIR CACHE PATH "Path where to find cURL source")

# Check dependencies for LIBPNG
if(LIBPNG_SOURCE_DIR)
  if(NOT ZLIB_SOURCE_DIR)
    message(
      FATAL_ERROR "Error: LIBPNG depends on ZLIB and no ZLIB path has been set")
  endif()
endif()

# Check dependencies for LIBTIFF
if(LIBTIFF_SOURCE_DIR)
  if(NOT ZLIB_SOURCE_DIR)
    message(
      FATAL_ERROR "Error: LIBTIFF depends on ZLIB and no ZLIB path has been set"
    )
  endif()

  if(NOT LIBJPEG_SOURCE_DIR)
    message(
      FATAL_ERROR
        "Error: LIBTIFF depends on LIBJPEG and no LIBJPEG path has been set")
  endif()
endif()

# Check dependencies for MINIZIP
if(MINIZIP_SOURCE_DIR)
  if(NOT ZLIB_SOURCE_DIR)
    message(
      FATAL_ERROR "Error: MINIZIP depends on ZLIB and no ZLIB path has been set"
    )
  endif()
endif()

# Add libraries
if(ZLIB_SOURCE_DIR)
  add_subdirectory(zlib)
endif()

if(LIBPNG_SOURCE_DIR)
  add_subdirectory(libpng)
endif()

if(LIBJPEG_SOURCE_DIR)
  add_subdirectory(libjpeg)
endif()

if(LIBTIFF_SOURCE_DIR)
  add_subdirectory(libtiff)
endif()

if(FREETYPE_SOURCE_DIR)
  add_subdirectory(freetype)
endif()

if(GLUT_SOURCE_DIR)
  add_subdirectory(glut)
endif()

if(GIFLIB_SOURCE_DIR)
  add_subdirectory(giflib)
endif()

if(CURL_SOURCE_DIR)
  add_subdirectory(curl)
endif()
