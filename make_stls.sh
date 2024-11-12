#!/bin/bash

{

# Exit on error
set -o errexit
set -o errtrace

# Constants
openscad="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
timestamp=$(git log -n1 --date=unix --format="%ad" openscad)
commit_hash=$(git log -n1 --format="%h" openscad)

# Flags
bonk=
prefix="higher_lower"
dir="local/3d-models/$prefix-$timestamp-$commit_hash"
query=

# Internal variables
_found_matches=

function help() {
    echo "\
Renders STL models.

Usage:
./make_stls.sh [-hectb] [-p PREFIX] [-d DIRECTORY] [-q COMMA,SEPARATED,QUERY]

Usage:
./make_stls.sh                    Export all STLs
./make_stls.sh -h                 Show this message and quit
./make_stls.sh -e                 Echo out output directory and quit
./make_stls.sh -c                 Echo out commit hash and quit
./make_stls.sh -t                 Echo out timestamp and quit
./make_stls.sh -b                 Bonk and open folder when done
./make_stls.sh -p <prefix>        Set filename prefix
                                  Default is 'oskitone-apc'
./make_stls.sh -d <directory>     Set output directory
                                  Default is local/3d-models/<prefix>...
./make_stls.sh -q <query>         Export only STLs whose filename stubs match
                                  comma-separated query

Examples:
./make_stls.sh -p test -q switch  Exports test-...-switch_clutch.stl
./make_stls.sh -p wheels,enc      Exports oskitone-apc-...-wheels.stl,
                                  oskitone-apc-...-enclosure_bottom.stl,
                                  and oskitone-apc-...-enclosure_top.stl
"
}

function export_stl() {
    stub="$1"
    override="$2"

    function _run() {
        filename="$dir/$prefix-$timestamp-$commit_hash-$stub.stl"

        echo "Exporting $filename..."

        # The "& \" at the end runs everything in parallel!
        $openscad "openscad/higher_lower.scad" \
            --quiet \
            -o "$filename" \
            --export-format "binstl" \
            -D 'SHOW_ENCLOSURE_BOTTOM=false ' \
            -D 'SHOW_BATTERY_HOLDER=false ' \
            -D 'SHOW_BATTERIES=false ' \
            -D 'SHOW_PCB=false ' \
            -D 'SHOW_SWITCH_CLUTCH=false ' \
            -D 'SHOW_SPEAKER=false ' \
            -D 'SHOW_ROCKER=false ' \
            -D 'SHOW_ENCLOSURE_TOP=false ' \
            -D "$override=true" \
            & \
    }

    if [[ -z "$query" ]]; then
        _run
    else
        for query_iterm in "${query[@]}"; do
            if [[ "$stub" == *"$query_iterm"* ]]; then
                _found_matches=true
                _run
            fi
        done
    fi
}

function run() {
    mkdir -pv $dir >/dev/null
    echo "$dir"
    echo

    function finish() {
        # Kill descendent processes
        pkill -P "$$"
    }
    trap finish EXIT

    start=`date +%s`

    export_stl 'enclosure_bottom' 'SHOW_ENCLOSURE_BOTTOM'
    export_stl 'battery_holder' 'SHOW_BATTERY_HOLDER'
    export_stl 'pcb' 'SHOW_PCB'
    export_stl 'switch_clutch' 'SHOW_SWITCH_CLUTCH'
    export_stl 'rocker' 'SHOW_ROCKER'
    export_stl 'enclosure_top' 'SHOW_ENCLOSURE_TOP'
    wait

    end=`date +%s`
    runtime=$((end-start))

    if [[ "$query" && -z $_found_matches ]]; then
        echo "Found no matches for query '$query'"
    else
        if [[ $bonk ]]; then
            printf "\a"
            open $dir
        fi
    fi

    echo
    echo "Finished in $runtime seconds"
}

while getopts "h?b?p:d:e?c?t?q:" opt; do
    case "$opt" in
        h) help; exit ;;
        b) bonk=true ;;
        p) prefix="$OPTARG" ;;
        d) dir="$OPTARG" ;;
        e) echo "$dir"; exit ;;
        c) echo "$commit_hash"; exit ;;
        t) echo "$timestamp"; exit ;;
        q) IFS="," read -r -a query <<< "$OPTARG" ;;
        *) help; exit ;;
    esac
done

run "${query[@]}"

}
