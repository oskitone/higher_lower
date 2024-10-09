include <../../parts_cafe/openscad/diagonal_grill.scad>;
include <../../parts_cafe/openscad/enclosure_engraving.scad>;
include <../../parts_cafe/openscad/enclosure_screw_cavities.scad>;
include <../../parts_cafe/openscad/enclosure.scad>;
include <../../parts_cafe/openscad/flat_top_rectangular_pyramid.scad>;
include <../../parts_cafe/openscad/pcb_mount_post.scad>;
include <../../parts_cafe/openscad/pcb_mounting_columns.scad>;

include <pcb.scad>;

SWITCH_CLUTCH_GRIP_LENGTH = 10;
SWITCH_CLUTCH_GRIP_HEIGHT = 7;

DEFAULT_ROUNDING = 24;
HIDEF_ROUNDING = 120;

module enclosure(
    show_top = true,
    show_bottom = true,

    dimensions = [0,0,0],
    bottom_height = 0,
    top_height = 0,

    control_clearance = 0,

    pcb_position = [0,0,0],
    led_position_on_pcb = PCB_LED_POSITION,

    speaker_position = [0,0,0],
    speaker_grill_dimensions = [0,0,0],
    speaker_grill_position = [0,0,0],

    button_dimensions = [0,0],
    button_rocker_position = [0,0,0],
    button_gutter = 0,

    battery_holder_dimensions = [0,0,0],
    battery_holder_position = [0,0,0],

    label_gutter = 0,

    top_engraving_dimensions = [0,0],
    top_engraving_position = [0,0],
    top_engraving_model_text_size = 4.25,
    top_engraving_model_length = ENCLOSURE_ENGRAVING_LENGTH,

    lip_height = ENCLOSURE_LIP_HEIGHT,

    fillet = ENCLOSURE_FILLET,

    pcb_width = 0,
    pcb_length = 0,
    pcb_height = PCB_HEIGHT,

    pcb_screw_hole_positions = [],
    pcb_post_hole_positions = [],

    screw_clearance = 0,
    screw_head_clearance = 0,

    switch_clutch_web_length_extension = 0,

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

    switch_clutch_aligner_length =
        SWITCH_CLUTCH_GRIP_LENGTH + SWITCH_ACTUATOR_TRAVEL
        + switch_clutch_web_length_extension * 2;
    switch_clutch_aligner_y = pcb_position.y + PCB_SWITCH_Y
            + SWITCH_BASE_LENGTH / 2
            - switch_clutch_aligner_length / 2;

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
        depth = ENCLOSURE_ENGRAVING_DEPTH
    ) {
        translate([
            speaker_grill_position.x,
            speaker_grill_position.y,
            dimensions.z - depth
        ]) {
            render() diagonal_grill(
                speaker_grill_dimensions.x,
                speaker_grill_dimensions.y,
                depth + e
            );
        }
    }

    module _speaker_cavity(rim = 2) {
        z = dimensions.z - ENCLOSURE_FLOOR_CEILING;

        render() intersection() {
            translate([speaker_position.x, speaker_position.y, z - e]) {
                _c(
                    speaker_cavity_diameter - rim * 2,
                    ENCLOSURE_FLOOR_CEILING + e * 2,
                    chamfer = 0
                );
            }

            _speaker_grill(ENCLOSURE_FLOOR_CEILING + e * 2);
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
        enclosure_half(
            width = dimensions.x,
            length = dimensions.y,
            height = height,
            add_lip = lip,
            remove_lip = !lip,
            lip_height = lip_height,
            fillet = quick_preview ? 0 : fillet,
            tolerance = tolerance * 1.5, // intentionally kinda loose
            include_tongue_and_groove = true,
            include_disassembly_cavities = true,
            outer_color = outer_color,
            cavity_color = cavity_color,
            $fn = quick_preview ? undef : DEFAULT_ROUNDING
        );
    }

    module _bottom_pcb_fixtures() {
        // TODO: button supports
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
                        height = height + e,
                        ceiling = screw_clearance - tolerance + e,
                        tolerance = tolerance,
                        include_sacrificial_bridge = show_dfm,
                        quick_preview = quick_preview
                    );
                }
            }

            translate([
                speaker_position.x,
                speaker_position.y,
                z - e
            ]) {
                cylinder(
                    d = speaker_cavity_diameter,
                    h = dimensions.z - z
                );
            }
        }
    }

    module _speaker_fixture() {
        switch_clutch_deobstruction_width = 3; // NOTE: arbitrary

        difference() {
            translate(speaker_position) {
                speaker_fixture(
                    height = SPEAKER_HEIGHT + e,
                    wall = ENCLOSURE_INNER_WALL,
                    tab_cavity_rotation = 180,
                    tolerance = tolerance,
                    quick_preview = quick_preview
                );
            }

            translate([
                pcb_position.x - switch_clutch_deobstruction_width,
                switch_clutch_aligner_y - e,
                speaker_position.z - e
            ]) {
                cube([
                    switch_clutch_deobstruction_width,
                    switch_clutch_aligner_length + e * 2,
                    SPEAKER_HEIGHT + e * 3
                ]);
            }
        }
    }

    module _top_engraving() {
        brand_length = top_engraving_dimensions.x * OSKITONE_LENGTH_WIDTH_RATIO;
        placard_length = top_engraving_dimensions.y
            - brand_length - label_gutter;

        render() enclosure_engraving(
            size = brand_length,
            position = [
                top_engraving_position.x,
                top_engraving_position.y
                    + label_gutter
                    + placard_length
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
                top_engraving_position.y + placard_length / 2
            ],
            placard = [
                top_engraving_dimensions.x,
                placard_length
            ],
            bottom = false,
            center = true,
            quick_preview = quick_preview,
            enclosure_height = dimensions.z
        );
    }

    module _button_rocker_cavity() {
        // TODO: tolerance?
        translate([
            button_rocker_position.x - control_clearance,
            button_rocker_position.y - control_clearance,
            dimensions.z - ENCLOSURE_FLOOR_CEILING - e
        ]) {
            cube([
                button_dimensions.x + control_clearance * 2,
                button_dimensions.y * 2 + button_gutter + control_clearance * 2,
                ENCLOSURE_FLOOR_CEILING + e * 2
            ]);
        }
    }

    module _switch_clutch_aligner(
        width = 10, // NOTE: eyeballed to fill towards speaker fixture
        height = SPEAKER_HEIGHT
    ) {
        x = pcb_position.x;
        z = dimensions.z - ENCLOSURE_FLOOR_CEILING - height;

        difference() {
            translate([x, switch_clutch_aligner_y, z]) {
                cube([width, switch_clutch_aligner_length, height + e]);
            }

            translate([speaker_position.x, speaker_position.y, z - e]) {
                _c(
                    speaker_cavity_diameter + ENCLOSURE_INNER_WALL,
                    height + e * 3,
                    chamfer = 0
                );
            }
        }
    }

    module _switch_clutch_exposure(
        length_clearance = .2
    ) {
        length = SWITCH_CLUTCH_GRIP_LENGTH + SWITCH_ACTUATOR_TRAVEL
            + tolerance * 4 + length_clearance * 2;
        height = SWITCH_CLUTCH_GRIP_HEIGHT + tolerance * 4;

        translate([
            -e,
            pcb_position.y + PCB_SWITCH_Y + SWITCH_BASE_LENGTH / 2 - length / 2,
            (dimensions.z - height) / 2
        ]) {
            cube([
                ENCLOSURE_WALL + e * 2, length, height
            ]);
        }
    }

    module _lightpipe_exposure(
        diameter = 1/4 * 25.4 + tolerance * 2,
        fixture = false,
        $fn = 24
    ) {
        fixture_y = pcb_position.y + pcb_length + tolerance;

        x = pcb_position.x + led_position_on_pcb.x;
        y = fixture
                ? fixture_y
                : dimensions.y - ENCLOSURE_WALL - e;
        z = pcb_position.z + pcb_height + diameter / 2;

        if (fixture) {
            length = dimensions.y - ENCLOSURE_WALL - fixture_y + e;

            difference() {
                hull() {
                    translate([
                        x - diameter / 2 - ENCLOSURE_INNER_WALL,
                        y,
                        ENCLOSURE_FLOOR_CEILING - e
                    ]) {
                        cube([
                            diameter + ENCLOSURE_INNER_WALL * 2,
                            length,
                            e
                        ]);
                    }

                    translate([x, y, z]) {
                        rotate([-90, 0, 0]) cylinder(
                            d = diameter + ENCLOSURE_INNER_WALL * 2,
                            h = length
                        );
                    }
                }

                translate([x, y - e, z]) {
                    rotate([-90, 0, 0]) cylinder(
                        d = diameter,
                        h = length + e * 2
                    );
                }
            }
        } else {
            translate([x, y, z]) {
                rotate([-90, 0, 0]) cylinder(
                    d = diameter,
                    h = ENCLOSURE_WALL + e * 2
                );
            }
        }
    }

    module _battery_holder_fixture(
        depth = ENCLOSURE_INNER_WALL,
        coverage = 5,
        height = 2
    ) {
        translate([
            battery_holder_position.x
                + (battery_holder_dimensions.x - coverage) / 2,
            battery_holder_position.y + battery_holder_dimensions.y
                + tolerance * 2,
            ENCLOSURE_FLOOR_CEILING - e
        ]) {
            cube([
                coverage,
                depth,
                height + e
            ]);
        }

        for (x = [
            battery_holder_position.x - (depth + tolerance * 2),
            battery_holder_position.x
                + battery_holder_dimensions.x + tolerance * 2
        ]) {
            translate([x, ENCLOSURE_WALL - e, ENCLOSURE_FLOOR_CEILING - e]) {
                flat_top_rectangular_pyramid(
                    top_width = depth,
                    top_length = 0,
                    bottom_width = depth,
                    bottom_length = coverage + e,
                    height = height + e,
                    top_weight_y = 0
                );
            }
        }
    }

    if (show_bottom) {
        difference() {
            union() {
                _half(bottom_height, lip = true);

                color(outer_color) {
                    _bottom_pcb_fixtures();
                    _lightpipe_exposure(fixture = true);
                    _battery_holder_fixture();
                }
            }

            color(cavity_color) {
                _bottom_engraving();
                enclosure_screw_cavities(
                    screw_head_clearance = screw_head_clearance,
                    pcb_position = pcb_position,
                    pcb_screw_hole_positions = pcb_screw_hole_positions,
                    tolerance = tolerance,
                    pcb_hole_diameter = PCB_HOLE_DIAMETER,
                    show_dfm = show_dfm,
                    quick_preview = quick_preview
                );
                _switch_clutch_exposure();
                _lightpipe_exposure();
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
                    _speaker_fixture();
                    _switch_clutch_aligner();
                }
            }

            color(cavity_color) {
                _speaker_cavity();
                _speaker_grill();
                _button_rocker_cavity();
                _top_engraving();
                _switch_clutch_exposure();
                _lightpipe_exposure();
            }
        }
    }
}
