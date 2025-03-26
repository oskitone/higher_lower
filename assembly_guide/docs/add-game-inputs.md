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
   - **_Again, make sure they're absolutely flat against the PCB before soldering all of their pins._**
     [![switches flat against pcb](/img/switches_flat_against_pcb-007.jpg)](/img/switches_flat_against_pcb-007.jpg)
   - A way to do this is to solder one pin to hold the switch in place, then push it into the PCB while re-melting the solder; if there's any gap there it should pop in. Visually inspect to make sure it's good, then repeat with the pin on the _opposite corner_. Then inspect and do the remaining pins. It takes time but is worth it.

## Test

With board powered, pressing either **SW2** or **SW3** plays more tones out of the speaker and flashes **D1**.

[![switch push to test](/img/switch_push_to_test-019.jpg)](/img/switch_push_to_test-019.jpg)

Not working as expected? Check the [PCB troubleshooting](pcb-troubleshooting.md) section. Otherwise, continue to the next step.
