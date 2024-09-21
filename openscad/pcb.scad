// TODO: derive from enclosure
PCB_WIDTH = 70;
PCB_LENGTH = 40;
PCB_HEIGHT = 1.6;

PCB_HOLE_POSITIONS = [
];
PCB_HOLE_DIAMETER = 3.2;

module pcb(
    show_board = true,
    show_silkscreen = true,

    dimensions = [PCB_WIDTH, PCB_LENGTH, PCB_HEIGHT],

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

    if (show_board) {
        difference() {
            union() {
                color(pcb_color) {
                    cube(dimensions);
                }

                if (show_silkscreen) {
                    intersection() {
                        // NOTE: eyeballed
                        // translate([-3.44, -2.54 * 3, dimensions.z - e]) {
                        //     linear_extrude(silkscreen_height + e) {
                        //         import("../kicad/wub-brd.svg");
                        //     }
                        // }

                        translate([e, e, e]) {
                            cube([
                                dimensions.x - e * 2,
                                dimensions.y - e * 2,
                                dimensions.z + silkscreen_height + e,
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
                            h = dimensions.z + silkscreen_height + e * 2,
                            $fn = 12
                        );
                    }
                }
            }
        }
    }
}
