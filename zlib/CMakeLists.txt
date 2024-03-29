cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# parse the full version number from zlib.h and include in ZLIB_FULL_VERSION
file(READ ${ZLIB_SOURCE_DIR}/zlib.h _zlib_h_contents)
string(REGEX REPLACE ".*#define[ \t]+ZLIB_VERSION[ \t]+\"([-0-9A-Za-z.]+)\".*"
                     "\\1" ZLIB_FULL_VERSION ${_zlib_h_contents})

project(
  zlib
  VERSION ${ZLIB_FULL_VERSION}
  LANGUAGES C)

# Use GNUInstallDirs to install libraries into correct locations on all
# platforms.
include(GNUInstallDirs)

option(ZLIB_USE_ASM686 "Enable building i686 assembly implementation" OFF)
option(ZLIB_USE_AMD64 "Enable building amd64 assembly implementation" OFF)

mark_as_advanced(ZLIB_USE_ASM686 ZLIB_USE_AMD64)

include(CheckTypeSize)
include(CheckFunctionExists)
include(CheckIncludeFile)
include(CheckCSourceCompiles)

#
# Check to see if we have large file support
#
check_include_file(sys/types.h HAVE_SYS_TYPES_H)
check_include_file(stdint.h HAVE_STDINT_H)
check_include_file(stddef.h HAVE_STDDEF_H)

if(HAVE_SYS_TYPES_H)
  list(APPEND PRIVATE_DEFINITIONS -DHAVE_SYS_TYPES_H)
endif()
if(HAVE_STDINT_H)
  list(APPEND PRIVATE_DEFINITIONS -DHAVE_STDINT_H)
endif()
if(HAVE_STDDEF_H)
  list(APPEND PRIVATE_DEFINITIONS -DHAVE_STDDEF_H)
endif()

check_type_size(off64_t OFF64_T)
if(HAVE_OFF64_T)
  list(APPEND PRIVATE_DEFINITIONS -D_LARGEFILE64_SOURCE=1)
endif()

#
# Check for fseeko
#
check_function_exists(fseeko HAVE_FSEEKO)
if(NOT HAVE_FSEEKO)
  list(APPEND PRIVATE_DEFINITIONS -DNO_FSEEKO)
endif()

#
# Check for unistd.h
#
check_include_file(unistd.h Z_HAVE_UNISTD_H)

# Visual studio options
if(MSVC)
  set(CMAKE_DEBUG_POSTFIX "d")
  list(APPEND PRIVATE_DEFINITIONS -D_CRT_SECURE_NO_DEPRECATE) # Disable warnings
                                                              # for unsecure CRT
                                                              # functions
  list(APPEND PRIVATE_DEFINITIONS -D_CRT_NONSTDC_NO_DEPRECATE) # Disable
                                                               # warnings for
                                                               # POSIX
                                                               # deprecated
                                                               # functions
endif()

set(ZLIB_PC zlib.pc)
configure_file(${ZLIB_SOURCE_DIR}/zlib.pc.cmakein ${ZLIB_PC} @ONLY)
configure_file(${ZLIB_SOURCE_DIR}/zconf.h.cmakein zconf.h @ONLY)
configure_file(${ZLIB_SOURCE_DIR}/zlib.h zlib.h COPYONLY)

# ============================================================================
# zlib
# ============================================================================

set(ZLIB_PUBLIC_HDRS ${CMAKE_CURRENT_BINARY_DIR}/zconf.h
                     ${CMAKE_CURRENT_BINARY_DIR}/zlib.h)

set(ZLIB_PRIVATE_HDRS
    ${ZLIB_SOURCE_DIR}/crc32.h
    ${ZLIB_SOURCE_DIR}/deflate.h
    ${ZLIB_SOURCE_DIR}/gzguts.h
    ${ZLIB_SOURCE_DIR}/inffast.h
    ${ZLIB_SOURCE_DIR}/inffixed.h
    ${ZLIB_SOURCE_DIR}/inflate.h
    ${ZLIB_SOURCE_DIR}/inftrees.h
    ${ZLIB_SOURCE_DIR}/trees.h
    ${ZLIB_SOURCE_DIR}/zutil.h)

set(ZLIB_SRCS
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
    ${ZLIB_SOURCE_DIR}/zutil.c)

if(NOT MINGW)
  set(ZLIB_DLL_SRCS
      ${ZLIB_SOURCE_DIR}/win32/zlib1.rc # If present will override custom build
                                        # rule below.
  )
endif()

if(CMAKE_COMPILER_IS_GNUCC)
  if(ZLIB_USE_ASM686)
    set(ZLIB_ASMS ${ZLIB_SOURCE_DIR}/contrib/asm686/match.S)
  elseif(ZLIB_USE_AMD64)
    set(ZLIB_ASMS ${ZLIB_SOURCE_DIR}/contrib/amd64/amd64-match.S)
  endif()

  if(ZLIB_ASMS)
    list(APPEND PRIVATE_DEFINITIONS -DASMV)
    set_source_files_properties(
      ${ZLIB_ASMS} PROPERTIES LANGUAGE C COMPILE_FLAGS -DNO_UNDERLINE)
  endif()
endif()

if(MSVC)
  if(ZLIB_USE_ASM686)
    enable_language(ASM_MASM)
    set(ZLIB_ASMS ${ZLIB_SOURCE_DIR}/contrib/masmx86/inffas32.asm
                  ${ZLIB_SOURCE_DIR}/contrib/masmx86/match686.asm)
  elseif(ZLIB_USE_AMD64)
    enable_language(ASM_MASM)
    set(ZLIB_ASMS ${ZLIB_SOURCE_DIR}/contrib/masmx64/gvmat64.asm
                  ${ZLIB_SOURCE_DIR}/contrib/masmx64/inffasx64.asm)

    list(APPEND ZLIB_SRCS ${ZLIB_SOURCE_DIR}/contrib/masmx64/inffas8664.c)
  endif()

  if(ZLIB_ASMS)
    list(APPEND PRIVATE_DEFINITIONS -DASMV -DASMINF)
  endif()
endif()

if(MINGW)
  # This gets us DLL resource information when compiling on MinGW.
  if(NOT CMAKE_RC_COMPILER)
    set(CMAKE_RC_COMPILER windres.exe)
  endif()

  add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/zlib1rc.obj
    COMMAND
      ${CMAKE_RC_COMPILER} -D GCC_WINDRES -I ${ZLIB_SOURCE_DIR} -I
      ${CMAKE_CURRENT_BINARY_DIR} -o ${CMAKE_CURRENT_BINARY_DIR}/zlib1rc.obj -i
      ${ZLIB_SOURCE_DIR}/win32/zlib1.rc)
  set(ZLIB_DLL_SRCS ${CMAKE_CURRENT_BINARY_DIR}/zlib1rc.obj)
endif(MINGW)

add_library(zlib SHARED ${ZLIB_SRCS} ${ZLIB_ASMS} ${ZLIB_DLL_SRCS}
                        ${ZLIB_PUBLIC_HDRS} ${ZLIB_PRIVATE_HDRS})

# Dependent include files
target_include_directories(
  zlib PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
              $<INSTALL_INTERFACE:include>)

target_compile_definitions(zlib PRIVATE ${PRIVATE_DEFINITIONS})

set_target_properties(zlib PROPERTIES DEFINE_SYMBOL ZLIB_DLL)
set_target_properties(zlib PROPERTIES SOVERSION 1)

if(NOT CYGWIN)
  # This property causes shared libraries on Linux to have the full version
  # encoded into their final filename.  We disable this on Cygwin because it
  # causes cygz-${ZLIB_FULL_VERSION}.dll to be created when cygz.dll seems to be
  # the default.
  #
  # This has no effect with MSVC, on that platform the version info for the DLL
  # comes from the resource file win32/zlib1.rc
  set_target_properties(zlib PROPERTIES ZLIB_VERSION ${ZLIB_FULL_VERSION})
endif()

if(UNIX)
  # On unix-like platforms the library is almost always called libz
  set_target_properties(zlib PROPERTIES OUTPUT_NAME z)
  if(NOT APPLE)
    set_target_properties(
      zlib PROPERTIES LINK_FLAGS
                      "-Wl,--version-script,\"${ZLIB_SOURCE_DIR}/zlib.map\"")
  endif()
elseif(BUILD_SHARED_LIBS AND WIN32)
  # Creates zlib1.dll when building shared library version
  set_target_properties(zlib PROPERTIES SUFFIX "1.dll")
endif()

if(MINGW)
  # Static library name
  set_target_properties(zlib PROPERTIES IMPORT_PREFIX "")
  set_target_properties(zlib PROPERTIES IMPORT_SUFFIX "1.a")
  # Shared library name
  set_target_properties(zlib PROPERTIES PREFIX "")
  set_target_properties(zlib PROPERTIES SUFFIX "1.dll")
endif()

install(
  TARGETS zlib
  EXPORT zlib_export
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(FILES ${ZLIB_PUBLIC_HDRS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
