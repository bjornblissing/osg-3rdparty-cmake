osg-3rdparty-cmake
==================

CMake scripts for building OpenSceneGraph third party libraries.

These scripts can be used to build third party libraries from source using CMake(http://www.cmake.org/). 

The source code for respective library has to be downloaded separately, see download locations below.

By building the INSTALL target for both debug and release these scripts will create a folder named `3rdParty`.
Inside this folder there will folders created to represent each platform toolset.

So far these scripts has been tested with successfully with the following toolsets:

* Visual Studio 2010 - 32 bit build
* Visual Studio 2010 - 64 bit build

* Visual Studio 2013 - 32 bit build
* Visual Studio 2013 - 64 bit build

* Visual Studio 2015 - 32 bit build
* Visual Studio 2015 - 64 bit build

* Visual Studio 2017 - 32 bit build
* Visual Studio 2017 - 64 bit build

* MinGW + GCC 4.8.2

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
Latest version tested: 1.6.28

Sources for libpng can be downloaded from:

http://www.libpng.org/pub/png/libpng.html


libjpeg
-------
Latest version tested: 9b

Sources for libjpeg can be downloaded from:

http://www.ijg.org/


libtiff
-------
Latest version tested: 4.0.7

Sources for libtiff can be downloaded from:

http://www.libtiff.org

**Note:** FTP link to *Master Download Site* is currently broken. New location is http://download.osgeo.org/libtiff/


FreeType
--------
Latest version tested: 2.7.1

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

Latest version tested: nmoinvaz/minizip@f5fb00d3cf54efdeebb9dfa7a39a0b279e46c5a8

Sources for MINIZIP can be downloaded from:

http://github.com/nmoinvaz/minizip


cURL
----

Latest version tested: 7.54.0

Sources for cURL can be downloaded from:

http://curl.haxx.se/
