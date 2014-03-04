PROJECT(jpeg C)

SET(TARGET_LIB jpeg)

SET(LIBJPEG_VERSION "9A")

IF(MSVC)
	SET(jconfig "jconfig.vc")
ENDIF()

CONFIGURE_FILE(${jconfig} jconfig.h @ONLY)

SET(LIBJPEG_PUBLIC_HEADERS
	${CMAKE_CURRENT_BINARY_DIR}/jconfig.h
	jerror.h
	jmorecfg.h
	jpeglib.h
)
SET(LIBJPEG_PRIVATE_HEADERS
	jdct.h
	jinclude.h
	jmemsys.h
	jpegint.h
	jversion.h
)
SET(LIBJPEG_SRCS
	jaricom.c 
	jcapimin.c 
	jcapistd.c 
	jcarith.c 
	jccoefct.c 
	jccolor.c 
	jcdctmgr.c 
	jchuff.c 
	jcinit.c 
	jcmainct.c 
	jcmarker.c 
	jcmaster.c 
	jcomapi.c 
	jcparam.c 
	jcprepct.c 
	jcsample.c 
	jctrans.c 
	jdapimin.c 
	jdapistd.c 
	jdarith.c 
	jdatadst.c 
	jdatasrc.c 
	jdcoefct.c 
	jdcolor.c 
	jddctmgr.c 
	jdhuff.c 
	jdinput.c 
	jdmainct.c 
	jdmarker.c 
	jdmaster.c 
	jdmerge.c 
	jdpostct.c 
	jdsample.c 
	jdtrans.c 
	jerror.c 
	jfdctflt.c 
	jfdctfst.c 
	jfdctint.c 
	jidctflt.c 
	jidctfst.c 
	jidctint.c 
	jmemmgr.c 
	jmemnobs.c 
	jquant1.c 
	jquant2.c 
)

# Dependent include files
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})

IF(MSVC)
	SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /Gy")
	ADD_DEFINITIONS(-D_CRT_SECURE_NO_WARNINGS -D_LIB)
	SET(CMAKE_DEBUG_POSTFIX "d")
ENDIF(MSVC)

ADD_LIBRARY(${TARGET_LIB} STATIC ${LIBJPEG_SRCS} ${LIBJPEG_PRIVATE_HEADERS} ${LIBJPEG_PUBLIC_HEADERS})

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
	install(FILES ${LIBJPEG_PUBLIC_HEADERS} DESTINATION ${INCLUDE_OUTPUT_PATH})
ENDIF()

