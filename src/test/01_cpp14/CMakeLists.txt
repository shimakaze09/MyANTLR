GET_TARGET_NAME(PARSER "${PROJECT_SOURCE_DIR}/src/ParserCpp14")

ADD_TARGET(
        CXX_STANDARD 17
        TEST
        MODE EXE
        LIB
        ${PARSER}
)