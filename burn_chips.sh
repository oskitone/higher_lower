#!/bin/bash

{

# INTENTIONAL: don't exit on error
# set -o errexit
# set -o errtrace

function wait_for_space_key() {
    read -s -d ' '
}

./run.sh compile

while true; do
    start=`date +%s`

    ./run.sh upload

    end=`date +%s`
    runtime=$((end-start))

    echo
    echo "Done! Finished in $runtime seconds."
    echo "Press SPACE to burn another chip or CTRL+C to quit."
    wait_for_space_key

    echo
done

}
