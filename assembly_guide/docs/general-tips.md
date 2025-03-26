---
id: general-tips
title: General tips and getting started
description: Things to keep in mind as you solder your Higher Lower game
sidebar_label: General tips and getting started
image: /img/dip_socket_tape-021.jpg
slug: /general-tips
---

:::note
Take your time and be patient! If you run into a problem, try to keep a cool head and refer to the [PCB troubleshooting](pcb-troubleshooting.md) section. If your problem remains unfixed and you can't figure it out, [please _email_ me to let me know](https://www.oskitone.com/contact)! I'll do my best to help you, and your feedback will help improve the guide and other future Oskitone designs.
:::

## General tips

- **Component colors**<br />
  This guide's components' brands and body colors (and even the PCB color itself) may look different from yours, and that's okay! What's important is that the part types and values are in the right spots.
- **Resistors are labeled with colors, capacitors with numbers**<br />
  Resistors' values are marked as colored bands on their body. Ceramic capacitors use a number system to denote their value.
- **Ceramic and electrolytic capacitors**<br />
  There are two kinds of “caps” used in this kit. Ceramic capacitors are small, circular, and have no polarity; they can be placed in either direction. Electrolytic caps are bigger, cylindrical, and have marked +/- polarities.
- **ICs in sockets**<br />
  Each IC chip comes with a corresponding socket with the same number of pins. You will solder the socket to the PCB, not the chip itself. This prevents overheating the IC with the soldering iron and makes it easier to switch a faulty one out.
- **Component polarities**<br />
  LEDs, batteries, and electrolytic capacitors have positive and negative leads. Where applicable, the PCB will be labeled where each lead goes or a component outline to denote orientation.
- **IC orientation**<br />
  The IC chips also have an orientation, marked by a notch at their top. Make sure these line up when soldering the sockets and again when inserting the chips. A chip can be permanently damaged if inserted incorrectly!
- **Get tricky/sticky with short-lead components**<br />
  Components with short leads can be hard to get to stay on the PCB, because you can't really bend their leads to get them to stay put. But there are tricks! Try using tape or "Blu-Tack" adhesive to hold them.
  [![dip socket tape](/img/dip_socket_tape-021.jpg)](/img/dip_socket_tape-021.jpg)
  Or, clip the solder into your "holding hands", and try bringing the _board to the solder_ (instead of the typical reverse of solder to board).
- **Components flat against PCB**<br />
  Many of the PCB's components need to be perfectly flat against the board for the final assembly. You'll see extra callouts in the instructions when that's important.

## Let's get started!

For reference, we'll end up with something like this when we're done:

[![Higher Lower, final product](/img/final_product_3-018.jpg)](/img/final_product_3-018.jpg)

### How this guide is organized

Each group of steps in this guide has a test at the end to make sure everything you just did is working as expected, ie: "Make sure the LED lights up", "Make sure the microcontroller works", "Make sure the speaker has sound", etc.

If it doesn't work, don't fret! Look over the [PCB troubleshooting](pcb-troubleshooting.md) tips. Don't move on in the instructions until you've got the test working.

:::note Note for the experienced/impatient
The guide's steps are intentionally ordered. If you don't want to follow the guide, that's okay! But it may be harder to debug later if anything doesn't work as expected.
:::
