#!/usr/bin/env bash

PATCHES_DIR=/patches

# Docker image includes cpp, but not cc
git apply $PATCHES_DIR/driver-cpp.patch
