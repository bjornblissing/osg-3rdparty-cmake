@echo off
:: try to set compatibility with previous version by @bjornblissing
IF "%dest%"=="" (SET dest=..\osg-3rdparty)
IF EXIST "c:/3rdparty/" (set dest=c:/3rdparty)
set sevenZip=7z
IF EXIST "C:\Program Files\7-Zip\7z.exe" (set sevenZip=C:\Program Files\7-Zip\7z.exe)

echo ===== Fetching missing sources to %dest% folder.
pause

REM zlib
IF NOT EXIST %dest%\zlib\ (
git clone --depth 1 --single-branch --branch v1.2.11 https://github.com/madler/zlib.git %dest%\zlib
)

REM libpng
IF NOT EXIST %dest%\libpng\ (
git clone --depth 1 --single-branch --branch v1.6.36  git://git.code.sf.net/p/libpng/code.git %dest%/libpng
)

REM libjpeg
IF NOT EXIST %dest%\libjpeg\ (
curl -O http://www.ijg.org/files/jpegsr9c.zip
"%sevenZip%" x jpegsr9c.zip -o%dest%\
move %dest%\jpeg-9c %dest%\libjpeg
)

REM libtiff
IF NOT EXIST %dest%\tiff\ (
git clone --depth 1 --single-branch --branch v4.0.10 https://gitlab.com/libtiff/libtiff.git %dest%/tiff
)

REM freetype
IF NOT EXIST %dest%\freetype\ (
git clone --depth 1 --single-branch --branch VER-2-9-1 git://git.sv.nongnu.org/freetype/freetype2.git %dest%/freetype
)

REM glut
IF NOT EXIST %dest%\glut\ (
git clone https://github.com/markkilgard/glut.git %dest%/glut
pushd .
cd %dest%\glut\
git reset --hard 8cd96cb440f1f2fac3a154227937be39d06efa53
popd
)

REM giflib
IF NOT EXIST %dest%\giflib\ (
git clone --depth 1 --single-branch --branch 5.1.4 https://git.code.sf.net/p/giflib/code.git %dest%/giflib
)

REM minizip
IF NOT EXIST %dest%\minizip\ (
git clone https://github.com/nmoinvaz/minizip.git %dest%/minizip
pushd .
cd %dest%/minizip
git reset --hard dac37702b3fab4068ac9a7c4a992df7f0e4f14df
popd
)

REM curl
IF NOT EXIST %dest%\curl\ (
curl -L -O https://github.com/curl/curl/releases/download/curl-7_60_0/curl-7.60.0.zip
"%sevenZip%" x curl-7.60.0.zip -o%dest%\
move %dest%\curl-7.60.0 %dest%\curl
)