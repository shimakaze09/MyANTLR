CMAKE_MINIMUM_REQUIRED(VERSION 3.20 FATAL_ERROR)

PROJECT(MyANTLR VERSION 0.3.0 LANGUAGES CXX C)
MESSAGE(STATUS "Project: ${PROJECT_NAME} ${PROJECT_VERSION}")

INCLUDE(cmake/InitMyCMake.cmake)
INIT_MYCMAKE(VERSION 0.6.4)

INIT_PROJECT()

DOWNLOAD_ZIP(
        https://cdn.jsdelivr.net/gh/shimakaze09/MyData@main/MyANTLR/antlr4_runtime_27042025.zip
        antlr4_runtime_27042025.zip
        SHA256 711fb6c41dc0a86e4701251ec5c8373b76f7c615a62f383e300bdb19defd7f91
)
DOWNLOAD_ZIP(
        https://cdn.jsdelivr.net/gh/shimakaze09/MyData@main/MyANTLR/antlr4_cpp14_27042025.zip
        antlr4_cpp14_27042025.zip
        SHA256 f0506620a8ef0de968eee49cff3285a9ede9784628f29e8a8c2d3e81beb3a5cb
)
# name in antlr4_cpp14_20201115.zip is wrong, so change it here
IF (EXISTS "${PROJECT_SOURCE_DIR}/include/MyANTLR/ParserCPP14")
    FILE(RENAME "${PROJECT_SOURCE_DIR}/include/MyANTLR/ParserCPP14" "${PROJECT_SOURCE_DIR}/include/MyANTLR/ParserCpp14")
ENDIF ()

ADD_SUB_DIRS_REC(include)
ADD_SUB_DIRS_REC(src)

PACKAGE_NAME(PACKAGE_NAME)

EXPORT_TARGETS(
        TARGET
        DIRECTORIES
        "include"
        "cmake"
)