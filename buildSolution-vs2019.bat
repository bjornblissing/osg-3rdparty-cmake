@echo on
cd /d %~dp0
set ROOT=%~dp0
set SRC=%ROOT%\3rdparty\src
set name=v142-x64
md build
md build\osg-3rdparty
md 3rdparty-bin
md 3rdparty-bin\v142-x64

set curl=%SRC%/curl
set freetype=%SRC%/freetype
set zlib=%SRC%/zlib
set libjpeg=%SRC%/libjpeg
set libpng=%SRC%/libpng
set libtiff=%SRC%/tiff
set giflib=%SRC%/giflib
set glut=%SRC%/glut

set install=%ROOT%/3rdparty-bin/%Name%"

set curl=%curl:\=/%
set zlib=%zlib:\=/%
set freetype=%freetype:\=/%
set libjpeg=%libjpeg:\=/%
set libpng=%libpng:\=/%
set libtiff=%libtiff:\=/%
set giflib=%giflib:\=/%
set glut=%glut:\=/%
set install=%install:\=/%



  cmake  -G"Visual Studio 16 2019" -A x64 -B  .\build\osg-3rdparty  -D CURL_SOURCE_DIR=%curl% -D FREETYPE_SOURCE_DIR=%freetype% -D GIFLIB_SOURCE_DIR=%giflib% -D GLUT_SOURCE_DIR=%glut% -D LIBJPEG_SOURCE_DIR=%libjpeg% -D LIBPNG_SOURCE_DIR=%libpng% -D LIBTIFF_SOURCE_DIR=%libtiff% -D ZLIB_SOURCE_DIR=%zlib% -DCMAKE_INSTALL_PREFIX=%install%

REM cmake  -D CURL_SOURCE_DIR=%curl% -D FREETYPE_SOURCE_DIR=freetype -D GIFLIB_SOURCE_DIR= %SRC%/giflib -D GLUT_SOURCE_DIR=%SRC%/glut -D LIBJPEG_SOURCE_DIR=%SRC%/libjpeg -D LIBPNG_SOURCE_DIR=%SRC%/libpng -D LIBTIFF_SOURCE_DIR=%SRC%/libtiff -D ZLIB_SOURCE_DIR= -P %ROOT%CMakeLists.txt

cmake --build ./build/osg-3rdparty  --config "Debug" --target install 
    
cmake --build ./build/osg-3rdparty  --config "Release" --target install 
    
cd %ROOT%3rdparty-bin\%Name%
    
7z a %ROOT%%Name%.zip 

cd %ROOT%
	
