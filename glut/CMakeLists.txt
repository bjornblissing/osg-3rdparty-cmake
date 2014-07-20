PROJECT(glut C)

SET(TARGET_LIB glut)


SET(GLUT_PUBLIC_HEADERS
	${GLUT_SOURCE_DIR}/include/GL/glut.h
)
SET(GLUT_PRIVATE_HEADERS
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
	${GLUT_SOURCE_DIR}/lib/glut/glut_fullscrn.c
	${GLUT_SOURCE_DIR}/lib/glut/glut_gamemode.c
	${GLUT_SOURCE_DIR}/lib/glut/glut_get.c
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
	${GLUT_SOURCE_DIR}/lib/glut/glut_win.c
	${GLUT_SOURCE_DIR}/lib/glut/glut_winmisc.c
	${GLUT_SOURCE_DIR}/lib/glut/win32_glx.c
	${GLUT_SOURCE_DIR}/lib/glut/win32_menu.c
	${GLUT_SOURCE_DIR}/lib/glut/win32_util.c
	${GLUT_SOURCE_DIR}/lib/glut/win32_winproc.c
	${GLUT_SOURCE_DIR}/lib/glut/win32_x11.c
)

# Dependent include files
INCLUDE_DIRECTORIES(${GLUT_SOURCE_DIR}/include ${CMAKE_CURRENT_BINARY_DIR})

IF(MSVC)
	SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /wd4133 /wd4554 /wd4996 /wd4715")
	ADD_DEFINITIONS(-D_CRT_SECURE_NO_WARNINGS)
	SET(CMAKE_DEBUG_POSTFIX "d")
ENDIF(MSVC)

IF(MINGW)
	SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -w")
ENDIF(MINGW)

ADD_LIBRARY(${TARGET_LIB} STATIC ${GLUT_SRCS} ${GLUT_PRIVATE_HEADERS} ${GLUT_PUBLIC_HEADERS})

IF(MSVC)
	TARGET_LINK_LIBRARIES(${TARGET_LIB} winmm.lib )
ENDIF(MSVC)

# Runtime equals DLL-files
# Archive equals static libraries
# Library equals module libraries
IF(NOT SKIP_INSTALL_LIBRARIES AND NOT SKIP_INSTALL_ALL )
	install(TARGETS ${TARGET_LIB}
		RUNTIME DESTINATION ${EXECUTABLE_OUTPUT_PATH}
		LIBRARY DESTINATION ${LIBRARY_OUTPUT_PATH}
		ARCHIVE DESTINATION ${ARCHIVE_OUTPUT_PATH})
ENDIF()
IF(NOT SKIP_INSTALL_HEADERS AND NOT SKIP_INSTALL_ALL )
	install(FILES ${GLUT_PUBLIC_HEADERS} DESTINATION ${INCLUDE_OUTPUT_PATH}/GL)
ENDIF()

