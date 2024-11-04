include <../../parts_cafe/openscad/battery_holder_fixtures.scad>;
include <../../parts_cafe/openscad/diagonal_grill.scad>;
include <../../parts_cafe/openscad/enclosure_engraving.scad>;
include <../../parts_cafe/openscad/enclosure.scad>;
include <../../parts_cafe/openscad/flat_top_rectangular_pyramid.scad>;
include <../../parts_cafe/openscad/pcb_mounting_columns.scad>;

include <pcb.scad>;

SWITCH_CLUTCH_GRIP_LENGTH = 10;
SWITCH_CLUTCH_GRIP_HEIGHT = 7;

DEFAULT_ROUNDING = 24;
HIDEF_ROUNDING = 120;

// "1/4" glue stick
LIGHTPIPE_DIAMETER = 7;

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
    rocker_xy_clearance = 0,

    battery_holder_dimensions = [0,0,0],
    battery_holder_position = [0,0,0],

    label_gutter = 0,

    top_engraving_dimensions = [0,0],
    top_engraving_position = [0,0],
    top_engraving_model_text_size = 3.8,
    top_engraving_model_length = ENCLOSURE_ENGRAVING_LENGTH,

    lip_height = ENCLOSURE_LIP_HEIGHT,

    fillet = ENCLOSURE_FILLET,
    inner_chamfer = ENCLOSURE_INNER_CHAMFER,

    pcb_width = 0,
    pcb_length = 0,
    pcb_height = PCB_HEIGHT,

    pcb_post_hole_positions = [],

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

    under_pcb_fixture_height = pcb_position.z - ENCLOSURE_FLOOR_CEILING;

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

    module _speaker_cavity() {
        z = dimensions.z - ENCLOSURE_FLOOR_CEILING;

        render() intersection() {
            translate([speaker_position.x, speaker_position.y, z - e]) {
                _c(
                    speaker_cavity_diameter,
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
            inner_chamfer = quick_preview ? 0 : inner_chamfer,
            tolerance = tolerance * 1.5, // intentionally kinda loose
            include_tongue_and_groove = true,
            tongue_and_groove_snap = [.5, 1, .5, 1],
            tongue_and_groove_pull = .3,
            include_disassembly_wedge = true,
            outer_color = outer_color,
            cavity_color = cavity_color,
            $fn = quick_preview ? undef : DEFAULT_ROUNDING
        );
    }

    module _bottom_pcb_fixtures(
        button_support_length = 26
    ) {
        pcb_mounting_columns(
            pcb_position = pcb_position,
            wall = ENCLOSURE_INNER_WALL,
            pcb_screw_hole_positions = [],
            pcb_post_hole_positions = pcb_post_hole_positions,
            tolerance = tolerance,
            enclosure_floor_ceiling = ENCLOSURE_FLOOR_CEILING,
            pcb_hole_diameter = PCB_HOLE_DIAMETER,
            support_web_length = (pcb_position.z - ENCLOSURE_FLOOR_CEILING) / 2,
            quick_preview = quick_preview
        );

        translate([
            button_rocker_position.x
                + (button_dimensions.x - ENCLOSURE_INNER_WALL) / 2,
            button_rocker_position.y
                + button_dimensions.y + rocker_xy_clearance / 2
                - button_support_length / 2,
            ENCLOSURE_FLOOR_CEILING - e
        ]) {
            cube([
                ENCLOSURE_INNER_WALL,
                button_support_length,
                pcb_position.z - ENCLOSURE_FLOOR_CEILING + e
            ]);
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
            // HACK: kerning
            string = "H\u2009I\u2009G\u2009H\u2009E\u2009R\u2009 \u2009L\u2009O\u2009W\u2009E\u2009R",
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
        gutter = control_clearance + tolerance;

        translate([
            button_rocker_position.x - gutter,
            button_rocker_position.y - gutter,
            dimensions.z - ENCLOSURE_FLOOR_CEILING - e
        ]) {
            cube([
                button_dimensions.x + gutter * 2,
                button_dimensions.y * 2
                    + rocker_xy_clearance + gutter * 2,
                ENCLOSURE_FLOOR_CEILING + e * 2
            ]);
        }
    }

    module _switch_clutch_fixture(
        top = true,
        top_width = 10 // NOTE: eyeballed to fill towards speaker fixture
    ) {
        width = top ? top_width : ENCLOSURE_INNER_WALL;
        height = top ? SPEAKER_HEIGHT : under_pcb_fixture_height;

        x = pcb_position.x;
        z = top
            ? dimensions.z - ENCLOSURE_FLOOR_CEILING - height
            : ENCLOSURE_FLOOR_CEILING - e;

        difference() {
            translate([x, switch_clutch_aligner_y, z]) {
                cube([width, switch_clutch_aligner_length, height + e]);
            }

            if (top) {
                translate([speaker_position.x, speaker_position.y, z - e]) {
                    _c(
                        speaker_cavity_diameter + ENCLOSURE_INNER_WALL,
                        height + e * 3,
                        chamfer = 0
                    );
                }
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
        diameter = LIGHTPIPE_DIAMETER + tolerance * 2,
        fixture = false,
        bottom = false,
        top = false,
        gasket_depth = ENCLOSURE_INNER_WALL,
        gasket_brim = ENCLOSURE_INNER_WALL,
        $fn = 24
    ) {
        x = pcb_position.x + led_position_on_pcb.x;
        y = pcb_position.y + pcb_length + tolerance;
        led_center_z = pcb_position.z + pcb_height
            + PCB_Z_OFF_PCB + LED_BASE_HEIGHT + LIGHTPIPE_DIAMETER / 2;

        fixture_width = diameter + ENCLOSURE_INNER_WALL * 2 + 4;
        fixture_length = dimensions.y - y - e;

        if (fixture) {
            z = bottom
                ? ENCLOSURE_FLOOR_CEILING - e
                : led_center_z + e;

            difference() {
                translate([x - fixture_width / 2, y, z]) {
                    cube([
                        fixture_width,
                        fixture_length,
                        bottom
                            ? led_center_z - z
                            : dimensions.z - z - ENCLOSURE_FLOOR_CEILING + e
                    ]);
                }

                if (top) {
                    translate([
                        speaker_position.x,
                        speaker_position.y,
                        z - e
                    ]) {
                        cylinder(
                            d = speaker_cavity_diameter + ENCLOSURE_INNER_WALL / 2,
                            h = dimensions.z - z + e * 2
                        );
                    }
                }
            }
        } else {
            translate([x, y - e, led_center_z]) {
                rotate([-90, 0, 0]) cylinder(
                    d = diameter,
                    h = dimensions.y - y - gasket_depth + e
                );
            }

            translate([x, dimensions.y - gasket_depth - e, led_center_z]) {
                rotate([-90, 0, 0]) cylinder(
                    d = diameter - gasket_brim * 2,
                    h = gasket_depth + e * 2
                );
            }

            if (bottom) {
                translate([
                    x - (fixture_width + tolerance * 2) / 2,
                    y - e,
                    led_center_z - e
                ]) {
                    cube([
                        (fixture_width + tolerance * 2),
                        fixture_length + e * 2,
                        ENCLOSURE_LIP_HEIGHT + e * 2
                    ]);
                }
            }
        }
    }

    if (show_bottom) {
        difference() {
            union() {
                _half(bottom_height, lip = true);

                color(outer_color) {
                    _bottom_pcb_fixtures();
                    _switch_clutch_fixture(top = false);
                    _lightpipe_exposure(fixture = true, bottom = true);
                    battery_holder_fixtures(
                        web_length = pcb_position.y -
                            (battery_holder_position.y + battery_holder_dimensions.y)
                            // TODO: tidy against endstop_y
                            - (ENCLOSURE_INNER_WALL + tolerance * 4),
                        web_height = pcb_position.z + PCB_HEIGHT - ENCLOSURE_FLOOR_CEILING,
                        battery_holder_position = battery_holder_position,
                        tolerance = tolerance
                    );
                }
            }

            color(cavity_color) {
                _bottom_engraving();
                _switch_clutch_exposure();
                _lightpipe_exposure(fixture = false, bottom = true);
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
                    _speaker_fixture();
                    _switch_clutch_fixture(top = true);
                    _lightpipe_exposure(fixture = true, top = true);
                }
            }

            color(cavity_color) {
                _speaker_cavity();
                _speaker_grill();
                _button_rocker_cavity();
                _top_engraving();
                _switch_clutch_exposure();
                _lightpipe_exposure(fixture = false, top = true);
            }
        }
    }
}
