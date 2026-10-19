cmake_minimum_required(VERSION 3.20)
project(my_opengl LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(GLFW_BUILD_DOCS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
add_subdirectory(external/glfw)

add_subdirectory(external/glm)

add_library(glad STATIC external/glad/src/glad.c)
target_include_directories(glad PUBLIC external/glad/include)

add_executable(app src/main.cpp)
target_link_libraries(app PRIVATE glfw glad glm::glm)

target_compile_definitions(app PRIVATE
    PROJECT_ROOT="${CMAKE_SOURCE_DIR}")
