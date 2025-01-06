include <../../parts_cafe/openscad/ghost_cube.scad>;
include <../../parts_cafe/openscad/ghost_cylinder.scad>;
include <../../parts_cafe/openscad/led.scad>;
include <../../parts_cafe/openscad/spst.scad>;
include <../../parts_cafe/openscad/switch-OS102011MA1QN1.scad>;

use <../../scout/openscad/switch_clutch.scad>;

PCB_WIDTH = 2.5 * 25.4;
PCB_LENGTH = 1.5 * 25.4;
PCB_HEIGHT = 1.6;

PCB_MINIMUM_LENGTH = 25.4; // NOTE: arbitrary but reasonable!

function get_translated_xy(xy) = (
    [xy.x - 4 * 25.4, 4.5 * 25.4 - xy.y]
);

// Copied from higher_lower.kicad_pcb
PCB_HOLE_POSITIONS = [
    get_translated_xy([157.400992, 110.49]),
    get_translated_xy([152.4, 84.455]),
    get_translated_xy([105.41, 110.49]),
    get_translated_xy([160.02, 84.455]),
    get_translated_xy([133.35, 79.375]),
];
PCB_HOLE_DIAMETER = 3.2;

PCB_BIG_CAP_HEIGHT = 12.2;
PCB_BIG_CAP_DIAMETER = 8.28; // TODO: use'm or lose'm
PCB_TRIMPOT_HEIGHT = 8.1; // TODO: use'm or lose'm
PCB_SOCKET_HEIGHT = 8.4;
PCB_TOP_CLEARANCE_BEYOND_SPEAKER = PCB_BIG_CAP_HEIGHT;
PCB_TOP_CLEARANCE_UNDER_SPEAKER = PCB_SOCKET_HEIGHT;

// ie, trimmed leads and solder joints on bottom
PCB_BOTTOM_CLEARANCE = 2;

PCB_SWITCH_Y = 16.54;

PCB_LED_POSITION = get_translated_xy([102.746 + 2.5, 78.742 + .75]);
PCB_Z_OFF_PCB = 1;

PCB_SWITCH_POSITONS = [
    get_translated_xy([154.150992, 91.14089]),
    get_translated_xy([160.650992, 103.26089]),
];

PCB_SWITCH_CENTERS = [
    [PCB_SWITCH_POSITONS[0].x + 6.5 / 2, PCB_SWITCH_POSITONS[0].y - 4.5 / 2],
    [PCB_SWITCH_POSITONS[1].x - 6.5 / 2, PCB_SWITCH_POSITONS[1].y + 4.5 / 2],
];

module pcb(
    show_board = true,
    show_silkscreen = true,
    show_switches = true,
    show_led = true,

    show_clearance = false,

    width = 0,
    length = 0,
    height = PCB_HEIGHT,

    speaker_position = [0,0],
    led_position = PCB_LED_POSITION,
    switch_centers = PCB_SWITCH_CENTERS,

    side_switch_position = 0,

    top_clearance_beyond_speaker = PCB_TOP_CLEARANCE_BEYOND_SPEAKER,
    top_clearance_under_speaker = PCB_TOP_CLEARANCE_UNDER_SPEAKER,
    bottom_clearance = PCB_BOTTOM_CLEARANCE,

    hole_positions = PCB_HOLE_POSITIONS,
    hole_diameter = PCB_HOLE_DIAMETER,

    tolerance = 0,

    bleed = 0,

    pcb_color = "purple",
    silkscreen_color = [1,1,1,.25]
) {
    e = .0143;
    silkscreen_height = e;

    module _translate(xy, z = PCB_HEIGHT - e) {
        translate([xy.x, xy.y, z]) {
            children();
        }
    }

    if (show_led) {
        _translate(led_position, z = PCB_HEIGHT + PCB_Z_OFF_PCB) {
            # led();
        }
    }

    if (show_switches) {
        for (xy = switch_centers) {
            translate([xy.x, xy.y, height - e]) {
                # spst();
            }
        }

        translate([SWITCH_ORIGIN.x, PCB_SWITCH_Y + SWITCH_ORIGIN.y, height - e]) {
            # switch(position = side_switch_position);
        }
    }

    if (show_board) {
        difference() {
            union() {
                color(pcb_color) {
                    _translate([-bleed, -bleed], 0) {
                        cube([
                            width + bleed * 2,
                            length + bleed * 2,
                            height
                        ]);
                    }
                }

                if (show_silkscreen) {
                    color(silkscreen_color) intersection() {
                        // NOTE: eyeballed
                        translate([-.05, -.05, height - e]) {
                            linear_extrude(silkscreen_height + e) {
                                import("../kicad/higher_lower-brd.svg");
                            }
                        }

                        translate([e, e, e]) {
                            cube([
                                width - e * 2,
                                length - e * 2,
                                height + silkscreen_height + e,
                            ]);
                        }
                    }
                }
            }

            color(pcb_color) {
                for (xy = hole_positions) {
                    translate([xy.x, xy.y, -e]) {
                        cylinder(
                            d = hole_diameter + bleed * 2,
                            h = height + silkscreen_height + e * 2,
                            $fn = 12
                        );
                    }
                }
            }
        }
    }

    if (show_clearance) {
        _translate(speaker_position) {
            % ghost_cylinder(
                get_speaker_fixture_diameter(tolerance),
                top_clearance_under_speaker
            );
        }

        translate([e, e, height - e]) {
            % ghost_cube([
                width - e * 2,
                length - e * 2,
                top_clearance_beyond_speaker + e
            ]);
        }

        translate([e, e, -bottom_clearance]) {
            % ghost_cube([width - e * 2, length - e * 2, bottom_clearance + e]);
        }
    }
}
