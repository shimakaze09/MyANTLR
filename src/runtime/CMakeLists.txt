SET(c_options "")

IF(MSVC)
    LIST(APPEND c_options "/wd4996")
ENDIF()

SET(c_options_private "")

IF(MSVC)
    LIST(APPEND c_options_private "/MP")
ELSEIF("${CMAKE_CXX_COMPILER_ID}" STREQUAL "ClANG")
    #
ELSEIF("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    #
ENDIF()

ADD_TARGET(
        CXX_STANDARD 17
        MODE STATIC
        SOURCE
        "${PROJECT_SOURCE_DIR}/include/_deps/antlr4"
        INC
        "${PROJECT_SOURCE_DIR}/include/_deps/antlr4"
        INC_PRIVATE
        "${PROJECT_SOURCE_DIR}/include/_deps/antlr4/atn"
        "${PROJECT_SOURCE_DIR}/include/_deps/antlr4/dfa"
        "${PROJECT_SOURCE_DIR}/include/_deps/antlr4/misc"
        "${PROJECT_SOURCE_DIR}/include/_deps/antlr4/support"
        "${PROJECT_SOURCE_DIR}/include/_deps/antlr4/tree"
        "${PROJECT_SOURCE_DIR}/include/_deps/antlr4/tree/pattern"
        "${PROJECT_SOURCE_DIR}/include/_deps/antlr4/tree/xpath"
        DEFINE
        ANTLR4CPP_STATIC
        NOMINMAX
        C_OPTION
        ${c_options}
        C_OPTION_PRIVATE
        ${c_options_private}        
)