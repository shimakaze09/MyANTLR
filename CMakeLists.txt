CMAKE_MINIMUM_REQUIRED(VERSION 3.20 FATAL_ERROR)

PROJECT(MyANTLR VERSION 0.1.4 LANGUAGES CXX C)
MESSAGE(STATUS "Project: ${PROJECT_NAME} ${PROJECT_VERSION}")

INCLUDE(cmake/InitMyCMake.cmake)
INIT_MYCMAKE()
INCLUDE(cmake/ANTLR4Generator.cmake)

INIT_PROJECT()

DOWNLOAD_ZIP(
        https://cdn.jsdelivr.net/gh/shimakaze09/MyData@main/MyANTLR/antlr4_19032025.zip
        antlr4_19032025.zip
        SHA256 5dea841b94c717862b8872de05f50c981f4cad7632d8b29826117aadc8e45b6e
)

ADD_SUB_DIRS_REC(include)
ADD_SUB_DIRS_REC(src)

PACKAGE_NAME(PACKAGE_NAME)

INSTALL(FILES
        "config/Antlr4Package.md"
        "config/README.md"
        DESTINATION "${PACKAGE_NAME}/cmake"
)

EXPORT_TARGETS(
        TARGET
        DIRECTORIES
        "include"
        "cmake"
)