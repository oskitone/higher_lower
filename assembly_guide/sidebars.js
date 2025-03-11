// @ts-check

/**
@type {import('@docusaurus/plugin-content-docs').SidebarsConfig}
 */

const sidebars = {
  docsSidebar: {
    "Getting Starfted": ["what-youll-be-making", "inventory"],
    "3D-Printing": ["3d-printing-parts-and-slicing"],
    "PCB Assembly": [
      "general-tips",
      "assemble-battery-pack",
      "power-up",
      "boot-the-microcontroller",
      "get-logical",
      "make-some-noise",
      "prep-for-hacking",
    ],
    Assembly: ["final-assembly", "care"],
    Hacking: ["change-the-arduino-code"],
    Appendix: [
      "bom",
      "pcb-troubleshooting",
      "opening-the-enclosure",
      "schematics",
      "source-and-license",
    ],
  },
};

export default sidebars;
