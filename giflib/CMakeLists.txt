CMAKE_MINIMUM_REQUIRED(VERSION 3.5 FATAL_ERROR)

FILE(READ ${GIFLIB_SOURCE_DIR}/lib/gif_lib.h _gif_lib_h_contents)
STRING(REGEX REPLACE ".*#define[ \t]+GIFLIB_MAJOR[ \t]+([0-9]+).*" "\\1" GIFLIB_MAJOR_VERSION ${_gif_lib_h_contents})
STRING(REGEX REPLACE ".*#define[ \t]+GIFLIB_MINOR[ \t]+([0-9]+).*" "\\1" GIFLIB_MINOR_VERSION ${_gif_lib_h_contents})
STRING(REGEX REPLACE ".*#define[ \t]+GIFLIB_RELEASE[ \t]+([0-9]+).*" "\\1" GIFLIB_RELEASE_VERSION ${_gif_lib_h_contents})

PROJECT(giflib VERSION "${GIFLIB_MAJOR_VERSION}.${GIFLIB_MINOR_VERSION}.${GIFLIB_RELEASE_VERSION}" LANGUAGES C)


# Use GNUInstallDirs to install libraries into correct
# locations on all platforms.
INCLUDE(GNUInstallDirs)


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
  ${GIFLIB_SOURCE_DIR}/lib/openbsd-reallocarray.c
  )

IF(MSVC)
  # Create file to avoid include file name collision on other platforms
  CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/unistd.h.in unistd.h @ONLY)  

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

IF(MSVC)
  LIST(APPEND PRIVATE_DEFINITIONS -D_CRT_SECURE_NO_WARNINGS) # Disable warnings for unsecure CRT functions
  LIST(APPEND PRIVATE_DEFINITIONS -D_LIB) # 
  LIST(APPEND PRIVATE_DEFINITIONS -DWIN32) # 
  
  # Supress warnings
  LIST(APPEND PRIVATE_OPTIONS /wd4018) # expression' : signed/unsigned mismatch
  LIST(APPEND PRIVATE_OPTIONS /wd4028) # formal parameter 'number' different from declaration
  LIST(APPEND PRIVATE_OPTIONS /wd4244) # conversion' conversion from 'type1' to 'type2', possible loss of data
  LIST(APPEND PRIVATE_OPTIONS /wd4996) # The compiler encountered a deprecated declaration.
  
  
  SET(CMAKE_DEBUG_POSTFIX "d")
ENDIF(MSVC)


IF(MINGW)
  LIST(APPEND PRIVATE_DEFINITIONS -D_CRT_SECURE_NO_WARNINGS) # Disable warnings for unsecure CRT functions
  LIST(APPEND PRIVATE_DEFINITIONS -D_LIB) # 
ENDIF(MINGW)

ADD_LIBRARY(giflib STATIC ${GIFLIB_SRCS} ${GIFLIB_PUBLIC_HEADERS} ${GIFLIB_PRIVATE_HEADERS})

# Dependent include files
TARGET_INCLUDE_DIRECTORIES(giflib PUBLIC 
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}> 
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
  $<INSTALL_INTERFACE:include>
  )

TARGET_COMPILE_DEFINITIONS(giflib
  PRIVATE ${PRIVATE_DEFINITIONS}
  )

  
TARGET_COMPILE_OPTIONS(giflib 
  PRIVATE ${PRIVATE_OPTIONS}
  )

IF(MINGW)
  SET_TARGET_PROPERTIES(${TARGET_LIB} PROPERTIES OUTPUT_NAME gif)
ENDIF()


# INSTALL
INSTALL(TARGETS giflib EXPORT giflib_export
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )

INSTALL(FILES 
  ${GIFLIB_PUBLIC_HEADERS} 
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )


