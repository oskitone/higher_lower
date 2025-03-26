---
id: power-up
title: Power up
description: Getting power to Higher Lower's PCB and toggling an LED
sidebar_label: Power up
slug: /power-up
---

<!-- TIP: here or in previous step, remove a battery to prevent draining the batteries if the the "+" and "-" wires accidentally touch -->

:::tip
The SPST switch has very short legs and won't stay in the PCB, making it tricky to solder. You can use a bit of tape or "Blu-Tack" adhesive to hold the switch in place as you solder. <!-- TODO: link/combine w/ general tips -->
:::

## Steps

1. Solder LED at **D1**
   1. The LED has four pins for three different colors plus ground. The longest one is to ground and it goes to the hole that has a line coming out of it.
   2. Get the LED as vertically close to the PCB as reasonable; it doesn't have to be flat against PCB but does need to be straight up and down -- no leaning!
      [![rgb led pushed into pcb](/img/rgb_led_pushed_into_pcb-1-018.jpg)](/img/rgb_led_pushed_into_pcb-1-018.jpg)
2. Solder sliding toggle switch **SW1** and resistor **R1** (1k, Brown Black Red).
   1. Make sure the switch is flat against the PCB and its actuator is pointing left, away from the PCB.
      [![spst flat against pcb](/img/spst_flat_against_pcb-003.jpg)](/img/spst_flat_against_pcb-003.jpg)
3. Wire battery pack to **BT1**
   1. Thread the other side of the ribbon cable connected to the battery pack up through the hole near **BT1**.
      [![strip wire and thread through bt1 relief hole](/img/strip_wire_and_thread_through_bt1_relief_hole-022.jpg)](/img/strip_wire_and_thread_through_bt1_relief_hole-022.jpg)
   2. Strip its wires and solder in place. Make sure the "+" and "-" wires are going to the right places.
      [![bt1 soldered](/img/bt1_soldered-012.jpg)](/img/bt1_soldered-012.jpg)

## Test

Add the batteries back into the battery holder. Toggling **SW1** should now light one color of the LED! Power off before continuing soldering.

<!-- TODO: remake and mask out battery hand -->

[![reinsert_battery_and_flip_switch_to_test-008-60](/img/reinsert_battery_and_flip_switch_to_test-008-60.gif)](/img/reinsert_battery_and_flip_switch_to_test-008-60.gif)

Not working as expected? Check the [PCB troubleshooting](pcb-troubleshooting.md) section. Otherwise, continue to the next step.
