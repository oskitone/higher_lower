#!/bin/bash

{

# Exit on error
set -o errexit
set -o errtrace

ardens="/Applications/Ardens/Ardens.app/Contents/MacOS/Ardens"

port="/dev/cu.usbmodem143101"

stub=$(ls arduino | xargs)
input_path="$PWD/arduino/${stub}"

arduboy_build_dir="$PWD/build/arduboy"
digispark_build_dir="$PWD/build/digispark"

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
    echo "COMPILING FOR ARDUBOY"
    echo

    mkdir -pv "${arduboy_build_dir}" >/dev/null
    arduino-cli compile \
        --fqbn "arduboy:avr:arduboy" \
        --build-path="${arduboy_build_dir}" \
        --verbose \
        "${input_path}"

    echo "COMPILING FOR DIGISPARK"
    echo

    mkdir -pv "${digispark_build_dir}" >/dev/null
    arduino-cli compile \
        --fqbn "digistump:avr:digispark-tiny" \
        --build-path="$digispark_build_dir" \
        --build-property "compiler.cpp.extra_flags=-w" \
        "${input_path}"

    echo
}

function emulate() {
    $ardens file="${arduboy_build_dir}/${stub}.ino.hex"
}

function upload() {
    echo "UPLOADING"
    echo

    echo "If already plugged in, unplug/reset/de-breadboard digispark..."
    echo

    arduino-cli upload \
        --fqbn "digistump:avr:digispark-tiny" \
        --input-dir "${digispark_build_dir}"

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