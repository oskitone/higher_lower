#!/bin/bash

{

# Exit on error
set -o errexit
set -o errtrace

ardens="/Applications/Ardens/ArdensPlayer.app/Contents/MacOS/ArdensPlayer"

fbqn="arduboy:avr:arduboy"
port="/dev/cu.usbmodem143101"

stub=$(ls arduino | xargs)
input_path="$PWD/arduino/${stub}/${stub}.ino"
build_dir="$PWD/build"
build_path="${build_dir}/${stub}.ino.hex"

function help() {
    echo "\
CLI wrapper around Arduino and Ardens

Usage:
./run.sh -h                 Show help and exit

./run.sh compile            Compile
./run.sh emulate            Emulate
./run.sh dev                Compile and emuluate
                            Looped! Quit emulator to refresh
./run.sh deploy             Compile and upload
                            Default port: $port
./run.sh deploy -p PORT     ^ with arbitrary port
                            Run 'arduino-cli board list' for list

"
}

if [ "$1" == '-h' ]; then
    help
    exit
fi

function compile() {
    mkdir -pv "${build_dir}" >/dev/null

    echo "COMPILING"
    echo

    arduino-cli compile \
        --fqbn "${fbqn}" \
        --build-path="${build_dir}" \
        --verbose \
        "${input_path}"

    echo
}

function emulate() {
    $ardens file="${build_path}"
}

function upload() {
    echo "UPLOADING"
    echo

    arduino-cli upload \
        --fqbn "${fbqn}" \
        --port "${port}" \
        --verbose \
        --input-file "${build_path}"

    echo
}

if [ "$1" == '-h' ]; then
    help
    exit
fi

if [ "$1" == 'compile' ]; then
    compile
    exit
fi

if [ "$1" == 'emulate' ]; then
    emulate
    exit
fi

if [ "$1" == 'deploy' ]; then
    if [ "$2" == '-p' ]; then
        port="$3"
    fi

    compile
    upload

    exit
fi

while true; do
    compile
    emulate

    echo
    echo "!! Press CTRL+C to quit !!"
    echo
done

}