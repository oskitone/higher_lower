---
id: pcb-troubleshooting
title: PCB troubleshooting
description: Common problems that come up when soldering the Scout PCB.
sidebar_label: PCB troubleshooting
slug: /pcb-troubleshooting
---

## General tips

Any of these problems can cause a variety of "just not working right" errors in a circuit. Familiarize yourself with these troubleshooting checks and do them regularly.

- Turn the PCB over and check all solder joints. A majority of problems are caused by insufficient or errant soldering. Familiarize yourself with what a good joint looks like in the [Adafruit Guide To Excellent Soldering](https://learn.adafruit.com/adafruit-guide-excellent-soldering).
- Are all chips in the right orientation? Each has a notch/dimple that should match the footprint outline on the PCB.
- Do the batteries have enough power? The three batteries should have a total voltage of 3.6 to 4.5 volts. If the Scout seems like it's restarting a lot as you play it, that's a good sign the batteries need replacing.

## Specific issues

- If there’s buzzing, check for any metal scraps stuck to the speaker’s magnet.
- If the buttons are touchy or behaving weird, check to see that their switches are inserted all the way and perfectly flat against the PCB.
- If you're hearing an unwanted hum from the speaker when the game isn't being played, verify C1 cap is soldered well. It may also be from noise added by long wires, so do use the recommended wire lengths in this guide.
