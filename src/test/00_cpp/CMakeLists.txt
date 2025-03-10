IF (${BUILD${PROJECT_NAME}TEST})
    SET(ANTLR4_GENERATED_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/_deps")

    SET(parserName "DemoParser")

    antlr4_generate(
            ${parserName}
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
        SOURCE "${ANTLR4_SRC_FILES_${parserName}}"
        LIB My::MyANTLR_runtime
)