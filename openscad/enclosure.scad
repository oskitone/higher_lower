include <../../parts_cafe/openscad/battery_holder_fixtures.scad>;
include <../../parts_cafe/openscad/diagonal_grill.scad>;
include <../../parts_cafe/openscad/enclosure_engraving.scad>;
include <../../parts_cafe/openscad/enclosure.scad>;
include <../../parts_cafe/openscad/flat_top_rectangular_pyramid.scad>;
include <../../parts_cafe/openscad/pcb_mounting_columns.scad>;
include <../../parts_cafe/openscad/ring.scad>;

include <pcb.scad>;

SWITCH_CLUTCH_GRIP_LENGTH = 10;

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

    lightpipe_position = [0,0],

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

    switch_clutch_grip_height = 0,
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
                depth + e,
                size = DIAGONAL_GRILL_SIZE
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
            include_disassembly_dimples = true,
            include_disassembly_wedges = true,
            outer_color = outer_color,
            cavity_color = cavity_color,
            $fn = quick_preview ? undef : DEFAULT_ROUNDING
        );
    }

    module _bottom_pcb_fixtures(
        button_support_length = 15 // NOTE: eyeballed!
    ) {
        pcb_mounting_columns(
            pcb_position = pcb_position,
            wall = ENCLOSURE_INNER_WALL,
            pcb_screw_hole_positions = [],
            pcb_post_hole_positions = pcb_post_hole_positions,
            tolerance = tolerance,
            enclosure_floor_ceiling = ENCLOSURE_FLOOR_CEILING,
            pcb_hole_diameter = PCB_HOLE_DIAMETER,
            registration_nub_height = PCB_HEIGHT,
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

    module _switch_clutch_deobstruction_cavity(
        width = 3 // NOTE: arbitrary
    ) {
        translate([
            pcb_position.x - width,
            switch_clutch_aligner_y - tolerance - e,
            -e
        ]) {
            cube([
                width,
                switch_clutch_aligner_length
                    + tolerance * 2 + e * 2,
                dimensions.z + e * 2
            ]);
        }
    }

    module _speaker_fixture() {
        difference() {
            translate(speaker_position) {
                speaker_fixture(
                    height = SPEAKER_HEIGHT + e,
                    wall = ENCLOSURE_INNER_WALL,

                    tab_cavity_count = 2,
                    tab_cavity_rotation = 0,

                    tolerance = tolerance,
                    quick_preview = quick_preview
                );
            }

            // NOTE: Defensive! Only needed when fixture flows
            // into clutch's area
            _switch_clutch_deobstruction_cavity();
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

        width = button_dimensions.x + gutter * 2;
        length = button_dimensions.y * 2
            + rocker_xy_clearance + gutter * 2;
        height = ENCLOSURE_FLOOR_CEILING + e * 2;

        translate([
            button_rocker_position.x - gutter,
            button_rocker_position.y - gutter,
            dimensions.z - ENCLOSURE_FLOOR_CEILING - e
        ]) {
            difference() {
                cube([width, length, height]);

                for (x = [0, width]) {
                    translate([x, length / 2, -e]) {
                        cylinder(
                            r = gutter + ROCKER_ENCLOSURE_FIXTURE_DEPTH,
                            h = height + e * 2,
                            $fn = 8
                        );
                    }
                }
            }
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
        height = switch_clutch_grip_height + tolerance * 4;

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
        fixture = false,
        fixture_wall = ENCLOSURE_INNER_WALL,
        fixture_shim_width = 1,
        fixture_shim_length = .2,
        fixture_shim_count = 3,
        exposure_diameter = DIAGONAL_GRILL_SIZE * 2.75,
        $fn = quick_preview ? undef : 24
    ) {
        fixture_inner_diameter =  LIGHTPIPE_DIAMETER + fixture_shim_length * 2;

        fixture_outer_diameter = min(
            fixture_inner_diameter + fixture_wall * 2,
            (
                min(lightpipe_position.x, dimensions.y - lightpipe_position.y)
                - fixture_wall - tolerance * 2
            ) * 2
        );

        fixture_height = LIGHTPIPE_LENGTH + e;

        if (fixture) {
            difference() {
                translate(lightpipe_position) {
                    ring(
                        diameter = fixture_outer_diameter,
                        height = fixture_height,
                        inner_diameter = fixture_inner_diameter
                    );

                    for (i = [0 : fixture_shim_count - 1]) {
                        rotate([0, 0, (360 / fixture_shim_count) * i]) {
                            translate([
                                fixture_shim_width / -2,
                                fixture_inner_diameter / 2 - fixture_shim_length,
                                0
                            ]) {
                                cube([
                                    fixture_shim_width,
                                    fixture_shim_length,
                                    fixture_height
                                ]);
                            }
                        }
                    }
                }

                translate([speaker_position.x, speaker_position.y, lightpipe_position.z - e]) {
                    _c(
                        speaker_cavity_diameter,
                        fixture_height + e * 2,
                        chamfer = 0
                    );
                }

                _switch_clutch_deobstruction_cavity();
            }
        } else {
            intersection() {
                translate([
                    lightpipe_position.x,
                    lightpipe_position.y,
                    dimensions.z - ENCLOSURE_FLOOR_CEILING - e
                ]) {
                    cylinder(
                        d = exposure_diameter,
                        h = ENCLOSURE_FLOOR_CEILING - ENCLOSURE_ENGRAVING_DEPTH + e * 2
                    );
                }

                _speaker_grill(ENCLOSURE_FLOOR_CEILING + e * 2);
            }
        }
    }

    if (show_bottom) {
        web_length = pcb_position.y
            - get_battery_holder_back_hitch_position(
                battery_holder_position = battery_holder_position,
                battery_holder_dimensions = battery_holder_dimensions,
                tolerance = tolerance
            ).y
            - ENCLOSURE_WALL - tolerance;

        difference() {
            union() {
                _half(bottom_height, lip = true);

                color(outer_color) {
                    _bottom_pcb_fixtures();
                    _switch_clutch_fixture(top = false);
                    battery_holder_enclosure_fixtures(
                        battery_holder_dimensions = battery_holder_dimensions,
                        web_length = web_length,
                        web_height = pcb_position.z + PCB_HEIGHT - ENCLOSURE_FLOOR_CEILING,
                        battery_holder_position = battery_holder_position,
                        tolerance = tolerance
                    );
                }
            }

            color(cavity_color) {
                _bottom_engraving();
                _switch_clutch_exposure();
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
                    _lightpipe_exposure(fixture = true);
                }
            }

            color(cavity_color) {
                _speaker_cavity();
                _speaker_grill();
                _button_rocker_cavity();
                _top_engraving();
                _switch_clutch_exposure();
                _lightpipe_exposure(fixture = false);
            }
        }
    }
}
