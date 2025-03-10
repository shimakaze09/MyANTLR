IF (BUILD_TEST_MyANTLR)
    SET(ANTLR4_GENERATED_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/_deps")

    SET(PARSER_NAME "DemoParser")

    antlr4_generate(
            ${PARSER_NAME}
            ${CMAKE_CURRENT_SOURCE_DIR}/CPP14.g4
            BOTH
            TRUE
            TRUE
            My
    )
ENDIF ()

ADD_TARGET(
        TEST
        MODE EXE
        SOURCE
        "${ANTLR4_SRC_FILES_${PARSER_NAME}}"
        LIB
        My::MyANTLR_runtime
)