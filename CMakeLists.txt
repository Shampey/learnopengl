cmake_minimum_required(VERSION 3.16)
project(LearnOpenGL)

set(CMAKE_CXX_STANDARD 17)

# GLAD (compiled as part of project)
add_library(glad external/glad/src/glad.c)
target_include_directories(glad PUBLIC external/glad/include)

# Find packages installed by Homebrew
find_package(glfw3 REQUIRED)
find_package(glm REQUIRED)

# Your executable
add_executable(LearnOpenGL src/main.cpp)

target_include_directories(LearnOpenGL PRIVATE external/glad/include)

target_compile_definitions(LearnOpenGL PRIVATE SHADER_DIR="${CMAKE_SOURCE_DIR}/src/shaders/")

target_link_libraries(LearnOpenGL
    glad
    glfw
    glm::glm
    "-framework OpenGL"
    "-framework Cocoa"
    "-framework IOKit"
    "-framework CoreVideo"
)
