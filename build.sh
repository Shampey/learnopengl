#!/bin/sh
set -e

# Configure the native macOS preset (architecture is auto-detected:
# arm64 on Apple Silicon, x86_64 on Intel).
cmake --preset macos-native

# Build and run.
cmake --build --preset macos-native -j"$(sysctl -n hw.logicalcpu)"
./build/LearnOpenGL