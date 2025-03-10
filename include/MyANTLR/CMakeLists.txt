SET(TARGET_DIR "${PROJECT_SOURCE_DIR}/include/MyANTLR/ParserCpp14")
IF (NOT EXISTS ${TARGET_DIR})
    ANTLR4_GENERATE(
            GEN_VISITOR
            GEN_LISTENER
            G4 "${PROJECT_SOURCE_DIR}/data/CPP14.g4"
            NAMESPACE My
            DIR ${TARGET_DIR}
    )

    FILE(GLOB_RECURSE CPP_FILES
            RELATIVE ${TARGET_DIR}
            ${TARGET_DIR}/*.cpp
    )

    FOREACH (CPP_FILE ${CPP_FILES})
        FILE(RENAME
                "${TARGET_DIR}/${CPP_FILE}"
                "${PROJECT_SOURCE_DIR}/src/ParserCpp14/${CPP_FILE}"
        )
    ENDFOREACH ()
ENDIF ()