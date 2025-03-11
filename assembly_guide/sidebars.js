// @ts-check

/**
@type {import('@docusaurus/plugin-content-docs').SidebarsConfig}
 */

const _doc = (id) => ({
  type: "doc",
  id,
});

const _category = (label, docIds = []) => ({
  label,
  type: "category",
  items: docIds.map((id) => _doc(id)),
});

const sidebars = {
  docsSidebar: [
    _category("Getting Started", ["what-youll-be-making", "inventory"]),
    _doc("3d-printing-parts-and-slicing"),
    _category("PCB Assembly", [
      "general-tips",
      "assemble-battery-pack",
      "power-up",
      "boot-the-microcontroller",
      "make-some-noise",
      "add-game-inputs",
      "control-difficulty",
      "prep-for-hacking",
    ]),
    _category("Assembly and Care", ["final-assembly", "care"]),
    _category("Appendix", [
      "bom",
      "pcb-troubleshooting",
      "opening-the-enclosure",
      "schematics",
      "source-and-license",
    ]),
  ],
};

export default sidebars;
