function(find_git)
    find_package(Git QUIET)
endfunction()

# first search for locally installed dependency, then use git submodule as fall-back
function(add_dependency_local ARG_LOCAL_NAME)
    # try to find required packages
    find_package(${ARG_LOCAL_NAME} QUIET)

    # check if dependency is installed and if so just use it
    if (${ARG_LOCAL_NAME}_FOUND)
        message(STATUS "Using locally installed ${ARG_LOCAL_NAME}")
        include_directories(${${ARG_LOCAL_NAME}_INCLUDE_DIRS})
    endif(${ARG_LOCAL_NAME}_FOUND)

    # check if git is installed, skip if dependency is installed
    if (Git_FOUND AND NOT ${ARG_LOCAL_NAME}_FOUND)
        message(STATUS "Using git submodule for ${ARG_LOCAL_NAME}")
        # initialising sub module at {current_folder}/${ARG_LOCAL_NAME}
        execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init ${ARG_LOCAL_NAME} WORKING_DIRECTORY ${CMAKE_SOURCE_DIR} RESULT_VARIABLE ${ARG_LOCAL_NAME}_SUBMOD_RESULT)
    elseif(NOT Git_FOUND AND NOT ${ARG_LOCAL_NAME}_FOUND)
        # prints an error if neither dependency or git is installed
        message(WARNING "No installed version of ${ARG_LOCAL_NAME} or git found! Please install one in order to build the application")
    endif(Git_FOUND AND NOT ${ARG_LOCAL_NAME}_FOUND)

    # check for git failture and include the sub module directory on success
    if(${ARG_LOCAL_NAME}_SUBMOD_RESULT EQUAL "0")
        message(STATUS "${ARG_LOCAL_NAME} git sub module sucessfully initialised")
    elseif(NOT ${ARG_LOCAL_NAME}_SUBMOD_RESULT EQUAL "0" AND NOT ${ARG_LOCAL_NAME}_FOUND AND Git_FOUND)
        message(WARNING "Initialisation of the ${ARG_LOCAL_NAME} sub module failed! Please check if your git installation is working correctly")
    endif(${ARG_LOCAL_NAME}_SUBMOD_RESULT EQUAL "0")

    if (NOT ${ARG_LOCAL_NAME}_FOUND)
        add_subdirectory(${ARG_LOCAL_NAME})
    endif(NOT ${ARG_LOCAL_NAME}_FOUND)
endfunction()

# use git submodule and don't search for installed version
function(add_dependency_remote ARG_LOCAL_NAME)
    # check if git is installed
    if (Git_FOUND)
        message(STATUS "Using git submodule for ${ARG_LOCAL_NAME}")
        # initialising sub module at {current_folder}/${ARG_LOCAL_NAME}
        execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init ${ARG_LOCAL_NAME} WORKING_DIRECTORY ${CMAKE_SOURCE_DIR} RESULT_VARIABLE ${ARG_LOCAL_NAME}_SUBMOD_RESULT)
    elseif(NOT Git_FOUND)
        # prints an error if neither dependency or git is installed
        message(WARNING "No installed version of git found! Please install one in order to build the application")
    endif(Git_FOUND)

    # check for git failture and include the sub module directory on success
    if(${ARG_LOCAL_NAME}_SUBMOD_RESULT EQUAL "0")
        message(STATUS "${ARG_LOCAL_NAME} git sub module sucessfully initialised")
    elseif(NOT ${ARG_LOCAL_NAME}_SUBMOD_RESULT EQUAL "0" AND Git_FOUND)
        message(WARNING "Initialisation of the ${ARG_LOCAL_NAME} sub module failed! Please check if your git installation is working correctly")
    endif(${ARG_LOCAL_NAME}_SUBMOD_RESULT EQUAL "0")

    # add dependency
    add_subdirectory(${ARG_LOCAL_NAME})
endfunction()