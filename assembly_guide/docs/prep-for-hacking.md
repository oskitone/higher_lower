---
id: prep-for-hacking
title: Prep for hacking
description: Optionally solder the parts required to change the Higher Lower's code
sidebar_label: Prep for hacking
image: /img/tape_on_j1_header-003.jpg
slug: /prep-for-hacking
---

:::note
If you have no intention of ever changing the game's code, you can skip this part and it will work perfectly fine. But, you know, you're here, so you might as well!
:::

## Steps

1. Solder **J1** header.
   - Try to get it flat against PCB, as usual. Here, I'm using some tape to hold in in place.
     [![tape on j1 header](/img/tape_on_j1_header-003.jpg)](/img/tape_on_j1_header-003.jpg)

## <del>Test</del> All done?!

This one is harder to test, but if you've got it soldered and all the previous steps' tests passed, you're good to go!

:::note No but really
J1 is a header that connects to a programmer, letting you upload new code to the microcontroller. Code and basic usage are described in the [project's github repo](https://github.com/oskitone/higher_lower). It's a bit advanced, so, for now, it's been left out of the assembly guide.

Please [_email_ me to let me know](https://www.oskitone.com/contact) how it goes or if you need any help.
:::

## How it works

The 2x3 header at J1 connects to six pins on the ATtiny85 used for In-Circuit Serial Programming (ICSP), a method for updating a chip's functionality without having to send it back to the factory.
