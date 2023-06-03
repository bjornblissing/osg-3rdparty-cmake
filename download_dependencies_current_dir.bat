
cd /d %~dp0
set ROOT=%~dp0
set SRC=%ROOT%3rdparty\src
md %ROOT%3rdparty
md %ROOT%3rdparty\src


REM zlib
git clone --depth 1 --single-branch --branch v1.2.11 https://github.com/madler/zlib.git %SRC%\zlib

REM libpng
git clone --depth 1 --single-branch --branch v1.6.37  git://git.code.sf.net/p/libpng/code.git %SRC%\libpng

REM libjpeg
curl -O http://www.ijg.org/files/jpegsr9d.zip
7z x jpegsr9d.zip -o%SRC%\
rename %SRC%\jpeg-9d  libjpeg

REM libtiff
git clone --depth 1 --single-branch --branch v4.2.0 https://gitlab.com/libtiff/libtiff.git %SRC%\tiff

REM freetype
git clone --depth 1 --single-branch --branch VER-2-10-4 git://git.sv.nongnu.org/freetype/freetype2.git %SRC%\freetype

REM glut
git clone https://github.com/markkilgard/glut.git  %SRC%\glut
cd %SRC%\glut
git reset --hard 8cd96cb440f1f2fac3a154227937be39d06efa53
cd %APPVEYOR_BUILD_FOLDER%

REM giflib
git clone --depth 1 --single-branch --branch 5.2.1 https://git.code.sf.net/p/giflib/code.git %SRC%\giflib

REM curl
curl -O https://curl.se/download/curl-7.76.1.zip
7z x curl-7.76.1.zip -o%SRC%\
rename %SRC%\curl-7.76.1  curl

cd /d %ROOT% 