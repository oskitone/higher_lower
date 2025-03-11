---
id: make-some-noise
title: Make some noise
description: How to start getting noises out of Higher Lower
sidebar_label: Make some noise
slug: /make-some-noise
---

## Steps

1. Solder trim potentiometer (aka "trimpot") **RV2** (1k, marked "102") and capacitor **C2** (220uF).
   - Make sure **RV2** is pushed all the way into PCB before soldering all the way. You can use a bit of tape or "Blu-Tack" adhesive to hold it in place as you solder.
   - **C2** has polarity. Match its white side to the white side of its footprint.
2. Wire speaker to **LS1**.
   1. Thread remaining ribbon cable through hole.
      TODO: picture
   2. Strip insulation and solder to **LS1**.
   3. Strip and solder the other ends to the speaker, matching the "+" and "-" sides.

## Test

Sliding **SW1** to power the board, a little tune plays out of the speaker and **RV2** controls its volume (try adjusting it with a screwdriver). This is the "Higher Lower" theme song!

Not working as expected? Check the [PCB troubleshooting](pcb-troubleshooting.md) section. Otherwise, continue to the next step.
