SET(MY_ANTLR4_JAR_LOCATION "${CMAKE_CURRENT_LIST_DIR}/_deps/antlr-4.8-complete.jar"
        CACHE FILEPATH "path to antlr-x.x-complete.jar"
)

FIND_PACKAGE(Java COMPONENTS Runtime REQUIRED)

FUNCTION(ANTLR4_GENERATE)
    CMAKE_PARSE_ARGUMENTS(
            "ARG"                      # prefix
            "GEN_LISTENER;GEN_VISITOR" # option
            "NAMESPACE;MODE;G4;DIR"    # value
            ""                         # list
            ${ARGN}                    # input
    )

    # [option]
    # GEN_LISTENER : generate listener
    # GEN_VISITOR  : generate visitor
    # [value]
    # DIR          : default ${CMAKE_CURRENT_SOURCE_DIR}
    # NAMESPACE
    # MODE         : LEXER / PARSER / BOTH (default)
    # G4           : input file
    # [return]
    # * BASE_NAME    : G4's NAME_WE
    # INCLUDE_DIR_${BASE_NAME}
    # SRC_FILES_${BASE_NAME}
    # TOKEN_DIRECTORY_${BASE_NAME}
    # TOKEN_FILES_${BASE_NAME}


    IF ("${ARG_G4}" STREQUAL "")
        MESSAGE(FATAL_ERROR "[G4] parameter must not be empty")
    ENDIF ()
    IF ("${ARG_MODE}" STREQUAL "")
        SET(ARG_MODE "BOTH")
    ENDIF ()
    IF ("${ARG_DIR}" STREQUAL "")
        SET(ARG_DIR ${CMAKE_CURRENT_SOURCE_DIR})
    ENDIF ()

    GET_FILENAME_COMPONENT(BASE_NAME ${ARG_G4} NAME_WE)

    SET(GeneratorStatusMessage "")
    LIST(APPEND GeneratorStatusMessage "Common Include-, Source- and Tokenfiles")

    IF ("${ARG_MODE}" STREQUAL "LEXER")
        SET(LexerBaseName "${BASE_NAME}")
        SET(ParserBaseName "")
    ELSEIF ("${ARG_MODE}" STREQUAL "PARSER")
        SET(LexerBaseName "")
        SET(ParserBaseName "${BASE_NAME}")
    ELSEIF ("${ARG_MODE}" STREQUAL "BOTH")
        SET(LexerBaseName "${BASE_NAME}Lexer")
        SET(ParserBaseName "${BASE_NAME}Parser")
    ELSE ()
        MESSAGE(FATAL_ERROR "MODE parameter must be LEXER, PARSER or BOTH")
    ENDIF ()

    # Prepare LIST of generated targets
    LIST(APPEND GeneratedTargets "${ARG_DIR}/${BASE_NAME}.tokens")
    LIST(APPEND GeneratedTargets "${ARG_DIR}/${BASE_NAME}.interp")
    LIST(APPEND DependentTargets "${ARG_DIR}/${BASE_NAME}.tokens")

    IF (NOT ${LexerBaseName} STREQUAL "")
        LIST(APPEND GeneratedTargets "${ARG_DIR}/${LexerBaseName}.h")
        LIST(APPEND GeneratedTargets "${ARG_DIR}/${LexerBaseName}.cpp")
    ENDIF ()

    IF (NOT ${ParserBaseName} STREQUAL "")
        LIST(APPEND GeneratedTargets "${ARG_DIR}/${ParserBaseName}.h")
        LIST(APPEND GeneratedTargets "${ARG_DIR}/${ParserBaseName}.cpp")
    ENDIF ()

    IF (ARG_GEN_LISTENER)
        SET(BuildListenerOption "-listener")

        LIST(APPEND GeneratedTargets "${ARG_DIR}/${BASE_NAME}BaseListener.h")
        LIST(APPEND GeneratedTargets "${ARG_DIR}/${BASE_NAME}BaseListener.cpp")
        LIST(APPEND GeneratedTargets "${ARG_DIR}/${BASE_NAME}Listener.h")
        LIST(APPEND GeneratedTargets "${ARG_DIR}/${BASE_NAME}Listener.cpp")

        LIST(APPEND GeneratorStatusMessage ", Listener Include- and Sourcefiles")
    ELSE ()
        SET(BuildListenerOption "-no-listener")
    ENDIF ()

    IF (ARG_GEN_VISITOR)
        SET(BuildVisitorOption "-visitor")

        LIST(APPEND GeneratedTargets "${ARG_DIR}/${BASE_NAME}BaseVisitor.h")
        LIST(APPEND GeneratedTargets "${ARG_DIR}/${BASE_NAME}BaseVisitor.cpp")
        LIST(APPEND GeneratedTargets "${ARG_DIR}/${BASE_NAME}Visitor.h")
        LIST(APPEND GeneratedTargets "${ARG_DIR}/${BASE_NAME}Visitor.cpp")

        LIST(APPEND GeneratorStatusMessage ", Visitor Include- and Sourcefiles")
    ELSE ()
        SET(BuildVisitorOption "-no-visitor")
    ENDIF ()

    IF (NOT "${ARG_NAMESPACE}" STREQUAL "")
        SET(NamespaceOption "-package;${ARG_NAMESPACE}")

        LIST(APPEND GeneratorStatusMessage " in Namespace ${ARG_NAMESPACE}")
    ELSE ()
        SET(NamespaceOption "")
    ENDIF ()

    IF (NOT Java_JAVA_EXECUTABLE)
        MESSAGE(FATAL_ERROR "Java is required to process grammar or lexer files! - Use 'FIND_PACKAGE(Java COMPONENTS Runtime REQUIRED)'")
    ENDIF ()

    IF (NOT EXISTS "${MY_ANTLR4_JAR_LOCATION}")
        MESSAGE(FATAL_ERROR "Unable to find antlr tool. MY_ANTLR4_JAR_LOCATION:${MY_ANTLR4_JAR_LOCATION}")
    ENDIF ()

    MESSAGE(STATUS "Antlr4 ${BASE_NAME} - Building " ${GeneratorStatusMessage})

    # The call to generate the files
    EXECUTE_PROCESS(
            # Remove target directory
            COMMAND
            ${CMAKE_COMMAND} -E remove_directory ${ARG_DIR}
            # Create target directory
            COMMAND
            ${CMAKE_COMMAND} -E make_directory ${ARG_DIR}
            COMMAND
            # Generate files
            "${Java_JAVA_EXECUTABLE}" -jar "${MY_ANTLR4_JAR_LOCATION}" -Werror -Dlanguage=Cpp ${BuildListenerOption} ${BuildVisitorOption} -o "${ARG_DIR}" ${NamespaceOption} "${ARG_G4}"
            WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
            RESULT_VARIABLE ANTLR_COMMAND_RESULT
    )

    # Add error handling
    IF (NOT ANTLR_COMMAND_RESULT EQUAL 0)
        MESSAGE(FATAL_ERROR "ANTLR4 command failed with result: ${ANTLR_COMMAND_RESULT}")
    ENDIF ()

    # SET output variables in parent scope
    SET(INCLUDE_DIR_${BASE_NAME} ${ARG_DIR} PARENT_SCOPE)
    SET(SRC_FILES_${BASE_NAME} ${GeneratedTargets} PARENT_SCOPE)
    SET(TOKEN_FILES_${BASE_NAME} ${DependentTargets} PARENT_SCOPE)
    SET(TOKEN_DIRECTORY_${BASE_NAME} ${ARG_DIR} PARENT_SCOPE)

    # export generated cpp files into LIST
    FOREACH (GENERATED_FILE ${GeneratedTargets})
        IF (NOT CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
            SET_SOURCE_FILES_PROPERTIES(
                    ${GENERATED_FILE}
                    PROPERTIES
                    COMPILE_FLAGS -Wno-overloaded-virtual
            )
        ENDIF ()

        IF (CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
            SET_SOURCE_FILES_PROPERTIES(
                    ${GENERATED_FILE}
                    PROPERTIES
                    COMPILE_FLAGS -wd4251
            )
        ENDIF ()
    ENDFOREACH ()
endfunction()