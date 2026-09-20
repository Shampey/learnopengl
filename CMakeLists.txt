cmake_minimum_required(VERSION 3.16)
project(LearnOpenGL)

set(CMAKE_CXX_STANDARD 17)

# 1. Automatically collect your main source files
file(GLOB_RECURSE PROJECT_SOURCES CONFIGURE_DEPENDS
    "src/*.cpp"
    "src/*.h"
    "src/*.hpp"
)

# 2. Compile your local GLAD C file
add_library(glad external/glad/src/glad.c)
target_include_directories(glad PUBLIC "${CMAKE_SOURCE_DIR}/external/glad/include")

# 3. Create your main executable target
add_executable(LearnOpenGL ${PROJECT_SOURCES})

# 4. Provide the include directories for Glad, GLFW, and GLM headers
target_include_directories(LearnOpenGL PRIVATE 
    "${CMAKE_SOURCE_DIR}/external/glad/include"
    "${CMAKE_SOURCE_DIR}/external/glfw/include"
    "${CMAKE_SOURCE_DIR}/external/glm"
)

# 5. Source shaders macro path definition
target_compile_definitions(LearnOpenGL PRIVATE SHADER_DIR="${CMAKE_SOURCE_DIR}/src/shaders/")

# 6. Set up basic library linking
target_link_libraries(LearnOpenGL PRIVATE glad)

# 7. DYNAMIC CROSS-PLATFORM SYSTEM ROUTING
if(WIN32)
    # --- WINDOWS SPECIFIC CONFIGURATION ---
    # Find your local Windows GLFW static library (.lib)
    find_library(GLFW_LOCAL_LIB
        NAMES glfw3 glfw
        PATHS "${CMAKE_SOURCE_DIR}/external/glfw/lib"
        NO_DEFAULT_PATH
    )
    
    # Link Windows static library and Windows core OpenGL driver
    target_link_libraries(LearnOpenGL PRIVATE 
        ${GLFW_LOCAL_LIB}
        opengl32
    )

elseif(APPLE)
    # --- macOS SPECIFIC CONFIGURATION ---
    # Find your local macOS GLFW static library (.a or .dylib)
    find_library(GLFW_LOCAL_LIB
        NAMES glfw3 glfw
        PATHS "${CMAKE_SOURCE_DIR}/external/glfw/lib"
        NO_DEFAULT_PATH
    )

    # Link Mac static library and Apple's native system frameworks
    target_link_libraries(LearnOpenGL PRIVATE 
        ${GLFW_LOCAL_LIB}
        "-framework OpenGL"
        "-framework Cocoa"
        "-framework IOKit"
        "-framework CoreVideo"
    )
endif()
