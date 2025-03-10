SET(TARGET_DIR "${CMAKE_CURRENT_SOURCE_DIR}/_deps/DemoParser")
IF (NOT EXISTS ${TARGET_DIR})
    ANTLR4_GENERATE(
            GEN_VISITOR
            GEN_LISTENER
            G4 "${PROJECT_SOURCE_DIR}/data/CPP14.g4"
            NAMESPACE My
            DIR ${TARGET_DIR}
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