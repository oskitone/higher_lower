---
id: make-some-noise
title: Make some noise
description: How to start getting noises out of Higher Lower
sidebar_label: Make some noise
slug: /make-some-noise
---

## Steps

1. Solder trim potentiometer (aka "trimpot") **RV2** (1k, marked "102") and capacitor **C2** (220uF).
   - Make sure **RV2** is pushed all the way into PCB before soldering all of its pins.
     [![rv2](/img/rv2-004.jpg)](/img/rv2-004.jpg)
   - **C2** has polarity. Match its white side to the white side of its footprint.
2. Wire speaker to **LS1**.
   1. Thread remaining ribbon cable through hole.
   2. Strip insulation and solder to **LS1**.
      [![thread strip solder ls1 wires](/img/thread_strip_solder_ls1_wires-014.jpg)](/img/thread_strip_solder_ls1_wires-014.jpg)
   3. Strip and solder the other ends to the speaker, matching the "+" and "-" sides.
      [![solder speaker](/img/solder_speaker-028.jpg)](/img/solder_speaker-028.jpg)

## Test

Sliding **SW1** to power the board, a little tune plays out of the speaker. This is the "Higher Lower" game theme song!

[![test speaker](/img/test_speaker-022.jpg)](/img/test_speaker-022.jpg)

Then, try adjusting **RV2** with a screwdriver. This is the volume control.

[![screwdriver to adjust rv2](/img/screwdriver_to_adjust_rv2-022.jpg)](/img/screwdriver_to_adjust_rv2-022.jpg)

Not working as expected? Check the [PCB troubleshooting](pcb-troubleshooting.md) section. Otherwise, continue to the next step.
