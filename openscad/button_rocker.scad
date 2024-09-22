include <../../parts_cafe/openscad/cap_blank.scad>;

// NOTE: must be well less than SCOUT_DEFAULT_GUTTER
ROCKER_BRIM_SIZE = 2;
ROCKER_BRIM_HEIGHT = 1;

module button_rocker(
    width, length, height,

    gutter = 0,

    brim_height = ROCKER_BRIM_HEIGHT,

    fillet = 0
) {
    for (y = [0, length + gutter]) {
        translate([0, y, 0]) {
            cap_blank(
                dimensions = [width, width, height],
                contact_dimensions = [
                    width - SCOUT_DEFAULT_GUTTER,
                    width - SCOUT_DEFAULT_GUTTER,
                    2
                ],

                fillet = fillet,

                brim_dimensions = [
                    width + ROCKER_BRIM_SIZE * 2,
                    width + ROCKER_BRIM_SIZE * 2,
                    brim_height
                ]
            );
        }
    }
}