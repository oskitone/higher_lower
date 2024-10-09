include <../../parts_cafe/openscad/cap_blank.scad>;
include <../../parts_cafe/openscad/flat_top_rectangular_pyramid.scad>;

// NOTE: must be well less than SCOUT_DEFAULT_GUTTER
ROCKER_BRIM_SIZE = 2;
ROCKER_BRIM_HEIGHT = 1;

// TODO: engrave

module button_rocker(
    width, length, height,

    plunge = 0,

    gutter = 0,

    brim_size = ROCKER_BRIM_SIZE,
    brim_height = ROCKER_BRIM_HEIGHT,

    fillet = 0,

    outer_color = undef,
    cavity_color = undef
) {
    e = .0481;

    brim_dimensions = [
        width + brim_size * 2,
        length * 2 + gutter + brim_size * 2,
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

        translate([-brim_size, -brim_size, 0]) {
            cube(brim_dimensions);
        }

        translate([-brim_size + plunge, -brim_size + plunge, -plunge]) {
            flat_top_rectangular_pyramid(
                top_width = brim_dimensions.x,
                top_length = brim_dimensions.y,
                bottom_width = brim_dimensions.x - plunge * 2,
                bottom_length = brim_dimensions.y - plunge * 2,
                height = plunge + e
            );
        }
    }
}