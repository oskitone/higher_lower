---
id: add-game-inputs
title: Add game inputs
description: Connecting switch inputs to play Higher Lower
sidebar_label: Add game inputs
slug: /add-game-inputs
---

:::note
Take your time and make sure the switches are perfectly flat against the PCB before soldering all of their pins.
:::

## Steps

1. Solder SPST switches to **SW2** and **SW3**.
   - **_Make sure they're absolutely flat against the PCB before soldering all of their pins._**
   - One way to do this is to solder one pin to hold it in place, then use one hand to push it into the PCB while melting the solder with your other hand; if there's any gap there it should pop in. Visually inspect to make sure it's good, then repeat with the pin on the _opposite corner_. Then inspect and do the remaining pins. It takes time but is worth it.

## Test

With board powered, pressing either **SW2** or **SW3** plays more tones out of the speaker and flashes **D1**.

TODO: picture

Not working as expected? Check the [PCB troubleshooting](pcb-troubleshooting.md) section. Otherwise, continue to the next step.
