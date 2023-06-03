cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

file(READ ${CURL_SOURCE_DIR}/include/curl/curlver.h _curlver_h_contents)
string(REGEX REPLACE ".*#define[ \t]+LIBCURL_VERSION_MAJOR[ \t]+([0-9]+).*"
                     "\\1" LIBCURL_VERSION_MAJOR ${_curlver_h_contents})
string(REGEX REPLACE ".*#define[ \t]+LIBCURL_VERSION_MINOR[ \t]+([0-9]+).*"
                     "\\1" LIBCURL_VERSION_MINOR ${_curlver_h_contents})
string(REGEX REPLACE ".*#define[ \t]+LIBCURL_VERSION_PATCH[ \t]+([0-9]+).*"
                     "\\1" LIBCURL_VERSION_PATCH ${_curlver_h_contents})

project(
  curl
  VERSION
    "${LIBCURL_VERSION_MAJOR}.${LIBCURL_VERSION_MINOR}.${LIBCURL_VERSION_PATCH}"
  LANGUAGES C)

option(ENABLE_IPV6 "Define if you want to enable IPv6 support" ON)
mark_as_advanced(ENABLE_IPV6)

# On windows preload settings
if(WIN32)
  list(APPEND CMAKE_REQUIRED_DEFINITIONS -D_WINSOCKAPI_=)
  include(${CURL_SOURCE_DIR}/CMake/Platforms/WindowsCache.cmake)
endif(WIN32)

set(CURL_PUBLIC_HEADERS
    ${CURL_SOURCE_DIR}/include/curl/curl.h
    ${CURL_SOURCE_DIR}/include/curl/curlver.h
    ${CURL_SOURCE_DIR}/include/curl/easy.h
    ${CURL_SOURCE_DIR}/include/curl/multi.h
    ${CURL_SOURCE_DIR}/include/curl/system.h
    ${CURL_SOURCE_DIR}/include/curl/mprintf.h
    ${CURL_SOURCE_DIR}/include/curl/options.h
    ${CURL_SOURCE_DIR}/include/curl/stdcheaders.h
    ${CURL_SOURCE_DIR}/include/curl/typecheck-gcc.h
    ${CURL_SOURCE_DIR}/include/curl/urlapi.h
)
set(CURL_PRIVATE_HEADERS
    ${CURL_SOURCE_DIR}/lib/altsvc.h
    ${CURL_SOURCE_DIR}/lib/amigaos.h
    ${CURL_SOURCE_DIR}/lib/arpa_telnet.h
    ${CURL_SOURCE_DIR}/lib/asyn.h
    ${CURL_SOURCE_DIR}/lib/c-hyper.h
    ${CURL_SOURCE_DIR}/lib/conncache.h
    ${CURL_SOURCE_DIR}/lib/connect.h
    ${CURL_SOURCE_DIR}/lib/content_encoding.h
    ${CURL_SOURCE_DIR}/lib/cookie.h
    ${CURL_SOURCE_DIR}/lib/curl_addrinfo.h
    ${CURL_SOURCE_DIR}/lib/curl_base64.h
    ${CURL_SOURCE_DIR}/lib/curl_ctype.h
    ${CURL_SOURCE_DIR}/lib/curl_des.h
    ${CURL_SOURCE_DIR}/lib/curl_endian.h
    ${CURL_SOURCE_DIR}/lib/curl_fnmatch.h
    ${CURL_SOURCE_DIR}/lib/curl_get_line.h
    ${CURL_SOURCE_DIR}/lib/curl_gethostname.h
    ${CURL_SOURCE_DIR}/lib/curl_gssapi.h
    ${CURL_SOURCE_DIR}/lib/curl_hmac.h
    ${CURL_SOURCE_DIR}/lib/curl_krb5.h
    ${CURL_SOURCE_DIR}/lib/curl_ldap.h
    ${CURL_SOURCE_DIR}/lib/curl_md4.h
    ${CURL_SOURCE_DIR}/lib/curl_md5.h
    ${CURL_SOURCE_DIR}/lib/curl_memory.h
    ${CURL_SOURCE_DIR}/lib/curl_memrchr.h
    ${CURL_SOURCE_DIR}/lib/curl_multibyte.h
    ${CURL_SOURCE_DIR}/lib/curl_ntlm_core.h
    ${CURL_SOURCE_DIR}/lib/curl_ntlm_wb.h
    ${CURL_SOURCE_DIR}/lib/curl_path.h
    ${CURL_SOURCE_DIR}/lib/curl_printf.h
    ${CURL_SOURCE_DIR}/lib/curl_range.h
    ${CURL_SOURCE_DIR}/lib/curl_rtmp.h
    ${CURL_SOURCE_DIR}/lib/curl_sasl.h
    ${CURL_SOURCE_DIR}/lib/curl_setup.h
    ${CURL_SOURCE_DIR}/lib/curl_setup_once.h
    ${CURL_SOURCE_DIR}/lib/curl_sha256.h
    ${CURL_SOURCE_DIR}/lib/curl_sspi.h
    ${CURL_SOURCE_DIR}/lib/curl_threads.h
    ${CURL_SOURCE_DIR}/lib/curlx.h
    ${CURL_SOURCE_DIR}/lib/dict.h
    ${CURL_SOURCE_DIR}/lib/doh.h
    ${CURL_SOURCE_DIR}/lib/dotdot.h
    ${CURL_SOURCE_DIR}/lib/dynbuf.h
    ${CURL_SOURCE_DIR}/lib/easyif.h
    ${CURL_SOURCE_DIR}/lib/easyoptions.h
    ${CURL_SOURCE_DIR}/lib/escape.h
    ${CURL_SOURCE_DIR}/lib/file.h
    ${CURL_SOURCE_DIR}/lib/fileinfo.h
    ${CURL_SOURCE_DIR}/lib/formdata.h
    ${CURL_SOURCE_DIR}/lib/ftp.h
    ${CURL_SOURCE_DIR}/lib/ftplistparser.h
    ${CURL_SOURCE_DIR}/lib/getinfo.h
    ${CURL_SOURCE_DIR}/lib/gopher.h
    ${CURL_SOURCE_DIR}/lib/hash.h
    ${CURL_SOURCE_DIR}/lib/hostcheck.h
    ${CURL_SOURCE_DIR}/lib/hostip.h
    ${CURL_SOURCE_DIR}/lib/hsts.h
    ${CURL_SOURCE_DIR}/lib/http.h
    ${CURL_SOURCE_DIR}/lib/http2.h
    ${CURL_SOURCE_DIR}/lib/http_chunks.h
    ${CURL_SOURCE_DIR}/lib/http_digest.h
    ${CURL_SOURCE_DIR}/lib/http_negotiate.h
    ${CURL_SOURCE_DIR}/lib/http_ntlm.h
    ${CURL_SOURCE_DIR}/lib/http_proxy.h
    ${CURL_SOURCE_DIR}/lib/http_aws_sigv4.h
    ${CURL_SOURCE_DIR}/lib/if2ip.h
    ${CURL_SOURCE_DIR}/lib/imap.h
    ${CURL_SOURCE_DIR}/lib/inet_ntop.h
    ${CURL_SOURCE_DIR}/lib/inet_pton.h
    ${CURL_SOURCE_DIR}/lib/llist.h
    ${CURL_SOURCE_DIR}/lib/memdebug.h
    ${CURL_SOURCE_DIR}/lib/mime.h
    ${CURL_SOURCE_DIR}/lib/mqtt.h
    ${CURL_SOURCE_DIR}/lib/multihandle.h
    ${CURL_SOURCE_DIR}/lib/multiif.h
    ${CURL_SOURCE_DIR}/lib/netrc.h
    ${CURL_SOURCE_DIR}/lib/non-ascii.h
    ${CURL_SOURCE_DIR}/lib/nonblock.h
    ${CURL_SOURCE_DIR}/lib/parsedate.h
    ${CURL_SOURCE_DIR}/lib/pingpong.h
    ${CURL_SOURCE_DIR}/lib/pop3.h
    ${CURL_SOURCE_DIR}/lib/progress.h
    ${CURL_SOURCE_DIR}/lib/psl.h
    ${CURL_SOURCE_DIR}/lib/quic.h
    ${CURL_SOURCE_DIR}/lib/rand.h
    ${CURL_SOURCE_DIR}/lib/rename.h
    ${CURL_SOURCE_DIR}/lib/rtsp.h
    ${CURL_SOURCE_DIR}/lib/select.h
    ${CURL_SOURCE_DIR}/lib/sendf.h
    ${CURL_SOURCE_DIR}/lib/setopt.h
    ${CURL_SOURCE_DIR}/lib/setup-vms.h
    ${CURL_SOURCE_DIR}/lib/share.h
    ${CURL_SOURCE_DIR}/lib/sigpipe.h
    ${CURL_SOURCE_DIR}/lib/slist.h
    ${CURL_SOURCE_DIR}/lib/smb.h
    ${CURL_SOURCE_DIR}/lib/smtp.h
    ${CURL_SOURCE_DIR}/lib/sockaddr.h
    ${CURL_SOURCE_DIR}/lib/socketpair.h
    ${CURL_SOURCE_DIR}/lib/socks.h
    ${CURL_SOURCE_DIR}/lib/speedcheck.h
    ${CURL_SOURCE_DIR}/lib/splay.h
    ${CURL_SOURCE_DIR}/lib/strcase.h
    ${CURL_SOURCE_DIR}/lib/strdup.h
    ${CURL_SOURCE_DIR}/lib/strerror.h
    ${CURL_SOURCE_DIR}/lib/strtok.h
    ${CURL_SOURCE_DIR}/lib/strtoofft.h
    ${CURL_SOURCE_DIR}/lib/system_win32.h
    ${CURL_SOURCE_DIR}/lib/telnet.h
    ${CURL_SOURCE_DIR}/lib/tftp.h
    ${CURL_SOURCE_DIR}/lib/timeval.h
    ${CURL_SOURCE_DIR}/lib/transfer.h
    ${CURL_SOURCE_DIR}/lib/url.h
    ${CURL_SOURCE_DIR}/lib/urlapi-int.h
    ${CURL_SOURCE_DIR}/lib/urldata.h
    ${CURL_SOURCE_DIR}/lib/version_win32.h
    ${CURL_SOURCE_DIR}/lib/warnless.h
    ${CURL_SOURCE_DIR}/lib/wildcard.h
    ${CURL_SOURCE_DIR}/lib/x509asn1.h
    ${CURL_SOURCE_DIR}/lib/vauth/digest.h
    ${CURL_SOURCE_DIR}/lib/vauth/ntlm.h
    ${CURL_SOURCE_DIR}/lib/vauth/vauth.h
    ${CURL_SOURCE_DIR}/lib/vtls/bearssl.h
    ${CURL_SOURCE_DIR}/lib/vtls/gskit.h
    ${CURL_SOURCE_DIR}/lib/vtls/gtls.h
    ${CURL_SOURCE_DIR}/lib/vtls/keylog.h
    ${CURL_SOURCE_DIR}/lib/vtls/mbedtls.h
    ${CURL_SOURCE_DIR}/lib/vtls/mbedtls_threadlock.h
    ${CURL_SOURCE_DIR}/lib/vtls/mesalink.h
    ${CURL_SOURCE_DIR}/lib/vtls/nssg.h
    ${CURL_SOURCE_DIR}/lib/vtls/openssl.h
    ${CURL_SOURCE_DIR}/lib/vtls/rustls.h
    ${CURL_SOURCE_DIR}/lib/vtls/schannel.h
    ${CURL_SOURCE_DIR}/lib/vtls/sectransp.h
    ${CURL_SOURCE_DIR}/lib/vtls/vtls.h
    ${CURL_SOURCE_DIR}/lib/vtls/wolfssl.h
    ${CURL_SOURCE_DIR}/lib/vquic/ngtcp2.h
    ${CURL_SOURCE_DIR}/lib/vquic/quiche.h
    ${CURL_SOURCE_DIR}/lib/vquic/vquic.h
    ${CURL_SOURCE_DIR}/lib/vssh/ssh.h)
set(CURL_SRCS
    ${CURL_SOURCE_DIR}/lib/altsvc.c
    ${CURL_SOURCE_DIR}/lib/amigaos.c
    ${CURL_SOURCE_DIR}/lib/asyn-ares.c
    ${CURL_SOURCE_DIR}/lib/asyn-thread.c
    ${CURL_SOURCE_DIR}/lib/base64.c
    ${CURL_SOURCE_DIR}/lib/c-hyper.c
    ${CURL_SOURCE_DIR}/lib/conncache.c
    ${CURL_SOURCE_DIR}/lib/connect.c
    ${CURL_SOURCE_DIR}/lib/content_encoding.c
    ${CURL_SOURCE_DIR}/lib/cookie.c
    ${CURL_SOURCE_DIR}/lib/curl_addrinfo.c
    ${CURL_SOURCE_DIR}/lib/curl_ctype.c
    ${CURL_SOURCE_DIR}/lib/curl_des.c
    ${CURL_SOURCE_DIR}/lib/curl_endian.c
    ${CURL_SOURCE_DIR}/lib/curl_fnmatch.c
    ${CURL_SOURCE_DIR}/lib/curl_get_line.c
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
    ${CURL_SOURCE_DIR}/lib/doh.c
    ${CURL_SOURCE_DIR}/lib/dotdot.c
    ${CURL_SOURCE_DIR}/lib/dynbuf.c
    ${CURL_SOURCE_DIR}/lib/easy.c
    ${CURL_SOURCE_DIR}/lib/easygetopt.c
    ${CURL_SOURCE_DIR}/lib/easyoptions.c
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
    ${CURL_SOURCE_DIR}/lib/hsts.c
    ${CURL_SOURCE_DIR}/lib/http.c
    ${CURL_SOURCE_DIR}/lib/http2.c
    ${CURL_SOURCE_DIR}/lib/http_chunks.c
    ${CURL_SOURCE_DIR}/lib/http_digest.c
    ${CURL_SOURCE_DIR}/lib/http_negotiate.c
    ${CURL_SOURCE_DIR}/lib/http_ntlm.c
    ${CURL_SOURCE_DIR}/lib/http_proxy.c
    ${CURL_SOURCE_DIR}/lib/http_aws_sigv4.c
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
    ${CURL_SOURCE_DIR}/lib/mqtt.c
    ${CURL_SOURCE_DIR}/lib/multi.c
    ${CURL_SOURCE_DIR}/lib/netrc.c
    ${CURL_SOURCE_DIR}/lib/non-ascii.c
    ${CURL_SOURCE_DIR}/lib/nonblock.c
    ${CURL_SOURCE_DIR}/lib/openldap.c
    ${CURL_SOURCE_DIR}/lib/parsedate.c
    ${CURL_SOURCE_DIR}/lib/pingpong.c
    ${CURL_SOURCE_DIR}/lib/pop3.c
    ${CURL_SOURCE_DIR}/lib/progress.c
    ${CURL_SOURCE_DIR}/lib/psl.c
    ${CURL_SOURCE_DIR}/lib/rand.c
    ${CURL_SOURCE_DIR}/lib/rename.c
    ${CURL_SOURCE_DIR}/lib/rtsp.c
    ${CURL_SOURCE_DIR}/lib/select.c
    ${CURL_SOURCE_DIR}/lib/sendf.c
    ${CURL_SOURCE_DIR}/lib/setopt.c
    ${CURL_SOURCE_DIR}/lib/sha256.c
    ${CURL_SOURCE_DIR}/lib/share.c
    ${CURL_SOURCE_DIR}/lib/slist.c
    ${CURL_SOURCE_DIR}/lib/smb.c
    ${CURL_SOURCE_DIR}/lib/smtp.c
    ${CURL_SOURCE_DIR}/lib/socketpair.c
    ${CURL_SOURCE_DIR}/lib/socks.c
    ${CURL_SOURCE_DIR}/lib/socks_gssapi.c
    ${CURL_SOURCE_DIR}/lib/socks_sspi.c
    ${CURL_SOURCE_DIR}/lib/speedcheck.c
    ${CURL_SOURCE_DIR}/lib/splay.c
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
    ${CURL_SOURCE_DIR}/lib/urlapi.c
    ${CURL_SOURCE_DIR}/lib/version.c
    ${CURL_SOURCE_DIR}/lib/version_win32.c
    ${CURL_SOURCE_DIR}/lib/warnless.c
    ${CURL_SOURCE_DIR}/lib/wildcard.c
    ${CURL_SOURCE_DIR}/lib/x509asn1.c
    ${CURL_SOURCE_DIR}/lib/vauth/cleartext.c
    ${CURL_SOURCE_DIR}/lib/vauth/cram.c
    ${CURL_SOURCE_DIR}/lib/vauth/digest.c
    ${CURL_SOURCE_DIR}/lib/vauth/digest_sspi.c
    ${CURL_SOURCE_DIR}/lib/vauth/gsasl.c
    ${CURL_SOURCE_DIR}/lib/vauth/krb5_gssapi.c
    ${CURL_SOURCE_DIR}/lib/vauth/krb5_sspi.c
    ${CURL_SOURCE_DIR}/lib/vauth/ntlm.c
    ${CURL_SOURCE_DIR}/lib/vauth/ntlm_sspi.c
    ${CURL_SOURCE_DIR}/lib/vauth/oauth2.c
    ${CURL_SOURCE_DIR}/lib/vauth/spnego_gssapi.c
    ${CURL_SOURCE_DIR}/lib/vauth/spnego_sspi.c
    ${CURL_SOURCE_DIR}/lib/vauth/vauth.c
    ${CURL_SOURCE_DIR}/lib/vtls/bearssl.c
    ${CURL_SOURCE_DIR}/lib/vtls/gskit.c
    ${CURL_SOURCE_DIR}/lib/vtls/gtls.c
    ${CURL_SOURCE_DIR}/lib/vtls/keylog.c
    ${CURL_SOURCE_DIR}/lib/vtls/mbedtls.c
    ${CURL_SOURCE_DIR}/lib/vtls/mbedtls_threadlock.c
    ${CURL_SOURCE_DIR}/lib/vtls/mesalink.c
    ${CURL_SOURCE_DIR}/lib/vtls/nss.c
    ${CURL_SOURCE_DIR}/lib/vtls/openssl.c
    ${CURL_SOURCE_DIR}/lib/vtls/rustls.c
    ${CURL_SOURCE_DIR}/lib/vtls/schannel.c
    ${CURL_SOURCE_DIR}/lib/vtls/schannel_verify.c
    ${CURL_SOURCE_DIR}/lib/vtls/sectransp.c
    ${CURL_SOURCE_DIR}/lib/vtls/vtls.c
    ${CURL_SOURCE_DIR}/lib/vtls/wolfssl.c
    ${CURL_SOURCE_DIR}/lib/vquic/ngtcp2.c
    ${CURL_SOURCE_DIR}/lib/vquic/quiche.c
    ${CURL_SOURCE_DIR}/lib/vquic/vquic.c
    ${CURL_SOURCE_DIR}/lib/vssh/libssh.c
    ${CURL_SOURCE_DIR}/lib/vssh/libssh2.c
    ${CURL_SOURCE_DIR}/lib/vssh/wolfssh.c)

list(APPEND PRIVATE_DEFINITIONS -DBUILDING_LIBCURL)
list(APPEND PRIVATE_DEFINITIONS -DUSE_WIN32_LDAP)

if(MSVC)
  list(APPEND PRIVATE_DEFINITIONS -D_CRT_SECURE_NO_WARNINGS) # Disable warnings
                                                             # for unsecure CRT
                                                             # functions

  # Disable warnings
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
  list(APPEND PRIVATE_OPTIONS -w)
endif(MINGW)

add_library(libcurl SHARED ${CURL_SRCS} ${CURL_PUBLIC_HEADERS}
                           ${CURL_PRIVATE_HEADERS})

# Dependent include files
target_include_directories(
  libcurl PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
                 $<INSTALL_INTERFACE:include>)

target_include_directories(libcurl PRIVATE ${CURL_SOURCE_DIR}/include
                                           ${CURL_SOURCE_DIR}/lib)

target_compile_definitions(libcurl PRIVATE ${PRIVATE_DEFINITIONS})

target_compile_options(libcurl PRIVATE ${PRIVATE_OPTIONS})

if(MSVC)
  target_link_libraries(libcurl ws2_32.lib wldap32.lib)
endif(MSVC)

# INSTALL
install(
  TARGETS libcurl
  EXPORT libcurl_export
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(FILES ${CURL_PUBLIC_HEADERS}
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/curl)
