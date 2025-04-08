GET_TARGET_NAME(RUNTIME "${PROJECT_SOURCE_DIR}/src/runtime")

IF (MSVC)
    SET(c_options -wd4251)
ELSE ()
    SET(c_options -Wno-overloaded-virtual)
ENDIF ()

ADD_TARGET(
        CXX_STANDARD 17
        MODE STATIC
        SOURCE
        "${PROJECT_SOURCE_DIR}/include/MyANTLR/ParserCpp14"
        INC_INTERFACE
        "${PROJECT_SOURCE_DIR}/include"
        INC_PRIVATE
        "${PROJECT_SOURCE_DIR}/include/MyANTLR/ParserCpp14"
        C_OPTION
        ${c_options}
        LIB
        ${RUNTIME}
)