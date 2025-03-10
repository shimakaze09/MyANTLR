CMAKE_MINIMUM_REQUIRED(VERSION 3.20 FATAL_ERROR)

PROJECT(MyANTLR VERSION 0.0.4 LANGUAGES CXX)
MESSAGE(STATUS "Project: ${PROJECT_NAME} ${PROJECT_VERSION}")

INCLUDE(cmake/InitMyCMake.cmake)
INIT_MYCMAKE()
INCLUDE(cmake/ANTLR4Generator.cmake)

INIT_PROJECT()

DOWNLOAD_ZIP(
        https://cdn.jsdelivr.net/gh/shimakaze09/MyData@main/MyANTLR/antlr4_10032025.zip
        antlr4_10032025.zip
        SHA256 793e691f1cbe4af9143f40d9a4d7d2f0f331144bae17d6f0c26a1f722a8d803b
)


ADD_SUB_DIRS_REC(include)
ADD_SUB_DIRS_REC(src)

# install
PACKAGE_NAME(PACKAGE_NAME)

INSTALL(FILES
        "config/Antlr4Package.md"
        "config/README.md"
        DESTINATION "${PACKAGE_NAME}/cmake"
)

EXPORT_TARGETS(DIRECTORIES "include;cmake")