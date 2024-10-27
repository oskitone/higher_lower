#!/bin/bash

{

# Exit on error
set -o errexit
set -o errtrace

_packages="$HOME/Library/Arduino15/packages"
avrdude="${_packages}/arduino/tools/avrdude/6.3.0-arduino17/bin/avrdude"
avrdude_config="${_packages}/ATTinyCore/hardware/avr/1.5.2/avrdude.conf"

ardens="/Applications/Ardens/Ardens.app/Contents/MacOS/Ardens"

port="/dev/cu.usbmodem143101"

stub=$(ls arduino | xargs)
input_path="$PWD/arduino/${stub}"

arduboy_build_dir="$PWD/build/arduboy"
attiny85_build_dir="$PWD/build/attiny85"

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

function compile_for_arduboy() {
    echo "COMPILING FOR ARDUBOY"
    echo

    mkdir -pv "${arduboy_build_dir}" >/dev/null
    arduino-cli compile \
        --fqbn "arduboy:avr:arduboy" \
        --build-path="${arduboy_build_dir}" \
        --verbose \
        "${input_path}"

    echo
}

function compile_for_attiny85() {
    echo "COMPILING FOR ATTINY85"
    echo

    mkdir -pv "${attiny85_build_dir}" >/dev/null
    arduino-cli compile \
        --fqbn "ATTinyCore:avr:attinyx5:clock=4internal" \
        --build-path="$attiny85_build_dir" \
        "${input_path}"

    echo
}

function emulate() {
    $ardens file="${arduboy_build_dir}/${stub}.ino.hex"
}

function upload_with_programmer() {
    echo "UPLOADING"
    echo

    $avrdude \
        -C"$avrdude_config" \
        -v \
        -pattiny85 \
        -cusbtiny \
        -B8 \
        -U"flash:w:$attiny85_build_dir/higher_lower.ino.hex:i"

    echo
}

if [ "$1" == '-h' ]; then
    help
    exit
fi

if [ "$1" == 'compile' ]; then
    compile_for_arduboy
    compile_for_attiny85
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

    compile_for_attiny85
    upload_with_programmer

    # TODO: offer advice on "programmer operation not supported"
    # could be CTRL pot needs adjustment

    exit
fi

while true; do
    compile_for_arduboy
    emulate

    echo
    echo "!! Press CTRL+C to quit !!"
    echo
done

}