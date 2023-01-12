set BUILD_FOLDER=%cd%

REM Disable the warning for detached head
git config --global advice.detachedHead false

REM zlib
git clone --depth 1 --single-branch --branch v1.2.13 https://github.com/madler/zlib.git c:/3rdparty/zlib

REM libpng
git clone --depth 1 --single-branch --branch v1.6.37  git://git.code.sf.net/p/libpng/code.git c:/3rdparty/libpng

REM libjpeg
curl -O http://www.ijg.org/files/jpegsr9d.zip
7z x jpegsr9d.zip -oc:\3rdparty\
move c:\3rdparty\jpeg-9d c:\3rdparty\libjpeg

REM libtiff
git clone --depth 1 --single-branch --branch v4.2.0 https://gitlab.com/libtiff/libtiff.git c:/3rdparty/tiff

REM freetype
git clone --depth 1 --single-branch --branch VER-2-10-4 git://git.sv.nongnu.org/freetype/freetype2.git c:/3rdparty/freetype

REM glut
git clone https://github.com/markkilgard/glut.git c:/3rdparty/glut
cd c:\3rdparty\glut
git reset --hard 8cd96cb440f1f2fac3a154227937be39d06efa53
cd %BUILD_FOLDER%

REM giflib
git clone --depth 1 --single-branch --branch 5.2.1 https://git.code.sf.net/p/giflib/code.git c:/3rdparty/giflib

REM curl
curl -O https://curl.se/download/curl-7.76.1.zip
7z x curl-7.76.1.zip -oc:\3rdparty\
move c:\3rdparty\curl-7.76.1 c:\3rdparty\curl
