set(FOREIGN_CMAKE_COMMAND "${CMAKE_BIN_DIR}/cmake")
set(FOREIGN_CPACK_COMMAND "${CMAKE_BIN_DIR}/cpack")

if(EXISTS "${BIN_DIR}")
    file(REMOVE_RECURSE "${BIN_DIR}")
endif()

file(MAKE_DIRECTORY "${BIN_DIR}")

execute_process(COMMAND "${FOREIGN_CMAKE_COMMAND}"
	-G Ninja 
	"-DCPACK_GENERATOR=${GENERATOR}" "${SRC_DIR}"
	WORKING_DIRECTORY "${BIN_DIR}"
	RESULT_VARIABLE CMAKE_RESULT
	OUTPUT_VARIABLE CMAKE_OUTPUT
	ERROR_VARIABLE CMAKE_OUTPUT
)

if(NOT "${CMAKE_RESULT}" STREQUAL "0")
	message(FATAL_ERROR 
		"[${TEST_NAME}] CMake failed (${CMAKE_RESULT}) : [${CMAKE_OUTPUT}]")
endif()

execute_process(COMMAND "${FOREIGN_CMAKE_COMMAND}" --build .
    WORKING_DIRECTORY "${BIN_DIR}"
    RESULT_VARIABLE CMAKE_RESULT
    OUTPUT_VARIABLE CMAKE_OUTPUT
    ERROR_VARIABLE CMAKE_OUTPUT
)

if(NOT "${CMAKE_RESULT}" STREQUAL "0")
    message(FATAL_ERROR
        "[${TEST_NAME}] CMake failed (${CMAKE_RESULT}) : [${CMAKE_OUTPUT}]")
endif()

execute_process(COMMAND "${FOREIGN_CPACK_COMMAND}"
	WORKING_DIRECTORY "${BIN_DIR}"
	RESULT_VARIABLE CPACK_RESULT
	OUTPUT_VARIABLE CPACK_OUTPUT
	ERROR_VARIABLE CPACK_OUTPUT
)

if(NOT "${CPACK_RESULT}" STREQUAL "0")
	message(FATAL_ERROR 
		"[${TEST_NAME}] CPack failed (${CPACK_RESULT}) : [${CPACK_OUTPUT}]")
endif()
