echo build osg-3rdparty-cmake
CUR_DIR=${0%/*}
echo $0
echo ${0##*/}
cd ${CUR_DIR}
echo current dir: ${CUR_DIR}
ThirdParty_ROOT=$1
# x64 x86
arch=$2
echo ${arch}
ROOT=${CUR_DIR}
SRC=${ROOT}/3rdparty/src
echo thirdparty: ${ThirdParty_ROOT}
build_dir=${ThirdParty_ROOT}/build/linux/osg-3rdparty
rm -rf ${build_dir}
mkdir -p ${build_dir}

curl=${SRC}/curl
freetype=${SRC}/freetype
zlib=${SRC}/zlib
libjpeg=${SRC}/libjpeg
libpng=${SRC}/libpng
libtiff=${SRC}/tiff
giflib=${SRC}/giflib
glut=${SRC}/glut

install=${ThirdParty_ROOT}/publish/linux/${arch}

echo ${install}
# copy file 
cp ./../osg-3rdparty-cmake-modify/afshaper.h ${ThirdParty_ROOT}/sources/OSG/osg-3rdparty-cmake/3rdparty/src/freetype/src/autofit/
#=========================================================================================================================
# freetype
echo === build freetype
FREETYPE_SRC=${CUR_DIR}/3rdparty/src/freetype
FREETYPE_BUILD=${ThirdParty_ROOT}/build/linux/osg-3rdparty-freetype
rm -rf ${FREETYPE_BUILD}
mkdir -p ${FREETYPE_BUILD}
cmake -S ${FREETYPE_SRC} -B ${FREETYPE_BUILD} -DCMAKE_INSTALL_PREFIX=${install} -DCMAKE_BUILD_TYPE=Debug
cmake --build ${FREETYPE_BUILD} --config "Debug" --target all
cmake -DBUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=${install}/Debug -P ${FREETYPE_BUILD}/cmake_install.cmake -Wdev

rm -rf ${FREETYPE_BUILD}
mkdir -p ${FREETYPE_BUILD}
cmake -S ${FREETYPE_SRC} -B ${FREETYPE_BUILD} -DCMAKE_INSTALL_PREFIX=${install} -DCMAKE_BUILD_TYPE=Release
cmake --build ${FREETYPE_BUILD} --config "Release" --target all
cmake -DBUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${install}/Release -P ${FREETYPE_BUILD}/cmake_install.cmake -Wdev
#=========================================================================================================================
#=========================================================================================================================
# zlib libjpeg libpng libtiff  giflib
echo === build zlib libjpeg libpng libtiff giflib
#echo === build Debug
cmake -S ${CUR_DIR} -B ${build_dir}  -DZLIB_SOURCE_DIR=${zlib} -DLIBJPEG_SOURCE_DIR=${libjpeg} -DLIBPNG_SOURCE_DIR=${libpng} -DGIFLIB_SOURCE_DIR=${giflib} -DLIBTIFF_SOURCE_DIR=${libtiff}  -DCMAKE_INSTALL_PREFIX=${install} -DCMAKE_BUILD_TYPE=Debug

cmake --build ${build_dir} --config "Debug" --target all
cmake -DBUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=${install}/Debug -P ${build_dir}/cmake_install.cmake


rm -rf ${build_dir}

echo === build Release
cmake -S ${CUR_DIR} -B ${build_dir} -DZLIB_SOURCE_DIR=${zlib} -DLIBJPEG_SOURCE_DIR=${libjpeg} -DLIBPNG_SOURCE_DIR=${libpng} -DGIFLIB_SOURCE_DIR=${giflib}  -DLIBTIFF_SOURCE_DIR=${libtiff} -DCMAKE_INSTALL_PREFIX=${install} -DCMAKE_BUILD_TYPE=Release

cmake --build ${build_dir} --config "Release" --target all
cmake -DBUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${install}/Release -P ${build_dir}/cmake_install.cmake
#=========================================================================================================================
#=========================================================================================================================
# libcurl
echo === build curl
CURL_SRC=${CUR_DIR}/3rdparty/src/curl
CURL_BUILD=${ThirdParty_ROOT}/build/linux/osg-3rdparty-curl
rm -rf ${CURL_BUILD}
mkdir -p ${CURL_BUILD}
echo === build Debug
cmake -S ${CURL_SRC} -B ${CURL_BUILD} -DCMAKE_INSTALL_PREFIX=${install} -DCMAKE_BUILD_TYPE=Debug
cmake --build ${CURL_BUILD} --config "Debug" --target all
cmake -DBUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=${install}/Debug -P ${CURL_BUILD}/cmake_install.cmake

rm -rf ${CURL_BUILD}
mkdir -p ${CURL_BUILD}
echo === build Release
cmake -S ${CURL_SRC} -B ${CURL_BUILD} -DCMAKE_INSTALL_PREFIX=${install} -DCMAKE_BUILD_TYPE=Release
cmake --build ${CURL_BUILD} --config "Release" --target all
cmake -DBUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${install}/Release -P ${CURL_BUILD}/cmake_install.cmake
#=========================================================================================================================
#<< EOF 
#echo === build freetype
#FREETYPE_SRC=${CUR_DIR}/3rdparty/src/FreeType2-2.10.0
#FREETYPE_BUILD=${ThirdParty_ROOT}/build/linux/osg-3rdparty-freetype
#rm -rf ${FREETYPE_BUILD}
#mkdir -p ${FREETYPE_BUILD}
#echo === build Debug
#cmake -S ${FREETYPE_SRC} -B ${FREETYPE_BUILD} -DCMAKE_INSTALL_PREFIX=${install} -DCMAKE_BUILD_TYPE=Debug
#cmake --build ${FREETYPE_BUILD} --config "Debug" --target all
#cmake -DBUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=${install}/Debug -P ${FREETYPE_BUILD}/cmake_install.cmake

#rm -rf ${FREETYPE_BUILD}
#mkdir -p ${FREETYPE_BUILD}
#echo === build Release
#cmake -S ${FREETYPE_SRC} -B ${FREETYPE_BUILD} -DCMAKE_INSTALL_PREFIX=${install} -DCMAKE_BUILD_TYPE=Release
#cmake --build ${FREETYPE_BUILD} --config "Release" --target all
#cmake -DBUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${install}/Release -P ${FREETYPE_BUILD}/cmake_install.cmake

#echo === build freetype
#EOF









