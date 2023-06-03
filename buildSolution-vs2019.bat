@echo off
cd /d %~dp0
REM ROOT
set ThirdPary_ROOT=%1
REM x64 x86
set arch=%2

if "%ThirdPary_ROOT%"=="" (
	set ThirdPary_ROOT=.\..\..\
)

if "%arch%"=="" (
	set arch=x64
)

echo %arch%
set ROOT=%~dp0
set SRC=%ROOT%\3rdparty\src

set build_dir=%ThirdPary_ROOT%build\osg-3rdparty

md %build_dir%

set curl=%SRC%/curl
set freetype=%SRC%/freetype
set zlib=%SRC%/zlib
set libjpeg=%SRC%/libjpeg
set libpng=%SRC%/libpng
set libtiff=%SRC%/tiff
set giflib=%SRC%/giflib
set glut=%SRC%/glut

set install=%ThirdPary_ROOT%publish/windows/%arch%

set curl=%curl:\=/%
set zlib=%zlib:\=/%
set freetype=%freetype:\=/%
set libjpeg=%libjpeg:\=/%
set libpng=%libpng:\=/%
set libtiff=%libtiff:\=/%
set giflib=%giflib:\=/%
set glut=%glut:\=/%
set install=%install:\=/%
set build_dir=%build_dir:\=/%

echo %install%


  cmake  -G"Visual Studio 16 2019" -A %arch% -B  %build_dir%  -D CURL_SOURCE_DIR=%curl% -D FREETYPE_SOURCE_DIR=%freetype% -D GIFLIB_SOURCE_DIR=%giflib% -D GLUT_SOURCE_DIR=%glut% -D LIBJPEG_SOURCE_DIR=%libjpeg% -D LIBPNG_SOURCE_DIR=%libpng% -D LIBTIFF_SOURCE_DIR=%libtiff% -D ZLIB_SOURCE_DIR=%zlib% -DCMAKE_INSTALL_PREFIX=%install%

REM cmake  -D CURL_SOURCE_DIR=%curl% -D FREETYPE_SOURCE_DIR=freetype -D GIFLIB_SOURCE_DIR= %SRC%/giflib -D GLUT_SOURCE_DIR=%SRC%/glut -D LIBJPEG_SOURCE_DIR=%SRC%/libjpeg -D LIBPNG_SOURCE_DIR=%SRC%/libpng -D LIBTIFF_SOURCE_DIR=%SRC%/libtiff -D ZLIB_SOURCE_DIR= -P %ROOT%CMakeLists.txt
echo %install%/Debug
cmake --build %build_dir% --config "Debug" --target ALL_BUILD
cmake -DBUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=%install%/Debug -P %build_dir%/cmake_install.cmake

echo %install%/Release
cmake --build %build_dir% --config "Release" --target ALL_BUILD
cmake -DBUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=%install%/Release -P %build_dir%/cmake_install.cmake

REM echo %install%/RelWithDebInfo
REM cmake --build %build_dir% --config "RelWithDebInfo" --target ALL_BUILD
REM cmake -DBUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=%install%/RelWithDebInfo -P %build_dir%/cmake_install.cmake


	
