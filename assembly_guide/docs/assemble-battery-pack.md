---
id: assemble-battery-pack
title: Assemble battery pack
description: How to assemble Higher Lower's battery pack
sidebar_label: Assemble battery pack
slug: /assemble-battery-pack
---

:::note
Your ribbon cable may have different colors from the pictures here, and that's okay! A common convention is to use the darker color for "-" and the lighter one for "+".
:::

## Steps

1. Insert tabbed battery contact terminals
   1. The springed contact goes to the spot with a "-".
   2. The flat, button contact goes near "+". Its button should face inward towards where the battery will be.
   3. These tabbed contacts will have a tight fit! You can use pliers to push/pull them in, then fold their tabs over to hold them in place.
      TODO: picture
2. Insert wire dual contact
   1. Again, spring goes to "-" and button to "+".
      TODO: picture
3. Add wire
   1. Cut your ribbon cable into two pieces of about 5" and 3". (TODO: confirm, re: BOM)
   2. Thread the 5" ribbon cable through the relief hitch on the bottom of the battery holder.
      TODO: picture
   3. Separate both ends of the ribbon cable, then strip 1/4" of insulation off all four of them.
   4. On the side of the cable closer to the battery contact tabs, solder the darker wire to the "-" spring tab and the lighter wire to the "+" button tab. Try not to melt the battery holder's plastic!
   5. Pull the cable back and away from the soldered tabs until it's taut. Separate and strip the other side of wires. Make sure they don't touch!
      TODO: picture
   6. Insert two AAA batteries, matching their "+" and "-" sides to the battery holder's labels.

## Test

Using a multimeter, measure the total voltage on those two wires. It should measure the sum of the two individual batteries' voltages -- ideally 2.4 to 3, depending on what kind of batteries they are. When done, remove one or both batteries to prevent accidentally draining them if the exposed wires touch.

TODO: picture

If you're having trouble with your multimeter, try measuring each battery individually and see if they read as you expect. Then install them into the battery pack and check their combined voltage.

Not working as expected? Check the [PCB troubleshooting](pcb-troubleshooting.md) section. Otherwise, continue to the next step.
