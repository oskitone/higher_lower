#!/bin/bash

# Copied from digispark_test/upload.sh
# TODO: merge w/ run.sh

{

# Exit on error
set -o errexit
set -o errtrace

stub=$(ls arduino | xargs)
input_path="$PWD/arduino/${stub}"

BUILD_FOLDER="$PWD/build/digispark"
FULLY_QUALIFIED_BOARD_NAME="digistump:avr:digispark-tiny"

mkdir -pv "$BUILD_FOLDER"

# TODO: remove "--build-property" warning suppression
arduino-cli compile \
    --fqbn "$FULLY_QUALIFIED_BOARD_NAME" \
    --build-path="$BUILD_FOLDER" \
    --build-property "compiler.cpp.extra_flags=-w" \
    "$input_path"

echo "If already plugged in, unplug digispark..."
echo

arduino-cli upload \
    --fqbn "$FULLY_QUALIFIED_BOARD_NAME" \
    --input-dir "$BUILD_FOLDER"

rm -rf "$BUILD_FOLDER"

}
