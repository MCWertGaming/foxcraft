cmake_minimum_required(VERSION 3.20)
project(foxcraft
    VERSION 1.0.0
    DESCRIPTION "Foxcraft - A small library for interacting with the mojang / minecraft API in C++"
    HOMEPAGE_URL "https://github.com/MCWertGaming/foxcraft"
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED true)

option(FOXCRAFT_BUILD_EXAMPLES "Enables building of examples" ON)
option(FOXCRAFT_ENABLE_TESTING "Enables building of unit testing targets" ON)
option(FOXCRAFT_ENABLE_INSTALL "Enables install generation of foxcraft" ON)
# if(PROJECT_IS_TOP_LEVEL) // needs cmake 3.21

# add_subdirectory(foxcraft)

# include custom cmake functions
include(cmake/dependency.cmake)

add_subdirectory(dependencies)
