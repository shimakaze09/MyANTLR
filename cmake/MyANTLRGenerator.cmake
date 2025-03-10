IF (NOT ANTLR4_CPP_GENERATED_SRC_DIR)
    SET(ANTLR4_GENERATED_SRC_DIR ${CMAKE_BINARY_DIR}/_deps/antlr4_generated_src)
ENDIF ()

SET(ANTLR4_JAR_LOCATION "${CMAKE_CURRENT_LIST_DIR}/antlr-4.8-complete.jar")

FIND_PACKAGE(Java COMPONENTS Runtime REQUIRED)

#
# The ANTLR generator will output the following files given the input file f.g4
#
# Input  -> f.g4
# Output -> f.h
#        -> f.cpp
#
# the following files will only be produced if there is a parser contained
# Flag -visitor active
# Output -> <f>BaseVisitor.h
#        -> <f>BaseVisitor.cpp
#        -> <f>Visitor.h
#        -> <f>Visitor.cpp
#
# Flag -listener active
# Output -> <f>BaseListener.h
#        -> <f>BaseListener.cpp
#        -> <f>Listener.h
#        -> <f>Listener.cpp
#
# See documentation in markup
#
FUNCTION(antlr4_generate
        Antlr4_ProjectTarget
        Antlr4_InputFile
        Antlr4_GeneratorType
)

    SET(Antlr4_GeneratedSrcDir ${ANTLR4_GENERATED_SRC_DIR}/${Antlr4_ProjectTarget})

    GET_FILENAME_COMPONENT(Antlr4_InputFileBaseName ${Antlr4_InputFile} NAME_WE)

    LIST(APPEND Antlr4_GeneratorStatusMessage "Common Include-, Source- and Tokenfiles")

    IF (${Antlr4_GeneratorType} STREQUAL "LEXER")
        SET(Antlr4_LexerBaseName "${Antlr4_InputFileBaseName}")
        SET(Antlr4_ParserBaseName "")
    ELSE ()
        IF (${Antlr4_GeneratorType} STREQUAL "PARSER")
            SET(Antlr4_LexerBaseName "")
            SET(Antlr4_ParserBaseName "${Antlr4_InputFileBaseName}")
        ELSE ()
            IF (${Antlr4_GeneratorType} STREQUAL "BOTH")
                SET(Antlr4_LexerBaseName "${Antlr4_InputFileBaseName}Lexer")
                SET(Antlr4_ParserBaseName "${Antlr4_InputFileBaseName}Parser")
            ELSE ()
                MESSAGE(FATAL_ERROR "The third parameter must be LEXER, PARSER or BOTH")
            ENDIF ()
        ENDIF ()
    ENDIF ()

    # Prepare LIST of generated targets
    LIST(APPEND Antlr4_GeneratedTargets "${Antlr4_GeneratedSrcDir}/${Antlr4_InputFileBaseName}.tokens")
    LIST(APPEND Antlr4_GeneratedTargets "${Antlr4_GeneratedSrcDir}/${Antlr4_InputFileBaseName}.interp")
    LIST(APPEND DependentTargets "${Antlr4_GeneratedSrcDir}/${Antlr4_InputFileBaseName}.tokens")

    IF (NOT ${Antlr4_LexerBaseName} STREQUAL "")
        LIST(APPEND Antlr4_GeneratedTargets "${Antlr4_GeneratedSrcDir}/${Antlr4_LexerBaseName}.h")
        LIST(APPEND Antlr4_GeneratedTargets "${Antlr4_GeneratedSrcDir}/${Antlr4_LexerBaseName}.cpp")
    ENDIF ()

    IF (NOT ${Antlr4_ParserBaseName} STREQUAL "")
        LIST(APPEND Antlr4_GeneratedTargets "${Antlr4_GeneratedSrcDir}/${Antlr4_ParserBaseName}.h")
        LIST(APPEND Antlr4_GeneratedTargets "${Antlr4_GeneratedSrcDir}/${Antlr4_ParserBaseName}.cpp")
    ENDIF ()

    # process optional arguments ...

    IF ((ARGC GREATER_EQUAL 4) AND ARGV3)
        SET(Antlr4_BuildListenerOption "-LISTener")

        LIST(APPEND Antlr4_GeneratedTargets "${Antlr4_GeneratedSrcDir}/${Antlr4_InputFileBaseName}BaseListener.h")
        LIST(APPEND Antlr4_GeneratedTargets "${Antlr4_GeneratedSrcDir}/${Antlr4_InputFileBaseName}BaseListener.cpp")
        LIST(APPEND Antlr4_GeneratedTargets "${Antlr4_GeneratedSrcDir}/${Antlr4_InputFileBaseName}Listener.h")
        LIST(APPEND Antlr4_GeneratedTargets "${Antlr4_GeneratedSrcDir}/${Antlr4_InputFileBaseName}Listener.cpp")

        LIST(APPEND Antlr4_GeneratorStatusMessage ", Listener Include- and Sourcefiles")
    ELSE ()
        SET(Antlr4_BuildListenerOption "-no-LISTener")
    ENDIF ()

    IF ((ARGC GREATER_EQUAL 5) AND ARGV4)
        SET(Antlr4_BuildVisitorOption "-visitor")

        LIST(APPEND Antlr4_GeneratedTargets "${Antlr4_GeneratedSrcDir}/${Antlr4_InputFileBaseName}BaseVisitor.h")
        LIST(APPEND Antlr4_GeneratedTargets "${Antlr4_GeneratedSrcDir}/${Antlr4_InputFileBaseName}BaseVisitor.cpp")
        LIST(APPEND Antlr4_GeneratedTargets "${Antlr4_GeneratedSrcDir}/${Antlr4_InputFileBaseName}Visitor.h")
        LIST(APPEND Antlr4_GeneratedTargets "${Antlr4_GeneratedSrcDir}/${Antlr4_InputFileBaseName}Visitor.cpp")

        LIST(APPEND Antlr4_GeneratorStatusMessage ", Visitor Include- and Sourcefiles")
    ELSE ()
        SET(Antlr4_BuildVisitorOption "-no-visitor")
    ENDIF ()

    IF ((ARGC GREATER_EQUAL 6) AND (NOT ${ARGV5} STREQUAL ""))
        SET(Antlr4_NamespaceOption "-package;${ARGV5}")

        LIST(APPEND Antlr4_GeneratorStatusMessage " in Namespace ${ARGV5}")
    ELSE ()
        SET(Antlr4_NamespaceOption "")
    ENDIF ()

    IF ((ARGC GREATER_EQUAL 7) AND (NOT ${ARGV6} STREQUAL ""))
        SET(Antlr4_AdditionalDependencies ${ARGV6})
    ELSE ()
        SET(Antlr4_AdditionalDependencies "")
    ENDIF ()

    IF ((ARGC GREATER_EQUAL 8) AND (NOT ${ARGV7} STREQUAL ""))
        SET(Antlr4_LibOption "-lib;${ARGV7}")

        LIST(APPEND Antlr4_GeneratorStatusMessage " using Library ${ARGV7}")
    ELSE ()
        SET(Antlr4_LibOption "")
    ENDIF ()

    IF (NOT Java_FOUND)
        MESSAGE(FATAL_ERROR "Java is required to process grammar or lexer files! - Use 'FIND_PACKAGE(Java COMPONENTS Runtime REQUIRED)'")
    ENDIF ()

    IF (NOT EXISTS "${ANTLR4_JAR_LOCATION}")
        MESSAGE(FATAL_ERROR "Unable to find antlr tool. ANTLR4_JAR_LOCATION:${ANTLR4_JAR_LOCATION}")
    ENDIF ()

    # The call to generate the files
    ADD_CUSTOM_COMMAND(
            OUTPUT ${Antlr4_GeneratedTargets}
            # Remove target directory
            COMMAND
            ${CMAKE_COMMAND} -E remove_directory ${Antlr4_GeneratedSrcDir}
            # Create target directory
            COMMAND
            ${CMAKE_COMMAND} -E make_directory ${Antlr4_GeneratedSrcDir}
            COMMAND
            # Generate files
            "${Java_JAVA_EXECUTABLE}" -jar "${ANTLR4_JAR_LOCATION}" -Werror -Dlanguage=Cpp ${Antlr4_BuildListenerOption} ${Antlr4_BuildVisitorOption} ${Antlr4_LibOption} ${ANTLR4_GENERATED_OPTIONS} -o "${Antlr4_GeneratedSrcDir}" ${Antlr4_NamespaceOption} "${Antlr4_InputFile}"
            WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
            MAIN_DEPENDENCY "${Antlr4_InputFile}"
            DEPENDS ${Antlr4_AdditionalDependencies}
    )

    # SET output variables in parent scope
    SET(ANTLR4_INCLUDE_DIR_${Antlr4_ProjectTarget} ${Antlr4_GeneratedSrcDir} PARENT_SCOPE)
    SET(ANTLR4_SRC_FILES_${Antlr4_ProjectTarget} ${Antlr4_GeneratedTargets} PARENT_SCOPE)
    SET(ANTLR4_TOKEN_FILES_${Antlr4_ProjectTarget} ${DependentTargets} PARENT_SCOPE)
    SET(ANTLR4_TOKEN_DIRECTORY_${Antlr4_ProjectTarget} ${Antlr4_GeneratedSrcDir} PARENT_SCOPE)

    # export generated cpp files into LIST
    FOREACH (generated_file ${Antlr4_GeneratedTargets})

        IF (NOT CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
            SET_SOURCE_FILES_PROPERTIES(
                    ${generated_file}
                    PROPERTIES
                    COMPILE_FLAGS -Wno-overloaded-virtual
            )
        ENDIF ()

        IF (CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
            SET_SOURCE_FILES_PROPERTIES(
                    ${generated_file}
                    PROPERTIES
                    COMPILE_FLAGS -wd4251
            )
        ENDIF ()

    ENDFOREACH (generated_file)

    MESSAGE(STATUS "Antlr4 ${Antlr4_ProjectTarget} - Building " ${Antlr4_GeneratorStatusMessage})

ENDFUNCTION()
