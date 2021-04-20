cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(glut LANGUAGES C)

# Use GNUInstallDirs to install libraries into correct locations on all
# platforms.
include(GNUInstallDirs)

option(GLUT_BUILD_STATIC "Build static version of the GLUT library." OFF)
if(${GLUT_BUILD_STATIC})
  message(
    STATUS
      "WARNING: Static version of GLUT library will require\n changes of osgviewerGLUT projects runtime library\n from /MD to /MT to be able to link correctly.\n"
  )
endif()

mark_as_advanced(GLUT_BUILD_STATIC)

set(GLUT_PUBLIC_HEADERS ${GLUT_SOURCE_DIR}/include/GL/glut.h)

set(GLUT_SRCS
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
    ${GLUT_SOURCE_DIR}/lib/glut/win32_x11.c)

set(GLUT_EXPORT_DEFINTIONS ${GLUT_SOURCE_DIR}/lib/glut/glut.def)

if(MSVC)
  list(APPEND PRIVATE_DEFINITIONS -D_CRT_SECURE_NO_WARNINGS) # Disable warnings
                                                             # for unsecure CRT
                                                             # functions
  if(${GLUT_BUILD_STATIC})
    list(APPEND PRIVATE_OPTIONS $<$<CONFIG:Debug>:/MTd>
         $<$<CONFIG:Release>:/MT>) # Build static runtime library
  else()
    list(APPEND PRIVATE_OPTIONS $<$<CONFIG:Debug>:/MDd>
         $<$<CONFIG:Release>:/MD>) # Build shared runtime library
  endif()

  # Supress warnings
  list(APPEND PRIVATE_OPTIONS /wd4133) # type' : incompatible types - from
                                       # 'type1' to 'type2'
  list(APPEND PRIVATE_OPTIONS /wd4554) # operator' : check operator precedence
                                       # for possible error; use parentheses to
                                       # clarify precedence
  list(APPEND PRIVATE_OPTIONS /wd4996) # The compiler encountered a deprecated
                                       # declaration.
  list(APPEND PRIVATE_OPTIONS /wd4715) # function' : not all control paths
                                       # return a value

  set(CMAKE_DEBUG_POSTFIX "d")
endif(MSVC)

if(MINGW)
  list(APPEND PRIVATE_DEFINITIONS "-w") #
endif(MINGW)

if(${GLUT_BUILD_STATIC})
  add_library(glut32 STATIC ${GLUT_SRCS} ${GLUT_PUBLIC_HEADERS})
else()
  add_library(glut32 SHARED ${GLUT_SRCS} ${GLUT_PUBLIC_HEADERS}
                            ${GLUT_EXPORT_DEFINTIONS})
endif()

# Dependent include files
target_include_directories(
  glut32
  PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
         $<BUILD_INTERFACE:${GLUT_SOURCE_DIR}/include>
         $<INSTALL_INTERFACE:include>)

target_compile_definitions(glut32 PRIVATE ${PRIVATE_DEFINITIONS})

target_compile_options(glut32 PRIVATE ${PRIVATE_OPTIONS})

if(MSVC)
  if(${GLUT_BUILD_STATIC})
    target_link_libraries(glut32 winmm.lib)
  else()
    target_link_libraries(glut32 winmm.lib OpenGL32.lib GlU32.lib)
  endif()
endif(MSVC)

# INSTALL
install(
  TARGETS glut32
  EXPORT glut32_export
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(FILES ${GLUT_PUBLIC_HEADERS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/GL)
