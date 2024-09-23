PCB_HEIGHT = 1.6;

PCB_MINIMUM_LENGTH = 25.4; // NOTE: arbitrary but reasonable!

PCB_HOLE_POSITIONS = [
];
PCB_HOLE_DIAMETER = 3.2;

BUTTON_DIAMETER = 6;
BUTTON_HEIGHT = 6;

module pcb(
    show_board = true,
    show_silkscreen = true,
    show_switches = true,

    width = 0,
    length = 0,
    height = PCB_HEIGHT,

    rocker_center_x = 0,
    rocker_center_y = 0,
    button_size = 0,

    hole_positions = PCB_HOLE_POSITIONS,
    hole_diameter = PCB_HOLE_DIAMETER,

    pcb_color = "purple"
) {
    e = .0143;
    silkscreen_height = e;

    module _translate(position, z = -e) {
        translate([position.x, position.y, z + position.z]) {
            children();
        }
    }

    switch_centers = [
        [rocker_center_x, rocker_center_y - button_size / 2],
        [rocker_center_x, rocker_center_y + button_size / 2],
    ];

    echo("PCB switch_centers", switch_centers);

    if (show_switches) {
        for (xy = switch_centers) {
            translate([xy.x, xy.y, height - e]) {
                % cylinder(d = BUTTON_DIAMETER, h = BUTTON_HEIGHT + e);
            }
        }
    }

    if (show_board) {
        difference() {
            union() {
                color(pcb_color) {
                    cube([width, length, height]);
                }

                if (show_silkscreen) {
                    intersection() {
                        // NOTE: eyeballed
                        // translate([-3.44, -2.54 * 3, height - e]) {
                        //     linear_extrude(silkscreen_height + e) {
                        //         import("../kicad/wub-brd.svg");
                        //     }
                        // }

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
}
