---
id: power-up
title: Power up
description: Getting power to Higher Lower's PCB and toggling an LED
sidebar_label: Power up
image: /img/reinsert_battery_and_flip_switch_to_test-008-r-60.gif
slug: /power-up
---

:::tip
The SPST switch has very short legs and won't stay in the PCB, making it tricky to solder. You can use a bit of tape to hold it in place as you solder. See the [general tips](general-tips) section for other advice.
:::

## Steps

1. Wire battery pack to **BT1**
   1. Thread the loose end of the ribbon cable connected to the battery pack up through the hole near **BT1**.
      [![strip wire and thread through bt1 relief hole](/img/strip_wire_and_thread_through_bt1_relief_hole-022.jpg)](/img/strip_wire_and_thread_through_bt1_relief_hole-022.jpg)
   2. Strip its wires and solder in place. Make sure the "+" and "-" wires are going to the right places.
      [![bt1 soldered](/img/bt1_soldered-012.jpg)](/img/bt1_soldered-012.jpg)
2. Solder RGB LED at **D1**
   1. The LED has four pins for three different colors plus ground. The longest one is to ground and it goes to the hole that has a line coming out of it.
      [![rgb led](/img/rgb_legs-012.jpg)](/img/rgb_legs-012.jpg)
   2. Push the LED into the PCB as far as you can; it doesn't have to be flat against the PCB but does need to be straight up and down &mdash; no leaning!
      [![rgb led pushed into pcb](/img/rgb_led_pushed_into_pcb-1-018.jpg)](/img/rgb_led_pushed_into_pcb-1-018.jpg)
3. Solder sliding toggle switch **SW1** and resistor **R1** (1k, Brown Black Red).
   1. Make sure the switch is flat against the PCB and its actuator is pointing left, away from the PCB.
      [![spst flat against pcb](/img/spst_flat_against_pcb-003.jpg)](/img/spst_flat_against_pcb-003.jpg)

## Test

Add the batteries back into the battery holder. Toggling **SW1** should now light one color of the LED! Power off before continuing soldering.

[![reinsert battery and flip switch to test](/img/reinsert_battery_and_flip_switch_to_test-008-r-60.gif)](/img/reinsert_battery_and_flip_switch_to_test-008-r-60.gif)

Not working as expected? Check the [PCB troubleshooting](pcb-troubleshooting.md) section. Otherwise, continue.

## How it works

<!-- Let's start with "What even is an RGB LED?"

LED stands for Light Emitting Diode. A diode is a component that only allows electricity to move through it in one direction, and LEDs are diodes that light up. Typically, LEDs only shine specific colors, like the red one on your TV or the annoying bright white one on your electric toothbrush. -->

An RGB LED is a **L**ight-**E**mitting **D**iode with three pins for the colors **R**ed, **G**reen, and **B**lue.

This RGB LED is common cathode, so the longest pin goes to ground (the "-" side of the battery). The other kind of RGB LED is common anode, where the longest pin goes high to voltage (the "+" side of the battery).

LEDs can burn out if they're supplied too much electricity. While there's not much risk of that with just the two AAA batteries, the resistor at **R1** limits the current supplied to prevent burnout and, more importantly, make sure the LED doesn't shine too bright.

Toggling **SW1** completes the circuit so that electricity can flow from the battery, through the resistor, to the LED, and finally back into the battery.

<!-- TODO: schematic -->

<!-- - VCC means "Voltage Common Collector," a technical way to say the "+" side of our batteries
- GND means "Ground," or the batteries' "-" side
- So we have VCC going through a current-limiting resistor into the green pin of the RGB LED and then finally into GND -->
