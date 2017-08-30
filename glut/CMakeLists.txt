CMAKE_MINIMUM_REQUIRED(VERSION 3.5 FATAL_ERROR)

PROJECT(glut LANGUAGES C)

# Use GNUInstallDirs to install libraries into correct
# locations on all platforms.
INCLUDE(GNUInstallDirs)

OPTION(GLUT_BUILD_STATIC "Build static version of the GLUT library." OFF)
IF (${GLUT_BUILD_STATIC})
  MESSAGE(STATUS "WARNING: Static version of GLUT library will require\n changes of osgviewerGLUT projects runtime library\n from /MD to /MT to be able to link correctly.\n")
ENDIF()

MARK_AS_ADVANCED(GLUT_BUILD_STATIC)

SET(GLUT_PUBLIC_HEADERS
  ${GLUT_SOURCE_DIR}/include/GL/glut.h
)

SET(GLUT_SRCS
  ${GLUT_SOURCE_DIR}/lib/glut/glut_8x13.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_9x15.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_bitmap.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_bwidth.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_cindex.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_cmap.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_cursor.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_dials.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_dstr.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_event.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_ext.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_fbc.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_fullscrn.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_gamemode.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_get.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_glxext.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_hel10.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_hel12.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_hel18.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_init.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_input.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_joy.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_key.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_keyctrl.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_keyup.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_mesa.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_modifier.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_mroman.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_overlay.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_roman.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_shapes.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_space.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_stroke.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_swap.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_swidth.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_tablet.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_teapot.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_tr10.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_tr24.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_util.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_vidresize.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_warp.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_wglext.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_win.c
  ${GLUT_SOURCE_DIR}/lib/glut/glut_winmisc.c
  ${GLUT_SOURCE_DIR}/lib/glut/win32_glx.c
  ${GLUT_SOURCE_DIR}/lib/glut/win32_menu.c
  ${GLUT_SOURCE_DIR}/lib/glut/win32_util.c
  ${GLUT_SOURCE_DIR}/lib/glut/win32_winproc.c
  ${GLUT_SOURCE_DIR}/lib/glut/win32_x11.c
)

SET(GLUT_EXPORT_DEFINTIONS
  ${GLUT_SOURCE_DIR}/lib/glut/glut.def
)


IF(MSVC)
  LIST(APPEND PRIVATE_DEFINITIONS -D_CRT_SECURE_NO_WARNINGS) # Disable warnings for unsecure CRT functions
  IF (${GLUT_BUILD_STATIC})
    LIST(APPEND PRIVATE_OPTIONS $<$<CONFIG:Debug>:/MTd> $<$<CONFIG:Release>:/MT>) # Build static runtime library
  ELSE()
    LIST(APPEND PRIVATE_OPTIONS $<$<CONFIG:Debug>:/MDd> $<$<CONFIG:Release>:/MD>) # Build shared runtime library
  ENDIF()
  
  # Supress warnings
  LIST(APPEND PRIVATE_OPTIONS /wd4133) # type' : incompatible types - from 'type1' to 'type2'
  LIST(APPEND PRIVATE_OPTIONS /wd4554) # operator' : check operator precedence for possible error; use parentheses to clarify precedence
  LIST(APPEND PRIVATE_OPTIONS /wd4996) # The compiler encountered a deprecated declaration.
  LIST(APPEND PRIVATE_OPTIONS /wd4715) # function' : not all control paths return a value
  
  SET(CMAKE_DEBUG_POSTFIX "d")
ENDIF(MSVC)


IF(MINGW)
  LIST(APPEND PRIVATE_DEFINITIONS "-w") # 
ENDIF(MINGW)

IF (${GLUT_BUILD_STATIC})
  ADD_LIBRARY(glut32 STATIC ${GLUT_SRCS} ${GLUT_PUBLIC_HEADERS})
ELSE()
  ADD_LIBRARY(glut32 SHARED ${GLUT_SRCS} ${GLUT_PUBLIC_HEADERS} ${GLUT_EXPORT_DEFINTIONS})
ENDIF()

# Dependent include files
TARGET_INCLUDE_DIRECTORIES(glut32 PUBLIC 
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}> 
  $<BUILD_INTERFACE:${GLUT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:include>
  )

TARGET_COMPILE_DEFINITIONS(glut32
  PRIVATE ${PRIVATE_DEFINITIONS}
  )

  
TARGET_COMPILE_OPTIONS(glut32 
  PRIVATE ${PRIVATE_OPTIONS}
  )

IF(MSVC)
  IF (${GLUT_BUILD_STATIC})
    TARGET_LINK_LIBRARIES(glut32 winmm.lib)
  ELSE()
    TARGET_LINK_LIBRARIES(glut32 winmm.lib OpenGL32.lib GlU32.lib)
  ENDIF()
ENDIF(MSVC)


# INSTALL
INSTALL(TARGETS glut32 EXPORT glut32_export
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )

INSTALL(FILES 
  ${GLUT_PUBLIC_HEADERS} 
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/GL
  )

