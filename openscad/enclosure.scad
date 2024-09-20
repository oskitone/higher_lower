include <../../parts_cafe/openscad/diagonal_grill.scad>;
include <../../parts_cafe/openscad/enclosure_engraving.scad>;
include <../../parts_cafe/openscad/enclosure_screw_cavities.scad>;
include <../../parts_cafe/openscad/enclosure.scad>;
include <../../parts_cafe/openscad/nuts_and_bolts.scad>;
include <../../parts_cafe/openscad/pcb_mount_post.scad>;
include <../../parts_cafe/openscad/pcb_mounting_columns.scad>;

include <pcb.scad>;

ENCLOSURE_WALL = 2.4;
ENCLOSURE_FLOOR_CEILING = 1.8;
ENCLOSURE_INNER_WALL = 1.2;
ENCLOSURE_LIP_HEIGHT = 3;
ENCLOSURE_ENGRAVING_DEPTH = 1.2;
ENCLOSURE_FILLET = 2;

DEFAULT_ROUNDING = 24;
HIDEF_ROUNDING = 120;

module enclosure(
    show_top = true,
    show_bottom = true,

    dimensions = [0,0,0],
    bottom_height = 0,
    top_height = 0,

    pcb_position = [0,0,0],

    speaker_position = [0,0,0],

    speaker_grill_dimensions = [0,0,0],
    speaker_grill_position = [0,0,0],

    battery_position = [0,0,0],

    label_gutter = 0,

    top_engraving_dimensions = [0,0],
    top_engraving_position = [0,0],
    top_engraving_model_text_size = ENCLOSURE_ENGRAVING_TEXT_SIZE,
    top_engraving_model_length = ENCLOSURE_ENGRAVING_LENGTH,

    lip_height = ENCLOSURE_LIP_HEIGHT,

    fillet = ENCLOSURE_FILLET,

    pcb_width = PCB_WIDTH,
    pcb_length = PCB_LENGTH,
    pcb_height = PCB_HEIGHT,

    pcb_screw_hole_positions = [],
    pcb_post_hole_positions = [],

    screw_clearance = 0,
    screw_head_clearance = 0,

    tolerance = 0,

    outer_color = undef,
    cavity_color = undef,

    chamfer = .4,
    show_dfm = true,

    quick_preview = true
) {
    e = .03183;

    cavity_z = dimensions.z - ENCLOSURE_FLOOR_CEILING - e;
    cavity_height = ENCLOSURE_FLOOR_CEILING + e * 2;

    speaker_cavity_diameter = SPEAKER_DIAMETER + tolerance * 2;

    module _c(
        diameter,
        height,
        chamfer = chamfer,
        $fn = quick_preview ? undef : HIDEF_ROUNDING
    ) {
        cylinder(
            d = diameter,
            h = height
        );

        if (show_dfm && chamfer > 0) {
            translate([0, 0, height - chamfer]) {
                cylinder(
                    d1 = diameter,
                    d2 = diameter + chamfer * 2,
                    h = chamfer
                );
            }
        }
    }

    module _speaker_grill(
        z = pcb_position.z + pcb_height + SPEAKER_HEIGHT +
            (ENCLOSURE_FLOOR_CEILING - ENCLOSURE_ENGRAVING_DEPTH)
    ) {
        height = dimensions.z - z + e;

        translate([speaker_grill_position.x, speaker_grill_position.y, z]) {
            render() diagonal_grill(
                speaker_grill_dimensions.x,
                speaker_grill_dimensions.y,
                height
            );
        }
    }

    module _speaker_plate(coverage = ENCLOSURE_INNER_WALL) {
        z = pcb_position.z + pcb_height + SPEAKER_HEIGHT;
        height = dimensions.z - ENCLOSURE_FLOOR_CEILING - z;

        translate([
            speaker_grill_position.x - coverage,
            speaker_grill_position.y - coverage,
            z
        ]) {
            cube([
                speaker_grill_dimensions.x + coverage * 2,
                speaker_grill_dimensions.y + coverage * 2,
                height + e
            ]);
        }

        translate([speaker_position.x, speaker_position.y, z]) {
            _c(speaker_cavity_diameter, height + e, chamfer = 0);
        }
    }

    module _speaker_cavity() {
        z = pcb_position.z + pcb_height + SPEAKER_HEIGHT - e;
        height = dimensions.z - z + e;

        render() intersection() {
            translate([speaker_position.x, speaker_position.y, z]) {
                _c(
                    speaker_cavity_diameter - SPEAKER_RIM * 2,
                    height,
                    chamfer = 0
                );
            }

            _speaker_grill(z - e);
        }
    }

    module _bottom_engraving(
        brand_length = 8,
        make_y = dimensions.y * .25
    ) {
        render() enclosure_engraving(
            size = brand_length,
            center = true,
            position = [dimensions.x / 2, make_y],
            bottom = true,
            quick_preview = quick_preview,
            enclosure_height = dimensions.z
        );
    }

    module _half(height, lip) {
        color(outer_color) {
            enclosure_half(
                width = dimensions.x,
                length = dimensions.y,
                height = height,
                wall = ENCLOSURE_WALL,
                floor_ceiling = ENCLOSURE_FLOOR_CEILING,
                add_lip = lip,
                remove_lip = !lip,
                lip_height = lip_height,
                fillet = quick_preview ? 0 : fillet,
                include_tongue_and_groove = true,
                tongue_and_groove_snap = [0, .8, .5, .8],
                tongue_and_groove_pull = tolerance,
                tolerance = tolerance * 1.5, // intentionally kinda loose
                outer_color = outer_color,
                cavity_color = cavity_color,
                $fn = quick_preview ? undef : DEFAULT_ROUNDING
            );
        }
    }

    module _bottom_pcb_fixtures() {
        pcb_mounting_columns(
            pcb_position = pcb_position,
            screw_head_clearance = screw_head_clearance,
            wall = ENCLOSURE_INNER_WALL,
            pcb_screw_hole_positions = pcb_screw_hole_positions,
            pcb_post_hole_positions = pcb_post_hole_positions,
            tolerance = tolerance,
            enclosure_floor_ceiling = ENCLOSURE_FLOOR_CEILING,
            screw_head_diameter = SCREW_HEAD_DIAMETER,
            pcb_hole_diameter = PCB_HOLE_DIAMETER,
            support_web_length = (pcb_position.z - ENCLOSURE_FLOOR_CEILING) / 2,
            quick_preview = quick_preview
        );
    }

    module _top_pcb_fixtures() {
        z = pcb_position.z + pcb_height;
        height = dimensions.z - z - ENCLOSURE_FLOOR_CEILING;

        difference() {
            for (position = pcb_screw_hole_positions) {
                translate([
                    position.x + pcb_position.x,
                    position.y + pcb_position.y,
                    z
                ]) {
                    pcb_mount_post(
                        width = NUT_DIAMETER + 4,
                        height = height,
                        ceiling = screw_clearance - tolerance,
                        stalactite = true,
                        tolerance = tolerance,
                        quick_preview = quick_preview
                    );
                }
            }
        }
    }

    // TODO: redesign
    module _top_engraving() {
        render() enclosure_engraving(
            size = top_engraving_dimensions.x
                * OSKITONE_LENGTH_WIDTH_RATIO,
            position = [
                top_engraving_position.x,
                top_engraving_position.y
                    + label_gutter
                    + top_engraving_model_length
            ],
            bottom = false,
            center = false,
            quick_preview = quick_preview,
            enclosure_height = dimensions.z
        );

        render() enclosure_engraving(
            string = "HIGHER LOWER",
            size = top_engraving_model_text_size,
            position = [
                top_engraving_position.x + top_engraving_dimensions.x / 2,
                top_engraving_position.y + top_engraving_model_length / 2
            ],
            placard = [
                top_engraving_dimensions.x,
                top_engraving_model_length
            ],
            bottom = false,
            center = true,
            quick_preview = quick_preview,
            enclosure_height = dimensions.z
        );
    }

    module _disassembly_cavities(
        bottom,

        wedge_width = 10,
        wedge_height = FLATHEAD_SCREWDRIVER_POINT,

        dimple_diameter = 10,
        dimple_depth = ENCLOSURE_ENGRAVING_DEPTH
    ) {
        if (bottom) {
            difference() {
                for (x = [-e, dimensions.x - dimple_depth]) {
                    translate([x, dimensions.y / 2, bottom_height]) {
                        rotate([0, 90, 0]) {
                            cylinder(
                                d = dimple_diameter,
                                h = dimple_depth + e,
                                $fn = quick_preview ? undef : DEFAULT_ROUNDING
                            );
                        }
                    }
                }

                translate([
                    -e,
                    (dimensions.y - dimple_diameter) / 2,
                    bottom_height + e
                ]) {
                    cube([
                        dimensions.x,
                        dimple_diameter + e * 2,
                        lip_height + e
                    ]);
                }
            }
        } else {
            x = (dimensions.x - wedge_width) / 2;

            translate([x, -e, bottom_height - e]) {
                cube([wedge_width, ENCLOSURE_WALL + e * 2, wedge_height + e]);
            }
        }
    }

    if (show_bottom) {
        difference() {
            color(outer_color) {
                _half(bottom_height, lip = true);
                _bottom_pcb_fixtures();
            }

            color(cavity_color) {
                _bottom_engraving();
                _disassembly_cavities(bottom = true);

                enclosure_screw_cavities(
                    screw_head_clearance = screw_head_clearance,
                    pcb_position = pcb_position,
                    pcb_screw_hole_positions = pcb_screw_hole_positions,
                    tolerance = tolerance,
                    pcb_hole_diameter = PCB_HOLE_DIAMETER,
                    show_dfm = show_dfm,
                    quick_preview = quick_preview
                );
            }
        }
    }

    if (show_top) {
        difference() {
            union() {
                translate([0, 0, dimensions.z]) {
                    mirror([0, 0, 1]) {
                        _half(top_height, lip = false);
                    }
                }

                color(outer_color) {
                    _top_pcb_fixtures();
                }
            }

            color(cavity_color) {
                _speaker_cavity();
                _speaker_grill();
                _top_engraving();
                _disassembly_cavities(bottom = false);
            }
        }
    }
}
