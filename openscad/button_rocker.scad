include <../../parts_cafe/openscad/cap_blank.scad>;

// NOTE: must be well less than SCOUT_DEFAULT_GUTTER
ROCKER_BRIM_SIZE = 2;
ROCKER_BRIM_HEIGHT = 1;

module button_rocker(
    width, length, height,

    gutter = 0,

    brim_height = ROCKER_BRIM_HEIGHT,

    fillet = 0,

    outer_color = undef,
    cavity_color = undef
) {
    e = .0481;

    brim_dimensions = [
        width + ROCKER_BRIM_SIZE * 2,
        length * 2 + gutter + ROCKER_BRIM_SIZE * 2,
        brim_height
    ];

    color(outer_color) {
        render() for (y = [0, length + gutter]) {
            translate([0, y, -e]) {
                cap_blank(
                    dimensions = [width, length, height + e],
                    contact_dimensions = [
                        width - SCOUT_DEFAULT_GUTTER,
                        length - SCOUT_DEFAULT_GUTTER,
                        2
                    ],

                    fillet = fillet
                );
            }
        }

        translate([-ROCKER_BRIM_SIZE, -ROCKER_BRIM_SIZE, 0]) {
            cube(brim_dimensions);
        }
    }
}