# Higher Lower

![Higher Lower game model animation](/misc/header-960-100.gif)

A handheld electronic game you can play with your eyes closed.

PCB is finalized. Kits and assembly documentation coming soon!

Obviously, I'd prefer you buy the kit from me. But, if circumstances prohibit, I've uploaded the [Higher Lower PCB to OSH Park](https://oshpark.com/shared_projects/yGNulCRo); please buy it from them with my blessing.

Assembly guide: [https://oskitone.github.io/higher_lower](https://oskitone.github.io/higher_lower)

### Schematic

![Higher Lower schematic](assembly_guide/static/img/higher_lower-schematic.svg)

## Running, deploying

    ./run.sh -h

Requires arduino-cli to compile, [Ardens](https://github.com/tiberiusbrown/Ardens) to emulate, then a [Sparkfun programmer](https://www.sparkfun.com/products/9825) to upload. (Other programmers may work just as well, but I've only tested this one.)

### Deployment troubleshooting

- `Could not find USBtiny device`: Programmer not connected?
- `Programmer operation not supported`: Make sure board is getting full power. Try setting "CTRL" pot to its middle value. (Some pins to programmer are shared with game inputs.)

### Arduboy

You can also deploy to an [Arduboy](https://www.arduboy.com/) using the Arduino IDE. Play using the device's Up/Down buttons.

![Higher Lower on Arduboy](/misc/arduboy.gif)

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

Designed by Oskitone. Please support future projects by purchasing from [Oskitone](https://www.oskitone.com/).

Creative Commons Attribution/Share-Alike, all text above must be included in any redistribution. See license.txt for additional details.

![Drawing, traces of speakers and batteries, prospective enclosure layouts](misc/drawing-parts.png)

(drawing by me and my son)
