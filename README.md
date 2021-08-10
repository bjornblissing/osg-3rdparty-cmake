osg-3rdparty-cmake
==================

CMake scripts for building OpenSceneGraph third party libraries.

These scripts can be used to build third party libraries from source using CMake(http://www.cmake.org/). 

The source code for respective library has to be downloaded separately, see download locations below.

By building the INSTALL target for both debug and release these scripts will create a folder named `3rdParty`.
Inside this folder there will folders created to represent each platform toolset.

### Status: ![Build status](https://github.com/bjornblissing/osg-3rdparty-cmake/actions/workflows/build.yml/badge.svg)


Prebuilt versions
----------------

Prebuilt version can be found under *Releases*. Version numbers if the included dependencies can be found in the [versions.md](versions.md) file.

Toolset | Prebuilt archive
------------ | -------------
Visual Studio 2017 32-bit | v141-x86.zip
Visual Studio 2017 64-bit | v141-x64.zip
Visual Studio 2019 32-bit | v142-x86.zip
Visual Studio 2019 64-bit | v142-x64.zip


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
Sources for zlib can be downloaded from:

http://www.zlib.net/


libpng
------
Sources for libpng can be downloaded from:

http://www.libpng.org/pub/png/libpng.html


libjpeg
-------
Sources for libjpeg can be downloaded from:

http://www.ijg.org/


libtiff
-------
Sources for libtiff can be downloaded from:

https://gitlab.com/libtiff/libtiff


FreeType
--------
Sources for FreeType can be downloaded from:

http://www.freetype.org/


GLUT
----
Sources for GLUT can be downloaded from:

https://github.com/markkilgard/glut


GIFLIB
------
Sources for GIFLIB can be downloaded from:

http://sourceforge.net/projects/giflib/


cURL
----
Sources for cURL can be downloaded from:

http://curl.haxx.se/
