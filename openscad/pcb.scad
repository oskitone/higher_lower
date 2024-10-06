include <../../parts_cafe/openscad/led.scad>;
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
  get_translated_xy([140.97, 110.49]),
  get_translated_xy([114.935, 110.49]),
  get_translated_xy([107.315, 110.49]),
  get_translated_xy([105.41, 80.01]),
];
PCB_HOLE_DIAMETER = 3.2;

BUTTON_DIAMETER = 6;
BUTTON_HEIGHT = 6;

// NOTE: caps lie flat, leads must be trimmed
PCB_TOP_CLEARANCE = 10;
PCB_BOTTOM_CLEARANCE = 2;

PCB_SWITCH_Y = 16.54;

PCB_LED_POSITION = get_translated_xy([120.145 + 2.5, 80.52 + .6]);

module pcb(
    show_board = true,
    show_silkscreen = true,
    show_switches = true,
    show_led = true,
    show_clearance = false,

    width = 0,
    length = 0,
    height = PCB_HEIGHT,

    rocker_center_x = 0,
    rocker_center_y = 0,
    button_dimensions = [0,0],
    button_gutter = 0,

    side_switch_position = 0,

    top_clearance = PCB_TOP_CLEARANCE,
    bottom_clearance = PCB_BOTTOM_CLEARANCE,

    hole_positions = PCB_HOLE_POSITIONS,
    hole_diameter = PCB_HOLE_DIAMETER,

    pcb_color = "purple",
    silkscreen_color = [1,1,1,.25]
) {
    e = .0143;
    silkscreen_height = e;

    module _translate(position) {
        translate([position.x, position.y, PCB_HEIGHT - e]) {
            children();
        }
    }

    switch_centers = [
        [rocker_center_x, rocker_center_y - (button_dimensions.x + button_gutter) / 2 ],
        [rocker_center_x, rocker_center_y + (button_dimensions.y + button_gutter) / 2 ],
    ];

    echo("PCB switch_centers", [
        [4 + switch_centers[0].x / 25.4, 4.5 - switch_centers[0].y / 25.4,],
        [4 + switch_centers[1].x / 25.4, 4.5 - switch_centers[1].y / 25.4,]
    ]);

    if (show_led) {
        _translate(PCB_LED_POSITION) {
            % led();
        }
    }

    if (show_switches) {
        for (xy = switch_centers) {
            translate([xy.x, xy.y, height - e]) {
                % cylinder(d = BUTTON_DIAMETER, h = BUTTON_HEIGHT + e);
            }
        }

        translate([SWITCH_ORIGIN.x, PCB_SWITCH_Y + SWITCH_ORIGIN.y, height - e]) {
            % switch(position = side_switch_position);
        }
    }

    if (show_board) {
        difference() {
            union() {
                color(pcb_color) {
                    cube([width, length, height]);
                }

                if (show_silkscreen) {
                    color(silkscreen_color) intersection() {
                        // NOTE: eyeballed
                        translate([-9.08, -20.7, height - e]) {
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
                            d = hole_diameter,
                            h = height + silkscreen_height + e * 2,
                            $fn = 12
                        );
                    }
                }
            }
        }
    }

    if (show_clearance) {
        translate([e, e, height - e]) {
            % cube([width - e * 2, length - e * 2, top_clearance + e]);
        }

        translate([e, e, -bottom_clearance]) {
            % cube([width - e * 2, length - e * 2, bottom_clearance + e]);
        }
    }
}
