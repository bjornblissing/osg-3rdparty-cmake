# linux.cmake

if (POLICY CMP0020)
  cmake_policy(SET CMP0020 NEW)
endif(POLICY CMP0020)
if (POLICY CMP0042)
  cmake_policy(SET CMP0042 NEW)
endif(POLICY CMP0042)
# Use new variable expansion policy.
if (POLICY CMP0053)
  cmake_policy(SET CMP0053 NEW)
endif(POLICY CMP0053)
if (POLICY CMP0054)
  cmake_policy(SET CMP0054 NEW)
endif(POLICY CMP0054)

# Read version information from configure.ac.
FILE(STRINGS "${LIBTIFF_SOURCE_DIR}/configure.ac" configure REGEX "^LIBTIFF_.*=")
foreach(line ${configure})
  foreach(var LIBTIFF_MAJOR_VERSION LIBTIFF_MINOR_VERSION LIBTIFF_MICRO_VERSION LIBTIFF_ALPHA_VERSION
          LIBTIFF_CURRENT LIBTIFF_REVISION LIBTIFF_AGE)
    if(NOT ${var} AND line MATCHES "^${var}=(.*)")
      set(${var} "${CMAKE_MATCH_1}")
      break()
    endif()
  endforeach()
endforeach()

math(EXPR SO_MAJOR "${LIBTIFF_CURRENT} - ${LIBTIFF_AGE}")
set(SO_MINOR "${LIBTIFF_AGE}")
set(SO_REVISION "${LIBTIFF_REVISION}")

message(STATUS "Building tiff version ${LIBTIFF_MAJOR_VERSION}.${LIBTIFF_MINOR_VERSION}.${LIBTIFF_MICRO_VERSION}${LIBTIFF_ALPHA_VERSION}")
message(STATUS "libtiff library version ${SO_MAJOR}.${SO_MINOR}.${SO_REVISION}")

set(BUILD_SHARED_LIBS ON CACHE BOOL "Build shared libraries")

set(VERSION "${LIBTIFF_MAJOR_VERSION}.${LIBTIFF_MINOR_VERSION}.${LIBTIFF_MICRO_VERSION}")
set(tiff_VERSION "${VERSION}")
set(tiff_VERSION_MAJOR "${LIBTIFF_MAJOR_VERSION}")
set(tiff_VERSION_MINOR "${LIBTIFF_MINOR_VERSION}")
set(tiff_VERSION_PATCH "${LIBTIFF_MICRO_VERSION}")


# the other tiff_VERSION_* variables are set automatically
set(tiff_VERSION_ALPHA "${LIBTIFF_ALPHA_VERSION}")
# Library version (unlike libtool's baroque scheme, WYSIWYG here)
set(SO_COMPATVERSION "${SO_MAJOR}")
set(SO_VERSION "${SO_MAJOR}.${SO_MINOR}.${SO_REVISION}")

# For autotools header compatibility
set(PACKAGE_NAME "LibTIFF Software")
set(PACKAGE_TARNAME "${PROJECT_NAME}")
set(PACKAGE_VERSION "${PROJECT_VERSION}${tiff_VERSION_ALPHA}")
set(PACKAGE_STRING "${PACKAGE_NAME} ${PACKAGE_VERSION}")
set(PACKAGE_BUGREPORT "tiff@lists.maptools.org")


include(GNUInstallDirs)
include(CheckCCompilerFlag)
include(CheckCSourceCompiles)
include(CheckIncludeFile)
include(CheckLibraryExists)
include(CheckTypeSize)
include(CheckSymbolExists)

macro(current_date var)
  if(UNIX)
    execute_process(COMMAND "date" +"%Y%m%d" OUTPUT_VARIABLE ${var})
  endif()
endmacro()

current_date(RELEASE_DATE)

macro(extra_dist)
  foreach(file ${ARGV})
    file(RELATIVE_PATH relfile "${PROJECT_SOURCE_DIR}"
         "${CMAKE_CURRENT_SOURCE_DIR}/${file}")
    list(APPEND EXTRA_DIST "${relfile}")
  endforeach()
  set(EXTRA_DIST "${EXTRA_DIST}" PARENT_SCOPE)
endmacro()

option(extra-warnings "Enable extra compiler warnings" OFF)

# This will cause the compiler to fail when an error occurs.
option(fatal-warnings "Compiler warnings are errors" OFF)

if(CMAKE_C_COMPILER_ID STREQUAL "GNU" OR
   CMAKE_C_COMPILER_ID MATCHES "Clang")
  set(test_flags
      -Wall
      -Winline
      -W
      -Wformat-security
      -Wpointer-arith
      -Wdisabled-optimization
      -Wno-unknown-pragmas
      -Wdeclaration-after-statement
      -fstrict-aliasing)
  if(extra-warnings)
    list(APPEND test_flags
        -Wfloat-equal
        -Wmissing-prototypes
        -Wunreachable-code)
  endif()
  if(fatal-warnings)
    list(APPEND test_flags
         -Werror)
  endif()
endif()

foreach(flag ${test_flags})
  string(REGEX REPLACE "[^A-Za-z0-9]" "_" flag_var "${flag}")
  set(test_c_flag "C_FLAG${flag_var}")
  CHECK_C_COMPILER_FLAG(${flag} "${test_c_flag}")
  if (${test_c_flag})
     set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${flag}")
  endif (${test_c_flag})
endforeach(flag ${test_flags})


option(ld-version-script "Enable linker version script" ON)
# Check if LD supports linker scripts.
# file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/conftest.map" "VERS_1 {
        # global: sym;
# };

# VERS_2 {
        # global: sym;
# } VERS_1;
# ")
# set(CMAKE_REQUIRED_FLAGS_SAVE ${CMAKE_REQUIRED_FLAGS})
# set(CMAKE_REQUIRED_FLAGS ${CMAKE_REQUIRED_FLAGS} "-Wl,--version-script=${CMAKE_CURRENT_BINARY_DIR}/conftest.map")
# check_c_source_compiles("int main(void){return 0;}" HAVE_LD_VERSION_SCRIPT)
# set(CMAKE_REQUIRED_FLAGS ${CMAKE_REQUIRED_FLAGS_SAVE})
# file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/conftest.map")
# if (ld-version-script AND HAVE_LD_VERSION_SCRIPT)
  # set(HAVE_LD_VERSION_SCRIPT TRUE)
# else()
  # set(HAVE_LD_VERSION_SCRIPT FALSE)
# endif()

if(NOT MINGW)
  find_library(M_LIBRARY m)
endif()

check_include_file(assert.h    HAVE_ASSERT_H)
check_include_file(dlfcn.h     HAVE_DLFCN_H)
check_include_file(fcntl.h     HAVE_FCNTL_H)
check_include_file(inttypes.h  HAVE_INTTYPES_H)
check_include_file(io.h        HAVE_IO_H)
check_include_file(search.h    HAVE_SEARCH_H)
check_include_file(stdint.h    HAVE_STDINT_H)
check_include_file(string.h    HAVE_STRING_H)
check_include_file(strings.h   HAVE_STRINGS_H)
check_include_file(sys/time.h  HAVE_SYS_TIME_H)
check_include_file(sys/types.h HAVE_SYS_TYPES_H)
check_include_file(unistd.h    HAVE_UNISTD_H)

# Inspired from /usr/share/autoconf/autoconf/c.m4
foreach(inline_keyword "inline" "__inline__" "__inline")
  if(NOT DEFINED C_INLINE)
    set(CMAKE_REQUIRED_DEFINITIONS_SAVE ${CMAKE_REQUIRED_DEFINITIONS})
    set(CMAKE_REQUIRED_DEFINITIONS ${CMAKE_REQUIRED_DEFINITIONS}
        "-Dinline=${inline_keyword}")
    check_c_source_compiles("
        typedef int foo_t;
        static inline foo_t static_foo() {return 0;}
        foo_t foo(){return 0;}
        int main(int argc, char *argv[]) {return 0;}"
      C_HAS_${inline_keyword})
    set(CMAKE_REQUIRED_DEFINITIONS ${CMAKE_REQUIRED_DEFINITIONS_SAVE})
    if(C_HAS_${inline_keyword})
      set(C_INLINE TRUE)
      set(INLINE_KEYWORD "${inline_keyword}")
    endif()
 endif()
endforeach()
if(NOT DEFINED C_INLINE)
  set(INLINE_KEYWORD)
endif()


# Check type sizes
# NOTE: Could be replaced with C99 <stdint.h>
check_type_size("signed int" SIZEOF_SIGNED_INT)
check_type_size("unsigned int" SIZEOF_UNSIGNED_INT)
check_type_size("signed long" SIZEOF_SIGNED_LONG)
check_type_size("unsigned long" SIZEOF_UNSIGNED_LONG)
check_type_size("signed long long" SIZEOF_SIGNED_LONG_LONG)
check_type_size("unsigned long long" SIZEOF_UNSIGNED_LONG_LONG)
check_type_size("unsigned char *" SIZEOF_UNSIGNED_CHAR_P)

set(CMAKE_EXTRA_INCLUDE_FILES_SAVE ${CMAKE_EXTRA_INCLUDE_FILES})
set(CMAKE_EXTRA_INCLUDE_FILES ${CMAKE_EXTRA_INCLUDE_FILES} "stddef.h")
check_type_size("size_t" SIZEOF_SIZE_T)
check_type_size("ptrdiff_t" SIZEOF_PTRDIFF_T)
set(CMAKE_EXTRA_INCLUDE_FILES ${CMAKE_EXTRA_INCLUDE_FILES_SAVE})



macro(report_values)
  foreach(val ${ARGV})
    message(STATUS "${val} set to ${${val}}")
  endforeach()
endmacro()

set(TIFF_INT8_T "signed char")
set(TIFF_UINT8_T "unsigned char")

set(TIFF_INT16_T "signed short")
set(TIFF_UINT16_T "unsigned short")

if(SIZEOF_SIGNED_INT EQUAL 4)
  set(TIFF_INT32_T "signed int")
  set(TIFF_INT32_FORMAT "%d")
elseif(SIZEOF_SIGNED_LONG EQUAL 4)
  set(TIFF_INT32_T "signed long")
  set(TIFF_INT32_FORMAT "%ld")
endif()

if(SIZEOF_UNSIGNED_INT EQUAL 4)
  set(TIFF_UINT32_T "unsigned int")
  set(TIFF_UINT32_FORMAT "%u")
elseif(SIZEOF_UNSIGNED_LONG EQUAL 4)
  set(TIFF_UINT32_T "unsigned long")
  set(TIFF_UINT32_FORMAT "%lu")
endif()

if(SIZEOF_SIGNED_LONG EQUAL 8)
  set(TIFF_INT64_T "signed long")
  set(TIFF_INT64_FORMAT "%ld")
elseif(SIZEOF_SIGNED_LONG_LONG EQUAL 8)
  set(TIFF_INT64_T "signed long long")
  if (MINGW)
    set(TIFF_INT64_FORMAT "%I64d")
  else()
    set(TIFF_INT64_FORMAT "%lld")
  endif()
endif()

if(SIZEOF_UNSIGNED_LONG EQUAL 8)
  set(TIFF_UINT64_T "unsigned long")
  set(TIFF_UINT64_FORMAT "%lu")
elseif(SIZEOF_UNSIGNED_LONG_LONG EQUAL 8)
  set(TIFF_UINT64_T "unsigned long long")
  if (MINGW)
    set(TIFF_UINT64_FORMAT "%I64u")
  else()
    set(TIFF_UINT64_FORMAT "%llu")
  endif()
endif()

if(SIZEOF_UNSIGNED_INT EQUAL SIZEOF_SIZE_T)
  set(TIFF_SIZE_T "unsigned int")
  set(TIFF_SIZE_FORMAT "%u")
  set(TIFF_SSIZE_T "signed int")
  set(TIFF_SSIZE_FORMAT "%d")
elseif(SIZEOF_UNSIGNED_LONG EQUAL SIZEOF_SIZE_T)
  set(TIFF_SIZE_T "unsigned long")
  set(TIFF_SIZE_FORMAT "%lu")
  set(TIFF_SSIZE_T "signed long")
  set(TIFF_SSIZE_FORMAT "%ld")
elseif(SIZEOF_UNSIGNED_LONG_LONG EQUAL SIZEOF_SIZE_T)
  set(TIFF_SIZE_T "unsigned long long")
  set(TIFF_SSIZE_T "signed long long")
  if (MINGW)
    set(TIFF_SIZE_FORMAT "%I64u")
    set(TIFF_SSIZE_FORMAT "%I64d")
  else()
    set(TIFF_SIZE_FORMAT "%llu")
    set(TIFF_SSIZE_FORMAT "%lld")
  endif()
endif()

if(NOT SIZEOF_PTRDIFF_T)
  set(TIFF_PTRDIFF_T "${TIFF_SSIZE_T}")
  set(TIFF_PTRDIFF_FORMAT "${SSIZE_FORMAT}")
else()
  set(TIFF_PTRDIFF_T "ptrdiff_t")
  set(TIFF_PTRDIFF_FORMAT "%ld")
endif()

report_values(TIFF_INT8_T TIFF_INT8_FORMAT
             TIFF_UINT8_T TIFF_UINT8_FORMAT
              TIFF_INT16_T TIFF_INT16_FORMAT
              TIFF_UINT16_T TIFF_UINT16_FORMAT
              TIFF_INT32_T TIFF_INT32_FORMAT
             TIFF_UINT32_T TIFF_UINT32_FORMAT
             TIFF_INT64_T TIFF_INT64_FORMAT
             TIFF_UINT64_T TIFF_UINT64_FORMAT
              TIFF_SSIZE_T TIFF_SSIZE_FORMAT
              TIFF_PTRDIFF_T TIFF_PTRDIFF_FORMAT)

check_symbol_exists(mmap "sys/mman.h" HAVE_MMAP)
check_symbol_exists(setmode "unistd.h" HAVE_SETMODE)
check_symbol_exists(snprintf "stdio.h" HAVE_SNPRINTF)
check_symbol_exists(strcasecmp "strings.h" HAVE_STRCASECMP)
check_symbol_exists(strtol "stdlib.h" HAVE_STRTOL)
check_symbol_exists(strtoll "stdlib.h" HAVE_STRTOLL)
check_symbol_exists(strtoul "stdlib.h" HAVE_STRTOUL)
check_symbol_exists(strtoull "stdlib.h" HAVE_STRTOULL)
check_symbol_exists(getopt "unistd.h;stdio.h" HAVE_GETOPT)
check_symbol_exists(lfind "search.h" HAVE_LFIND)

if(NOT HAVE_SNPRINTF)
  add_definitions(-DNEED_LIBPORT)
endif()

# CPU bit order
set(HOST_FILLORDER FILLORDER_MSB2LSB)
if(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "i.*86.*" OR
   CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "amd64.*" OR
   # AMD64 on Windows
   CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "AMD64" OR
   CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "x86_64.*")
  set(HOST_FILLORDER FILLORDER_LSB2MSB)
endif()

# CPU endianness
include(TestBigEndian)
test_big_endian(HOST_BIG_ENDIAN)
if(HOST_BIG_ENDIAN)
  add_definitions(-DWORDS_BIGENDIAN)
endif()

# IEEE floating point
#set(HAVE_IEEEFP 1)

report_values(CMAKE_HOST_SYSTEM_PROCESSOR HOST_FILLORDER
             HOST_BIG_ENDIAN HAVE_IEEEFP)

# Large file support
if (UNIX OR MINGW)
  # This might not catch every possibility catered for by
 # AC_SYS_LARGEFILE.
  add_definitions(-D_FILE_OFFSET_BITS=64)
  set(FILE_OFFSET_BITS 64)
  endif()

# Strip chopping
option(strip-chopping "strip chopping (whether or not to convert single-strip uncompressed images to mutiple strips of specified size to reduce memory usage)" ON)
set(TIFF_DEFAULT_STRIP_SIZE 8192 CACHE STRING "default size of the strip in bytes (when strip chopping is enabled)")

set(STRIPCHOP_DEFAULT)
if(strip-chopping)
  set(STRIPCHOP_DEFAULT TRUE)
  if(TIFF_DEFAULT_STRIP_SIZE)
    set(STRIP_SIZE_DEFAULT "${TIFF_DEFAULT_STRIP_SIZE}")
  endif()
endif()

# Strip chopping
option(strip-chopping "strip chopping (whether or not to convert single-strip uncompressed images to mutiple strips of specified size to reduce memory usage)" ON)
set(TIFF_DEFAULT_STRIP_SIZE 8192 CACHE STRING "default size of the strip in bytes (when strip chopping is enabled)")

set(STRIPCHOP_DEFAULT)
if(strip-chopping)
  set(STRIPCHOP_DEFAULT TRUE)
  if(TIFF_DEFAULT_STRIP_SIZE)
    set(STRIP_SIZE_DEFAULT "${TIFF_DEFAULT_STRIP_SIZE}")
  endif()
endif()
