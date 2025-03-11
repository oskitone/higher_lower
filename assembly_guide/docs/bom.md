---
id: bom
title: Annotated BOM
description: Bill of Materials, annotated.
sidebar_label: Annotated BOM
slug: /bom
hide_table_of_contents: true
---

| Designator | Quantity | Designation        | Marking         | Footprint                                         |
| ---------- | -------- | ------------------ | --------------- | ------------------------------------------------- |
| C1         | 1        | .1uF               | 104             | C_Disc_D5.0mm_W2.5mm_P5.00mm                      |
| C2         | 1        | 220uF              |                 | CP_Radial_D8.0mm_P3.50mm                          |
| D1         | 1        | LED_RKGB           |                 | LED_D5.0mm-4_RGB_Staggered_Pins                   |
| J1         | 1        | Conn_02x03         |                 | PinHeader_2x03_P2.54mm_Vertical                   |
| LS1        | 1        | AZ40R              |                 | 40mm x 5mm                                        |
| R1,R2      | 2        | 1k                 | Brown Black Red | R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal |
| RV1        | 1        | 10k                | 103             | Potentiometer_Piher_PT-6-V_Vertical-mirror        |
| RV2        | 1        | 1k                 | 102             | Potentiometer_Piher_PT-6-V_Vertical-mirror        |
| SW1        | 1        | SW_SPDT            |                 | SW_Slide_SPDT_Angled_CK_OS102011MA1Q              |
| SW2,SW3    | 2        | SW_SPST            |                 | SW_PUSH_6mm                                       |
| U1         | 1        | ATTINY85V + socket |                 | DIP-8_W7.62mm                                     |

Also:

- 8" of 2-wire ribbon cables (or similar _small_ gauge, stranded wire)
  - 5" for BT1
  - 3" for LS1
  - TODO: reduce / where'd I define that?s
- 4 battery terminal contacts for battery holder
  - 1 dual spring+button wire contacts (Keystone 181)
  - 1 tabbed spring contact (Keystone 5204)
  - 1 tabbed button contact (Keystone 5226)
- LED lightpipe
  - Hot glue stick, standard 1/4" diameter, cut to 1/4" length
  - An inch or so of electrical tape

Alternate speakers for the AZ40R:

- PSR-40N08A05-JQ
- AS04008MR-21-R
- CMS-4051-058SP

Any circular 8ohm speaker that matches the dimensions will probably work, thought you may find you need a bit of hot glue to hold it in place.
