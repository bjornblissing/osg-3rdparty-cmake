使用osg-3rdparty-cmake 现在的freetype版本（2.10.4）无法编译通过，使用2.10.0可以再ubuntu18.4编译，ubuntu上使用该库,后发是FT_CONFIG_OPTION_USE_HARFBUZZ宏 未定义，但编译器确认为已经定义，
强制声明反定义，继续使用2.10.4版本