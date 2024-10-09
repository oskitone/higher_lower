include <../../parts_cafe/openscad/cap_blank.scad>;
include <../../parts_cafe/openscad/engraving.scad>;
include <../../parts_cafe/openscad/flat_top_rectangular_pyramid.scad>;

// NOTE: must be well less than SCOUT_DEFAULT_GUTTER
ROCKER_BRIM_SIZE = 2;
ROCKER_BRIM_HEIGHT = 1;

module button_rocker(
    width, length, height,

    plunge = 0,

    gutter = 0,

    brim_size = ROCKER_BRIM_SIZE,
    brim_height = ROCKER_BRIM_HEIGHT,

    fillet = 0,

    outer_color = undef,
    cavity_color = undef,

    quick_preview = false
) {
    e = .0481;

    brim_dimensions = [
        width + brim_size * 2,
        length * 2 + gutter + brim_size * 2,
        brim_height
    ];

    module _engraving(y, rotation, size = min(width, length) * .5) {
        translate([width / 2, y, height - ENCLOSURE_ENGRAVING_DEPTH]) {
            rotate([0, 0, rotation]) engraving(
                svg = "../misc/arrow.svg",
                resize = [size, size],
                bleed = quick_preview ? 0 : ENCLOSURE_ENGRAVING_BLEED,
                height = ENCLOSURE_ENGRAVING_DEPTH + e,
                center = true,
                chamfer =  quick_preview ? 0 : ENCLOSURE_ENGRAVING_CHAMFER
            );
        }
    }

    difference() {
        color(outer_color) {
            for (y = [0, length + gutter]) {
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

        color(cavity_color) {
            _engraving(length + gutter + length / 2, 0);
            _engraving(length / 2, 180);
        }
    }
}