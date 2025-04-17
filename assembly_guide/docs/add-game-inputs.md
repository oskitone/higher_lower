---
id: add-game-inputs
title: Add game inputs
description: Connecting switch inputs to play Higher Lower
sidebar_label: Add game inputs
image: /img/switch_push_to_test-019.jpg
slug: /add-game-inputs
---

:::note
Take your time and make sure the switches are perfectly flat against the PCB before soldering all of their pins.
:::

## Step(s)

1. Solder SPST switches to **SW2** and **SW3**.
   [![switches flat against pcb](/img/switches_flat_against_pcb-007.jpg)](/img/switches_flat_against_pcb-007.jpg)
   Make sure they're absolutely flat against the PCB before soldering all of their pins.

## Test

With board powered, pressing either **SW2** or **SW3** plays more tones out of the speaker and flashes **D1**.

[![switch push to test](/img/switch_push_to_test-019.jpg)](/img/switch_push_to_test-019.jpg)

Not working as expected? Check the [PCB troubleshooting](pcb-troubleshooting.md) section. Otherwise, continue.

## How it works

These kinds of switches are SPST, or Single-Pole Single-Throw. Despite having four pins, they're about as simple as a switch can be. When pressed, an internal connection is closed; when it's not pressed, it's open. Both sides of that connection have two pins, so there're four pins total.

**SW2** and **SW3** connect to two input pins on the **ATtiny85**.

The inputs are "held high" by the microcontroller, meaning that there's a small current of positive voltage on them. But pressing a switch instead brings them low to ground, and that voltage change can be interpreted by the **ATtiny85** as a button press. Pretty cool!
