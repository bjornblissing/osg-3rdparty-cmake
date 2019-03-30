REM zlib
git clone --depth 1 --single-branch --branch v1.2.11 https://github.com/madler/zlib.git c:/3rdparty/zlib

REM libpng
git clone --depth 1 --single-branch --branch v1.6.36  git://git.code.sf.net/p/libpng/code.git c:/3rdparty/libpng

REM libjpeg
curl -O http://www.ijg.org/files/jpegsr9c.zip
7z x jpegsr9c.zip -oc:\3rdparty\
move c:\3rdparty\jpeg-9c c:\3rdparty\libjpeg

REM libtiff
git clone --depth 1 --single-branch --branch v4.0.10 https://gitlab.com/libtiff/libtiff.git c:/3rdparty/tiff

REM freetype
git clone --depth 1 --single-branch --branch VER-2-9-1 git://git.sv.nongnu.org/freetype/freetype2.git c:/3rdparty/freetype

REM glut
git clone https://github.com/markkilgard/glut.git c:/3rdparty/glut
cd c:\3rdparty\glut
git reset --hard 8cd96cb440f1f2fac3a154227937be39d06efa53
cd %APPVEYOR_BUILD_FOLDER%

REM giflib
git clone --depth 1 --single-branch --branch 5.1.4 https://git.code.sf.net/p/giflib/code.git c:/3rdparty/giflib

REM minizip
git clone https://github.com/nmoinvaz/minizip.git c:/3rdparty/minizip
cd c:/3rdparty/minizip
git reset --hard dac37702b3fab4068ac9a7c4a992df7f0e4f14df
cd %APPVEYOR_BUILD_FOLDER%

REM curl
curl -O https://curl.haxx.se/download/curl-7.60.0.zip
7z x curl-7.60.0.zip -oc:\3rdparty\
move c:\3rdparty\curl-7.60.0 c:\3rdparty\curl