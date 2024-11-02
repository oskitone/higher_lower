# Higher Lower

![Drawing, traces of speakers and batteries, prospective enclosure layouts](misc/drawing-parts.png)

A handheld electronic game you can play with your eyes closed.

In development!

## TODO

- Reduce power usage
- Finalize circuit
- PCB + enclosure fit
- Minimum viable Arduboy setup

## Running

    ./run.sh -h

Requires arduino-cli to compile, [Ardens](https://github.com/tiberiusbrown/Ardens) to emulate, then a [Sparkfun programmer](https://www.sparkfun.com/products/9825) to upload. (Other programmers may work just as well, but I've only tested this one.)

## 3D Models

higher_lower's 3D-printed models are written in OpenSCAD.

### Dependencies

Assumes `parts_cafe` and `scout` repos are in sibling directories and are _both up to date_ on the `main` branch. Here's how I've got it:

    \ oskitone
        \ higher_lower
        \ parts_cafe
        \ scout

You'll also need to install the [Orbitron](https://fonts.google.com/specimen/Orbitron) font.

### Building

STLs are generated with `make_stls.sh`. Run `./make_stls.sh -h` for full flags list.

## License

Designed by Oskitone. Please support future synth projects by purchasing from [Oskitone](https://www.oskitone.com/).

Creative Commons Attribution/Share-Alike, all text above must be included in any redistribution. See license.txt for additional details.
