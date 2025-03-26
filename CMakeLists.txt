CMAKE_MINIMUM_REQUIRED(VERSION 3.20 FATAL_ERROR)

PROJECT(MyANTLR VERSION 0.2.0 LANGUAGES CXX C)
MESSAGE(STATUS "Project: ${PROJECT_NAME} ${PROJECT_VERSION}")

INCLUDE(cmake/InitMyCMake.cmake)
INIT_MYCMAKE()

INIT_PROJECT()

DOWNLOAD_ZIP(
        https://cdn.jsdelivr.net/gh/shimakaze09/MyData@main/MyANTLR/antlr4_runtime_26032025.zip
        antlr4_runtime_26032025.zip
        SHA256 906dbec5957da4a39910e97a95b9019deed03bf686b21a36f9781243311fc2d3
)
DOWNLOAD_ZIP(
        https://cdn.jsdelivr.net/gh/shimakaze09/MyData@main/MyANTLR/antlr4_cpp14_27032025.zip
        antlr4_cpp14_27032025.zip
        SHA256 713dc932fe37f5e9d3b0299d1571613f1a036c83b41772e70473f2bc37ec2ab8
)

ADD_SUB_DIRS_REC(include)
ADD_SUB_DIRS_REC(src)

PACKAGE_NAME(PACKAGE_NAME)

EXPORT_TARGETS(
        TARGET
        DIRECTORIES
        "include"
        "cmake"
)