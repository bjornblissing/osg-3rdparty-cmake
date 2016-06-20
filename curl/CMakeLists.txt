PROJECT(curl C)

SET(TARGET_LIB libcurl)


SET(CURL_PUBLIC_HEADERS
  ${CURL_SOURCE_DIR}/include/curl/curl.h
  ${CURL_SOURCE_DIR}/include/curl/curlbuild.h
  ${CURL_SOURCE_DIR}/include/curl/easy.h
  ${CURL_SOURCE_DIR}/include/curl/curlver.h
  ${CURL_SOURCE_DIR}/include/curl/curlrules.h
  ${CURL_SOURCE_DIR}/include/curl/multi.h
)
SET(CURL_PRIVATE_HEADERS
)
SET(CURL_SRCS
  ${CURL_SOURCE_DIR}/lib/amigaos.c
  ${CURL_SOURCE_DIR}/lib/asyn-ares.c
  ${CURL_SOURCE_DIR}/lib/asyn-thread.c
  ${CURL_SOURCE_DIR}/lib/base64.c
  ${CURL_SOURCE_DIR}/lib/conncache.c
  ${CURL_SOURCE_DIR}/lib/connect.c
  ${CURL_SOURCE_DIR}/lib/content_encoding.c
  ${CURL_SOURCE_DIR}/lib/cookie.c
  ${CURL_SOURCE_DIR}/lib/curl_addrinfo.c
  ${CURL_SOURCE_DIR}/lib/curl_des.c
  ${CURL_SOURCE_DIR}/lib/curl_endian.c
  ${CURL_SOURCE_DIR}/lib/curl_fnmatch.c
  ${CURL_SOURCE_DIR}/lib/curl_gethostname.c
  ${CURL_SOURCE_DIR}/lib/curl_gssapi.c
  ${CURL_SOURCE_DIR}/lib/curl_memrchr.c
  ${CURL_SOURCE_DIR}/lib/curl_multibyte.c
  ${CURL_SOURCE_DIR}/lib/curl_ntlm_core.c
  ${CURL_SOURCE_DIR}/lib/curl_ntlm_wb.c
  ${CURL_SOURCE_DIR}/lib/curl_rtmp.c
  ${CURL_SOURCE_DIR}/lib/curl_sasl.c
  ${CURL_SOURCE_DIR}/lib/curl_sspi.c
  ${CURL_SOURCE_DIR}/lib/curl_threads.c
  ${CURL_SOURCE_DIR}/lib/dict.c
  ${CURL_SOURCE_DIR}/lib/dotdot.c
  ${CURL_SOURCE_DIR}/lib/easy.c
  ${CURL_SOURCE_DIR}/lib/escape.c
  ${CURL_SOURCE_DIR}/lib/file.c
  ${CURL_SOURCE_DIR}/lib/fileinfo.c
  ${CURL_SOURCE_DIR}/lib/formdata.c
  ${CURL_SOURCE_DIR}/lib/ftp.c
  ${CURL_SOURCE_DIR}/lib/ftplistparser.c
  ${CURL_SOURCE_DIR}/lib/getenv.c
  ${CURL_SOURCE_DIR}/lib/getinfo.c
  ${CURL_SOURCE_DIR}/lib/gopher.c
  ${CURL_SOURCE_DIR}/lib/hash.c
  ${CURL_SOURCE_DIR}/lib/hmac.c
  ${CURL_SOURCE_DIR}/lib/hostasyn.c
  ${CURL_SOURCE_DIR}/lib/hostcheck.c
  ${CURL_SOURCE_DIR}/lib/hostip.c
  ${CURL_SOURCE_DIR}/lib/hostip4.c
  ${CURL_SOURCE_DIR}/lib/hostip6.c
  ${CURL_SOURCE_DIR}/lib/hostsyn.c
  ${CURL_SOURCE_DIR}/lib/http.c
  ${CURL_SOURCE_DIR}/lib/http2.c
  ${CURL_SOURCE_DIR}/lib/http_chunks.c
  ${CURL_SOURCE_DIR}/lib/http_digest.c
  ${CURL_SOURCE_DIR}/lib/http_ntlm.c
  ${CURL_SOURCE_DIR}/lib/http_negotiate.c
  ${CURL_SOURCE_DIR}/lib/http_proxy.c
  ${CURL_SOURCE_DIR}/lib/idn_win32.c
  ${CURL_SOURCE_DIR}/lib/if2ip.c
  ${CURL_SOURCE_DIR}/lib/imap.c
  ${CURL_SOURCE_DIR}/lib/inet_ntop.c
  ${CURL_SOURCE_DIR}/lib/inet_pton.c
  ${CURL_SOURCE_DIR}/lib/krb5.c
  ${CURL_SOURCE_DIR}/lib/ldap.c
  ${CURL_SOURCE_DIR}/lib/llist.c
  ${CURL_SOURCE_DIR}/lib/md4.c
  ${CURL_SOURCE_DIR}/lib/md5.c
  ${CURL_SOURCE_DIR}/lib/memdebug.c
  ${CURL_SOURCE_DIR}/lib/mprintf.c
  ${CURL_SOURCE_DIR}/lib/multi.c
  ${CURL_SOURCE_DIR}/lib/netrc.c
  ${CURL_SOURCE_DIR}/lib/non-ascii.c
  ${CURL_SOURCE_DIR}/lib/nonblock.c
  ${CURL_SOURCE_DIR}/lib/nwlib.c
  ${CURL_SOURCE_DIR}/lib/nwos.c
  ${CURL_SOURCE_DIR}/lib/openldap.c
  ${CURL_SOURCE_DIR}/lib/parsedate.c
  ${CURL_SOURCE_DIR}/lib/pingpong.c
  ${CURL_SOURCE_DIR}/lib/pipeline.c
  ${CURL_SOURCE_DIR}/lib/pop3.c
  ${CURL_SOURCE_DIR}/lib/progress.c
  ${CURL_SOURCE_DIR}/lib/rawstr.c
  ${CURL_SOURCE_DIR}/lib/rtsp.c
  ${CURL_SOURCE_DIR}/lib/security.c
  ${CURL_SOURCE_DIR}/lib/select.c
  ${CURL_SOURCE_DIR}/lib/sendf.c
  ${CURL_SOURCE_DIR}/lib/share.c
  ${CURL_SOURCE_DIR}/lib/slist.c
  ${CURL_SOURCE_DIR}/lib/smb.c
  ${CURL_SOURCE_DIR}/lib/smtp.c
  ${CURL_SOURCE_DIR}/lib/socks.c
  ${CURL_SOURCE_DIR}/lib/socks_gssapi.c
  ${CURL_SOURCE_DIR}/lib/socks_sspi.c
  ${CURL_SOURCE_DIR}/lib/speedcheck.c
  ${CURL_SOURCE_DIR}/lib/splay.c
  ${CURL_SOURCE_DIR}/lib/ssh.c
  ${CURL_SOURCE_DIR}/lib/strdup.c
  ${CURL_SOURCE_DIR}/lib/strequal.c
  ${CURL_SOURCE_DIR}/lib/strerror.c
  ${CURL_SOURCE_DIR}/lib/strtok.c
  ${CURL_SOURCE_DIR}/lib/strtoofft.c
  ${CURL_SOURCE_DIR}/lib/system_win32.c
  ${CURL_SOURCE_DIR}/lib/telnet.c
  ${CURL_SOURCE_DIR}/lib/tftp.c
  ${CURL_SOURCE_DIR}/lib/timeval.c
  ${CURL_SOURCE_DIR}/lib/transfer.c
  ${CURL_SOURCE_DIR}/lib/url.c
  ${CURL_SOURCE_DIR}/lib/version.c
  ${CURL_SOURCE_DIR}/lib/warnless.c
  ${CURL_SOURCE_DIR}/lib/wildcard.c
  ${CURL_SOURCE_DIR}/lib/x509asn1.c
  ${CURL_SOURCE_DIR}/lib/vauth/cleartext.c
  ${CURL_SOURCE_DIR}/lib/vauth/cram.c
  ${CURL_SOURCE_DIR}/lib/vauth/digest.c
  ${CURL_SOURCE_DIR}/lib/vauth/digest_sspi.c
  ${CURL_SOURCE_DIR}/lib/vauth/krb5_gssapi.c
  ${CURL_SOURCE_DIR}/lib/vauth/ntlm.c
  ${CURL_SOURCE_DIR}/lib/vauth/ntlm_sspi.c
  ${CURL_SOURCE_DIR}/lib/vauth/oauth2.c
  ${CURL_SOURCE_DIR}/lib/vauth/spnego_gssapi.c
  ${CURL_SOURCE_DIR}/lib/vauth/spnego_sspi.c
  ${CURL_SOURCE_DIR}/lib/vauth/vauth.c
  ${CURL_SOURCE_DIR}/lib/vtls/vtls.c
)

# Dependent include files
INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_BINARY_DIR})

ADD_DEFINITIONS(-DBUILDING_LIBCURL -DUSE_WIN32_LDAP)

IF(MSVC)
  SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /wd4133 /wd4554 /wd4996 /wd4715")
  ADD_DEFINITIONS(-D_CRT_SECURE_NO_WARNINGS)
  SET(CMAKE_DEBUG_POSTFIX "d")
ENDIF(MSVC)

IF(MINGW)
  SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -w")
ENDIF(MINGW)

ADD_LIBRARY(${TARGET_LIB} SHARED ${CURL_SRCS} ${CURL_PUBLIC_HEADERS} ${CURL_PRIVATE_HEADERS})

TARGET_INCLUDE_DIRECTORIES(${TARGET_LIB} PRIVATE ${CURL_SOURCE_DIR}/include)
TARGET_INCLUDE_DIRECTORIES(${TARGET_LIB} PRIVATE ${CURL_SOURCE_DIR}/lib)

IF(MSVC)
  TARGET_LINK_LIBRARIES(${TARGET_LIB} ws2_32.lib  wldap32.lib)
ENDIF(MSVC)

# Runtime equals DLL-files
# Archive equals static libraries
# Library equals module libraries
IF(NOT SKIP_INSTALL_LIBRARIES AND NOT SKIP_INSTALL_ALL )
  INSTALL(TARGETS ${TARGET_LIB}
    RUNTIME DESTINATION ${EXECUTABLE_OUTPUT_PATH}
    LIBRARY DESTINATION ${LIBRARY_OUTPUT_PATH}
    ARCHIVE DESTINATION ${ARCHIVE_OUTPUT_PATH})
ENDIF()
IF(NOT SKIP_INSTALL_HEADERS AND NOT SKIP_INSTALL_ALL )
  INSTALL(FILES ${CURL_PUBLIC_HEADERS} DESTINATION ${INCLUDE_OUTPUT_PATH}/curl)
ENDIF()
