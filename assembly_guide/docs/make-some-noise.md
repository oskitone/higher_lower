---
id: make-some-noise
title: Make some noise
description: How to start getting noises out of Higher Lower
sidebar_label: Make some noise
image: /img/test_speaker-022.jpg
slug: /make-some-noise
---

## Steps

1. Solder trim potentiometer (aka "trimpot") **RV2** (1k, marked "102").
   - Make sure **RV2** is pushed all the way into PCB before soldering all of its pins.
     [![rv2](/img/rv2-004.jpg)](/img/rv2-004.jpg)
2. Wire speaker to **LS1**.
   1. Thread remaining piece of ribbon cable through the hole by **LS1**.
   2. Separate wires and strip 1/4" of insulation, then solder to **LS1**.
      [![thread strip solder ls1 wires](/img/thread_strip_solder_ls1_wires-014.jpg)](/img/thread_strip_solder_ls1_wires-014.jpg)
   3. Strip and solder the other ends to the speaker, matching the "+" and "-" sides.
      [![solder speaker](/img/solder_speaker-028.jpg)](/img/solder_speaker-028.jpg)
3. Solder capacitor **C2** (220uF).
   - **C2** has polarity. Match its white side to the white side of its footprint.
     [![c2](/img/c2-028.jpg)](/img/c2-028.jpg)

## Test

Sliding **SW1** to power the board, a little tune plays out of the speaker. This is the "Higher Lower" game theme song!

[![test speaker](/img/test_speaker-022.jpg)](/img/test_speaker-022.jpg)

Adjust **RV2** with a screwdriver for volume control.

[![screwdriver to adjust rv2](/img/screwdriver_to_adjust_rv2-022.jpg)](/img/screwdriver_to_adjust_rv2-022.jpg)

Not working as expected? Check the [PCB troubleshooting](pcb-troubleshooting.md) section. Otherwise, continue.

## How it works

One of the pins on the **ATtiny85** is tasked with outputting square waves by quickly alternating between low and high voltage.

It connects to variable resistor **RV2**, which works the same way that the **R1** resistor did when you lit the LED: it limits current. The _variable_ part of **RV2** means that how much it limits is set by turning its dial. A higher resistance (measured in Ω or "ohms") means a smaller current which means a quieter sound from the speaker.

Variable resistors are called potentiometers (or "pots"), and small potentiometers like these are trimmers (or, adorably, "trimpots").

**C2** is a coupling capacitor. Think of it like a big bucket that fills up with voltage before dumping it at the speaker.

When that voltage drives an electromagnet that vibrates a cone inside the speaker, it creates ripples in the air that eventually reach your ears as sound waves.
