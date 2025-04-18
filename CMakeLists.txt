CMAKE_MINIMUM_REQUIRED(VERSION 3.20 FATAL_ERROR)

PROJECT(MyANTLR VERSION 0.2.1 LANGUAGES CXX C)
MESSAGE(STATUS "Project: ${PROJECT_NAME} ${PROJECT_VERSION}")

INCLUDE(cmake/InitMyCMake.cmake)
INIT_MYCMAKE(VERSION 0.6.4)

INIT_PROJECT()

DOWNLOAD_ZIP(
        https://cdn.jsdelivr.net/gh/shimakaze09/MyData@main/MyANTLR/antlr4_runtime_26032025.zip
        antlr4_runtime_26032025.zip
        SHA256 906dbec5957da4a39910e97a95b9019deed03bf686b21a36f9781243311fc2d3
)
DOWNLOAD_ZIP(
        https://cdn.jsdelivr.net/gh/shimakaze09/MyData@main/MyANTLR/antlr4_cpp14_19042025.zip
        antlr4_cpp14_19042025.zip
        SHA256 bb35637c9c5337403d8796316ddb3a09f3c1ea33c0e8efa27c37cf943309d3c8
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