---
id: boot-the-microcontroller
title: Boot the microcontroller
description: How to get the Higher Lower's microcontroller working and booted up
sidebar_label: Boot the microcontroller
image: /img/test_microcontroller-028-60.gif
slug: /boot-the-microcontroller
---

## Steps

1. Solder **U1** socket. It will have a dimple at one end, which should match the footprint on the PCB.
   [![dip socket flat against pcb](/img/dip_socket_flat_against_pcb-019.jpg)](/img/dip_socket_flat_against_pcb-019.jpg)
   Verify the socket is perfectly flat against the PCB before soldering all of its pins. If it's not flat and you try pushing it in, you can accidentally pop out a pin &mdash; not good!
1. Solder capacitor **C1** (.1uF, marked 104) and resistor **R2** (1k, Brown Black Red).
   [![r2 and c1](/img/r2_and_c1-013.jpg)](/img/r2_and_c1-013.jpg)
1. If necessary, bend the pins of the **ATtiny85** IC chip so that they're parallel to each other, like this:
   [![dip chip pins](/img/dip_chip_pins-015.jpg)](/img/dip_chip_pins-015.jpg)
1. With the power off, carefully insert the **ATtiny85** IC chip. It will have a dimple (and/or a small dot in a corner), which should match the socket.
   [![dip chip into socket](/img/dip_chip_into_socket-011.jpg)](/img/dip_chip_into_socket-011.jpg)

## Test

Turn the power switch back on, and the LED should flash a new color. This lets you know that the chip is booted up and running! Power off.

[![test_microcontroller-028-60](/img/test_microcontroller-028-60.gif)](/img/test_microcontroller-028-60.gif)

Not working as expected? Check the [PCB troubleshooting](pcb-troubleshooting.md) section. Otherwise, continue to the next step.
