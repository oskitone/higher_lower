---
id: boot-the-microcontroller
title: Boot the microcontroller
description: How to get the Higher Lower's microcontroller working and booted up
sidebar_label: Boot the microcontroller
slug: /boot-the-microcontroller
---

## Steps

1. Solder capacitor **C1** (.1uF, marked 104) and resistor **R2** (1k, Brown Black Red).
2. Solder **U1** socket. It will have a dimple at one end, which should match the footprint on the PCB.
   - Solder two pins on opposite sides and verify the socket is perfectly flat before soldering the rest. If it's not and you try pushing it in, you can accidentally pop out a pin &mdash; not good!
3. With the power off, carefully insert the **ATtiny85** IC chip. It will have a dimple (and/or a small dot in a corner), which should match the socket.

## Test

Turn the power switch back on, and the a new color on the LED should flash. This lets you know that the chip is booted up and ready. Power off.

TODO: picture

Not working as expected? Check the [PCB troubleshooting](pcb-troubleshooting.md) section. Otherwise, continue to the next step.
