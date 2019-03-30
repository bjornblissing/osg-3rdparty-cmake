osg-3rdparty-cmake
==================

CMake scripts for building OpenSceneGraph third party libraries.

These scripts can be used to build third party libraries from source using CMake(http://www.cmake.org/). 

The source code for respective library has to be downloaded separately, see download locations below.

By building the INSTALL target for both debug and release these scripts will create a folder named `3rdParty`.
Inside this folder there will folders created to represent each platform toolset.


### Status: [![Build status](https://ci.appveyor.com/api/projects/status/xtrxxowo68nyrj9m?svg=true)](https://ci.appveyor.com/project/bjornblissing/osg-3rdparty-cmake)


Prebuilt versions
----------------

Toolset | Prebuilt archive
------------ | -------------
Visual Studio 2015 32-bit | [v140-x86.zip](https://ci.appveyor.com/api/projects/bjornblissing/osg-3rdparty-cmake/artifacts/v140-x86.zip?job=Environment%3A+Name%3Dv140-x86%2C+APPVEYOR_BUILD_WORKER_IMAGE%3DVisual+Studio+2015%2C+Generator%3DVisual+Studio+14+2015)
Visual Studio 2015 64-bit | [v140-x64.zip](https://ci.appveyor.com/api/projects/bjornblissing/osg-3rdparty-cmake/artifacts/v140-x64.zip?job=Environment%3A+Name%3Dv140-x64%2C+APPVEYOR_BUILD_WORKER_IMAGE%3DVisual+Studio+2015%2C+Generator%3DVisual+Studio+14+2015+Win64)
Visual Studio 2017 32-bit | [v141-x86.zip](https://ci.appveyor.com/api/projects/bjornblissing/osg-3rdparty-cmake/artifacts/v141-x86.zip?job=Environment%3A+Name%3Dv141-x86%2C+APPVEYOR_BUILD_WORKER_IMAGE%3DVisual+Studio+2017%2C+Generator%3DVisual+Studio+15+2017)
Visual Studio 2017 64-bit | [v141-x64.zip](https://ci.appveyor.com/api/projects/bjornblissing/osg-3rdparty-cmake/artifacts/v141-x64.zip?job=Environment%3A+Name%3Dv141-x64%2C+APPVEYOR_BUILD_WORKER_IMAGE%3DVisual+Studio+2017%2C+Generator%3DVisual+Studio+15+2017+Win64)


_Prebuilt versions courtesy of [AppVeyor](https://www.appveyor.com)_


License
-------

Each of the dependencies keep their original licenses since their scripts are to be considered derivative works. 

The top level script is licensed according to the `Unlicense`:

http://unlicense.org/


Instructions
------------

1. Download the CMake scripts from this repository.
2. Download the source for the dependencies you would like to use from their respective location as specified below.
3. Start the CMake GUI and select the directory with the CMake scripts as your source directory. Use any desired output directory as binary directory.
4. Press **Configure** inside the CMake GUI. 
5. Fill in the location of the downloaded sources of your desired dependencies and press "Configure" again. Repeat until there is no more errors and warnings in CMake. 
6. Press **Generate** inside the CMake GUI. This will generate solution file inside your binary directory.
7. Open the solution file in your IDE.
8. Build the `ALL_BUILD` project for both debug and release.
9. Build the `INSTALL` project for both debug and release.

In your binary directory there will now be a folder named `3rdParty` with a sub-folder named after your target platform. Inside this folder there should be all your headers and libraries.


zlib
----
Latest version tested: 1.2.11

Sources for zlib can be downloaded from:

http://www.zlib.net/


libpng
------
Latest version tested: 1.6.36

Sources for libpng can be downloaded from:

http://www.libpng.org/pub/png/libpng.html


libjpeg
-------
Latest version tested: 9c

Sources for libjpeg can be downloaded from:

http://www.ijg.org/


libtiff
-------
Latest version tested: 4.0.10

Sources for libtiff can be downloaded from:

https://gitlab.com/libtiff/libtiff


FreeType
--------
Latest version tested: 2.9.1

Sources for FreeType can be downloaded from:

http://www.freetype.org/


GLUT
----
Latest version tested: markkilgard/glut@8cd96cb440f1f2fac3a154227937be39d06efa53

Sources for GLUT can be downloaded from:

https://github.com/markkilgard/glut


GIFLIB
------
Latest version tested: 5.1.4

Sources for GIFLIB can be downloaded from:

http://sourceforge.net/projects/giflib/


MINIZIP
-------

Latest version tested: nmoinvaz/minizip@dac37702b3fab4068ac9a7c4a992df7f0e4f14df

Sources for MINIZIP can be downloaded from:

http://github.com/nmoinvaz/minizip


cURL
----

Latest version tested: 7.60.0

Sources for cURL can be downloaded from:

http://curl.haxx.se/
