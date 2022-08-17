# Git
find_git()

# RapidJSON
add_dependency_local(RapidJSON)
include_directories(${RAPIDJSON_INCLUDE_DIR})
message("var: ${RAPIDJSON_INCLUDE_DIR}")

add_dependency_local(CURL)
