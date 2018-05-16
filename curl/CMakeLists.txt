CMAKE_MINIMUM_REQUIRED(VERSION 3.5 FATAL_ERROR)

FILE(READ ${CURL_SOURCE_DIR}/include/curl/curlver.h _curlver_h_contents)
STRING(REGEX REPLACE ".*#define[ \t]+LIBCURL_VERSION_MAJOR[ \t]+([0-9]+).*" "\\1" LIBCURL_VERSION_MAJOR ${_curlver_h_contents})
STRING(REGEX REPLACE ".*#define[ \t]+LIBCURL_VERSION_MINOR[ \t]+([0-9]+).*" "\\1" LIBCURL_VERSION_MINOR ${_curlver_h_contents})
STRING(REGEX REPLACE ".*#define[ \t]+LIBCURL_VERSION_PATCH[ \t]+([0-9]+).*" "\\1" LIBCURL_VERSION_PATCH ${_curlver_h_contents})

PROJECT(curl VERSION "${LIBCURL_VERSION_MAJOR}.${LIBCURL_VERSION_MINOR}.${LIBCURL_VERSION_PATCH}" LANGUAGES C)


OPTION(ENABLE_IPV6 "Define if you want to enable IPv6 support" ON)
MARK_AS_ADVANCED(ENABLE_IPV6)

# On windows preload settings
IF(WIN32)
  LIST(APPEND CMAKE_REQUIRED_DEFINITIONS -D_WINSOCKAPI_=)
  INCLUDE(${CURL_SOURCE_DIR}/CMake/Platforms/WindowsCache.cmake)
ENDIF(WIN32)

SET(CURL_PUBLIC_HEADERS
  ${CURL_SOURCE_DIR}/include/curl/curl.h
  ${CURL_SOURCE_DIR}/include/curl/curlver.h
  ${CURL_SOURCE_DIR}/include/curl/easy.h
  ${CURL_SOURCE_DIR}/include/curl/multi.h
  ${CURL_SOURCE_DIR}/include/curl/system.h
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
  ${CURL_SOURCE_DIR}/lib/curl_ctype.c
  ${CURL_SOURCE_DIR}/lib/curl_des.c
  ${CURL_SOURCE_DIR}/lib/curl_endian.c
  ${CURL_SOURCE_DIR}/lib/curl_fnmatch.c
  ${CURL_SOURCE_DIR}/lib/curl_gethostname.c
  ${CURL_SOURCE_DIR}/lib/curl_gssapi.c
  ${CURL_SOURCE_DIR}/lib/curl_memrchr.c
  ${CURL_SOURCE_DIR}/lib/curl_multibyte.c
  ${CURL_SOURCE_DIR}/lib/curl_ntlm_core.c
  ${CURL_SOURCE_DIR}/lib/curl_ntlm_wb.c
  ${CURL_SOURCE_DIR}/lib/curl_path.c
  ${CURL_SOURCE_DIR}/lib/curl_range.c
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
  ${CURL_SOURCE_DIR}/lib/http_chunks.c
  ${CURL_SOURCE_DIR}/lib/http_digest.c
  ${CURL_SOURCE_DIR}/lib/http_negotiate.c
  ${CURL_SOURCE_DIR}/lib/http_ntlm.c
  ${CURL_SOURCE_DIR}/lib/http_proxy.c
  ${CURL_SOURCE_DIR}/lib/http2.c
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
  ${CURL_SOURCE_DIR}/lib/mime.c
  ${CURL_SOURCE_DIR}/lib/mprintf.c
  ${CURL_SOURCE_DIR}/lib/multi.c
  ${CURL_SOURCE_DIR}/lib/netrc.c
  ${CURL_SOURCE_DIR}/lib/non-ascii.c
  ${CURL_SOURCE_DIR}/lib/nonblock.c
  ${CURL_SOURCE_DIR}/lib/openldap.c
  ${CURL_SOURCE_DIR}/lib/parsedate.c
  ${CURL_SOURCE_DIR}/lib/pingpong.c
  ${CURL_SOURCE_DIR}/lib/pipeline.c
  ${CURL_SOURCE_DIR}/lib/pop3.c
  ${CURL_SOURCE_DIR}/lib/progress.c
  ${CURL_SOURCE_DIR}/lib/rand.c
  ${CURL_SOURCE_DIR}/lib/rtsp.c
  ${CURL_SOURCE_DIR}/lib/security.c
  ${CURL_SOURCE_DIR}/lib/select.c
  ${CURL_SOURCE_DIR}/lib/sendf.c
  ${CURL_SOURCE_DIR}/lib/setopt.c
  ${CURL_SOURCE_DIR}/lib/sha256.c
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
  ${CURL_SOURCE_DIR}/lib/ssh-libssh.c
  ${CURL_SOURCE_DIR}/lib/strcase.c
  ${CURL_SOURCE_DIR}/lib/strdup.c
  ${CURL_SOURCE_DIR}/lib/strerror.c
  ${CURL_SOURCE_DIR}/lib/strtok.c
  ${CURL_SOURCE_DIR}/lib/strtoofft.c
  ${CURL_SOURCE_DIR}/lib/system_win32.c
  ${CURL_SOURCE_DIR}/lib/telnet.c
  ${CURL_SOURCE_DIR}/lib/tftp.c
  ${CURL_SOURCE_DIR}/lib/timeval.c
  ${CURL_SOURCE_DIR}/lib/transfer.c
  ${CURL_SOURCE_DIR}/lib/url.c
  ${CURL_SOURCE_DIR}/lib/warnless.c
  ${CURL_SOURCE_DIR}/lib/version.c
  ${CURL_SOURCE_DIR}/lib/wildcard.c
  ${CURL_SOURCE_DIR}/lib/x509asn1.c

  ${CURL_SOURCE_DIR}/lib/vauth/cleartext.c
  ${CURL_SOURCE_DIR}/lib/vauth/cram.c
  ${CURL_SOURCE_DIR}/lib/vauth/digest.c
  ${CURL_SOURCE_DIR}/lib/vauth/digest_sspi.c
  ${CURL_SOURCE_DIR}/lib/vauth/krb5_gssapi.c
  ${CURL_SOURCE_DIR}/lib/vauth/krb5_sspi.c
  ${CURL_SOURCE_DIR}/lib/vauth/ntlm.c
  ${CURL_SOURCE_DIR}/lib/vauth/ntlm_sspi.c
  ${CURL_SOURCE_DIR}/lib/vauth/oauth2.c
  ${CURL_SOURCE_DIR}/lib/vauth/spnego_gssapi.c
  ${CURL_SOURCE_DIR}/lib/vauth/spnego_sspi.c
  ${CURL_SOURCE_DIR}/lib/vauth/vauth.c
  ${CURL_SOURCE_DIR}/lib/vtls/axtls.c
  ${CURL_SOURCE_DIR}/lib/vtls/cyassl.c
  ${CURL_SOURCE_DIR}/lib/vtls/darwinssl.c
  ${CURL_SOURCE_DIR}/lib/vtls/gskit.c
  ${CURL_SOURCE_DIR}/lib/vtls/gtls.c
  ${CURL_SOURCE_DIR}/lib/vtls/mbedtls.c
  ${CURL_SOURCE_DIR}/lib/vtls/nss.c
  ${CURL_SOURCE_DIR}/lib/vtls/openssl.c
  ${CURL_SOURCE_DIR}/lib/vtls/polarssl.c
  ${CURL_SOURCE_DIR}/lib/vtls/polarssl_threadlock.c
  ${CURL_SOURCE_DIR}/lib/vtls/schannel.c
  ${CURL_SOURCE_DIR}/lib/vtls/schannel_verify.c
  ${CURL_SOURCE_DIR}/lib/vtls/vtls.c

)


LIST(APPEND PRIVATE_DEFINITIONS -DBUILDING_LIBCURL)
LIST(APPEND PRIVATE_DEFINITIONS -DUSE_WIN32_LDAP)

IF(MSVC)
  LIST(APPEND PRIVATE_DEFINITIONS -D_CRT_SECURE_NO_WARNINGS) # Disable warnings for unsecure CRT functions
  
  # Disable warnings
  LIST(APPEND PRIVATE_OPTIONS /wd4133) # type' : incompatible types - from 'type1' to 'type2'
  LIST(APPEND PRIVATE_OPTIONS /wd4554) # operator' : check operator precedence for possible error; use parentheses to clarify precedence
  LIST(APPEND PRIVATE_OPTIONS /wd4996) # The compiler encountered a deprecated declaration.
  LIST(APPEND PRIVATE_OPTIONS /wd4715) # function' : not all control paths return a value
  
  SET(CMAKE_DEBUG_POSTFIX "d")
ENDIF(MSVC)

IF(MINGW)
  LIST(APPEND PRIVATE_OPTIONS -w)
ENDIF(MINGW)

ADD_LIBRARY(libcurl SHARED ${CURL_SRCS} ${CURL_PUBLIC_HEADERS} ${CURL_PRIVATE_HEADERS})

# Dependent include files
TARGET_INCLUDE_DIRECTORIES(libcurl PUBLIC 
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}> 
  $<INSTALL_INTERFACE:include>
  )
  
TARGET_INCLUDE_DIRECTORIES(libcurl PRIVATE 
  ${CURL_SOURCE_DIR}/include
  ${CURL_SOURCE_DIR}/lib
  )

TARGET_COMPILE_DEFINITIONS(libcurl
  PRIVATE ${PRIVATE_DEFINITIONS}
  )
  
TARGET_COMPILE_OPTIONS(libcurl 
  PRIVATE ${PRIVATE_OPTIONS}
  )
  

IF(MSVC)
  TARGET_LINK_LIBRARIES(libcurl ws2_32.lib  wldap32.lib)
ENDIF(MSVC)

# INSTALL
INSTALL(TARGETS libcurl EXPORT libcurl_export
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )

INSTALL(FILES 
  ${CURL_PUBLIC_HEADERS} 
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/curl
  )