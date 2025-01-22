include <../../parts_cafe/openscad/cap_blank.scad>;
include <../../parts_cafe/openscad/engraving.scad>;
include <../../parts_cafe/openscad/flat_top_rectangular_pyramid.scad>;

// NOTES: must be well less than SCOUT_DEFAULT_GUTTER,
// chamfer is eyeballed against ENCLOSURE_INNER_CHAMFER
ROCKER_BRIM_SIZE = 2;
ROCKER_BRIM_HEIGHT = 1.2;
ROCKER_BRIM_CHAMFER = .6;

ROCKER_ENCLOSURE_FIXTURE_DEPTH = .4;

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

    xy_clearance = 0,
    z_clearance = 0,

    brim_size = ROCKER_BRIM_SIZE,
    brim_height = ROCKER_BRIM_HEIGHT,
    brim_chamfer = ROCKER_BRIM_CHAMFER,

    fixture_retraction = 0,
    fixture_cavity_height = 2,

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
        length * 2 + xy_clearance + brim_size * 2,
        brim_height
    ];

    actuator_cavitiy_inner_diameter = SPST_ACTUATOR_DIAMETER
        + tolerance * 4; // doubled to be intentionally loose
    actuator_cavitiy_outer_diameter = actuator_cavitiy_inner_diameter + chamfer * 2;

    minimum_walled_actuator_cavities_width =
        actuator_cavitiy_outer_diameter + ENCLOSURE_INNER_WALL * 2;

    plunge = plunge + actuator_cavity_height;
    offset = min(
        (brim_dimensions.x - minimum_walled_actuator_cavities_width) / 2,
        plunge // ie, a 45 degree chamfer
    );

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
        for (xy = switch_centers) {
            translate([xy.x, xy.y, -(plunge + e)]) {
                cylinder(
                    d = actuator_cavitiy_inner_diameter,
                    h = actuator_cavity_height + e
                );

                cylinder(
                    d1 = actuator_cavitiy_outer_diameter,
                    d2 = actuator_cavitiy_inner_diameter,
                    h = chamfer + e
                );
            }
        }
    }

    module _enclosure_fixture_cavity() {
        radius = ROCKER_ENCLOSURE_FIXTURE_DEPTH + fixture_retraction + tolerance;

        for (x = [-fixture_retraction, width + fixture_retraction]) {
            translate([x, length + xy_clearance / 2, brim_dimensions.z]) {
                cylinder(
                    r = radius,
                    h = fixture_cavity_height,
                    $fn = 8
                );
            }
        }
    }

    difference() {
        color(outer_color) {
            for (y = [0, length + xy_clearance]) {
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
                cube([
                    brim_dimensions.x,
                    brim_dimensions.y,
                    brim_dimensions.z - brim_chamfer + e
                ]);

                translate([0, 0, brim_dimensions.z - brim_chamfer]) {
                    flat_top_rectangular_pyramid(
                        top_width = brim_dimensions.x - brim_chamfer * 2,
                        top_length = brim_dimensions.y - brim_chamfer * 2,
                        bottom_width = brim_dimensions.x,
                        bottom_length = brim_dimensions.y,
                        height = brim_chamfer
                    );
                }
            }

            translate([-brim_size + offset, -brim_size + offset, -plunge]) {
                flat_top_rectangular_pyramid(
                    top_width = brim_dimensions.x,
                    top_length = brim_dimensions.y,
                    bottom_width = brim_dimensions.x - offset * 2,
                    bottom_length = brim_dimensions.y - offset * 2,
                    height = plunge + e
                );
            }
        }

        color(cavity_color) {
            _engraving(length + xy_clearance + length / 2, 0);
            _engraving(length / 2, 180);
            _actuator_cavities();
            _enclosure_fixture_cavity();
        }
    }
}