ADD_TARGET(
        MODE STATIC
        SOURCE "${PROJECT_SOURCE_DIR}/include"
        INC
        "include/_deps/antlr4"
        INC_PRIVATE
        "include/_deps/antlr4/atn"
        "include/_deps/antlr4/dfa"
        "include/_deps/antlr4/misc"
        "include/_deps/antlr4/support"
        "include/_deps/antlr4/tree"
        "include/_deps/antlr4/tree/pattern"
        "include/_deps/antlr4/tree/xpath"
        DEFINE ANTLR4CPP_STATIC
)

IF ("${CMAKE_CXX_COMPILER_ID}" MATCHES "MSVC")
    GET_TARGET_NAME(TARGET_NAME ${CMAKE_CURRENT_LIST_DIR})
    TARGET_COMPILE_OPTIONS(${TARGET_NAME} PUBLIC "-wd4996")
ENDIF ()