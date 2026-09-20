cmake_minimum_required(VERSION 3.16)
project(LearnOpenGL)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 1. Automatically collect main source files.
#    Headers are listed for IDE visibility but are not compiled on their own.
file(GLOB_RECURSE PROJECT_SOURCES CONFIGURE_DEPENDS
    "src/*.cpp"
)
file(GLOB_RECURSE PROJECT_HEADERS CONFIGURE_DEPENDS
    "src/*.h"
    "src/*.hpp"
)

# 2. Compile the local GLAD loader (C)
add_library(glad STATIC external/glad/src/glad.c)
target_include_directories(glad PUBLIC "${CMAKE_SOURCE_DIR}/external/glad/include")

# 3. Main executable
add_executable(LearnOpenGL ${PROJECT_SOURCES} ${PROJECT_HEADERS})

# 4. Include directories for GLAD, GLFW and GLM headers.
#    Note: GLM must point into 'include/' so that '#include <glm/glm.hpp>' resolves.
target_include_directories(LearnOpenGL PRIVATE
    "${CMAKE_SOURCE_DIR}/external/glad/include"
    "${CMAKE_SOURCE_DIR}/external/glfw/include"
    "${CMAKE_SOURCE_DIR}/external/glm/include"
)

# 5. Shader path macro
target_compile_definitions(LearnOpenGL PRIVATE SHADER_DIR="${CMAKE_SOURCE_DIR}/src/shaders/")

# 6. Base library linking
target_link_libraries(LearnOpenGL PRIVATE glad)

# 7. CROSS-PLATFORM SYSTEM ROUTING.
#    The GLFW binaries are provided per platform in sub-folders of external/glfw/lib,
#    so pick the correct sub-folder (and architecture) before looking for the file.
set(GLFW_LIB_DIR "")

if(WIN32)
    # The bundled Windows GLFW is a 64-bit static library.
    if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        message(FATAL_ERROR
            "The bundled GLFW (external/glfw/lib/win64/glfw3.lib) is built for x64,\n"
            "but this build is targeting 32-bit. Configure with a 64-bit generator, e.g.:\n"
            "  cmake -B build -A x64\n"
            "or pick an x64 kit in the CMake Tools extension.")
    endif()
    set(GLFW_LIB_DIR "${CMAKE_SOURCE_DIR}/external/glfw/lib/win64")
elseif(APPLE)
    # Pick the GLFW static library matching the host CPU architecture.
    if(CMAKE_SYSTEM_PROCESSOR MATCHES "arm64|aarch64|ARM64")
        set(GLFW_LIB_DIR "${CMAKE_SOURCE_DIR}/external/glfw/lib/macos-arm64")
    else()
        set(GLFW_LIB_DIR "${CMAKE_SOURCE_DIR}/external/glfw/lib/macos-x86_64")
    endif()
else()
    message(FATAL_ERROR "Unsupported platform: this project ships prebuilt GLFW binaries for Windows and macOS only.")
endif()

find_library(GLFW_LOCAL_LIB
    NAMES glfw3 glfw
    PATHS "${GLFW_LIB_DIR}"
    NO_DEFAULT_PATH
)

if(NOT GLFW_LOCAL_LIB)
    message(FATAL_ERROR
        "GLFW library not found. Expected it at: ${GLFW_LIB_DIR}\n"
        "Run:\n"
        "  git submodule update --init --recursive\n"
        "or re-clone the repository with submodules to fetch the prebuilt binaries.")
endif()

if(WIN32)
    # Windows: static GLFW library plus the platform libs it depends on.
    target_link_libraries(LearnOpenGL PRIVATE
        ${GLFW_LOCAL_LIB}
        opengl32
        gdi32
        user32
        shell32
    )
elseif(APPLE)
    # macOS: static GLFW library plus Apple's native system frameworks.
    target_link_libraries(LearnOpenGL PRIVATE
        ${GLFW_LOCAL_LIB}
        "-framework OpenGL"
        "-framework Cocoa"
        "-framework IOKit"
        "-framework CoreVideo"
    )
endif()
