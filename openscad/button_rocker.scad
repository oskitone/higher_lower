include <../../parts_cafe/openscad/cap_blank.scad>;
include <../../parts_cafe/openscad/engraving.scad>;
include <../../parts_cafe/openscad/flat_top_rectangular_pyramid.scad>;

// NOTE: must be well less than SCOUT_DEFAULT_GUTTER
ROCKER_BRIM_SIZE = 2;
ROCKER_BRIM_HEIGHT = 1;

function get_rocker_switch_center(
    xy = [0,0],
    offset = [0,0]
) = ([
    xy.x - offset.x,
    xy.y - offset.y,
]);

module button_rocker(
    width, length, height,

    switch_centers = [],
    actuator_cavity_height =
        SPST_ACTUATOR_HEIGHT_OFF_PCB - SPST_BASE_DIMENSIONS.z
        - SPST_CONSERVATIVE_TRAVEL,

    plunge = 0,

    gutter = 0,

    brim_size = ROCKER_BRIM_SIZE,
    brim_height = ROCKER_BRIM_HEIGHT,

    fillet = 0,
    chamfer = ENCLOSURE_ENGRAVING_CHAMFER,

    tolerance = 0,

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

    plunge = plunge + actuator_cavity_height;

    module _engraving(y, rotation, size = min(width, length) * .5) {
        translate([width / 2, y, height - ENCLOSURE_ENGRAVING_DEPTH]) {
            rotate([0, 0, rotation]) engraving(
                svg = "../misc/arrow.svg",
                resize = [size, size],
                bleed = quick_preview ? 0 : ENCLOSURE_ENGRAVING_BLEED,
                height = ENCLOSURE_ENGRAVING_DEPTH + e,
                center = true,
                chamfer =  quick_preview ? 0 : chamfer
            );
        }
    }

    module _actuator_cavities($fn = quick_preview ? 6 : 24) {
        inner_diameter = SPST_ACTUATOR_DIAMETER + tolerance * 2;

        for (xy = switch_centers) {
            translate([xy.x, xy.y, -(plunge + e)]) {
                cylinder(
                    d = inner_diameter,
                    h = actuator_cavity_height + e
                );

                cylinder(
                    d1 = inner_diameter + chamfer * 2,
                    d2 = inner_diameter,
                    h = chamfer + e
                );
            }
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
            _actuator_cavities();
        }
    }
}