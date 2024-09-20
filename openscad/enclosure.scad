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

    knob_positions = [[0,0,0]],
    knob_radii = [0],
    knob_labels = [""],

    control_clearance = 0,
    control_brim_depth = 0,

    speaker_position = [0,0,0],
    led_positions = [[0,0,0]],
    cherry_switch_center_position = [0,0,0],

    switch_clutch_space_positions = [[0,0]],
    switch_clutch_labels = [""],
    switch_clutch_position_labels = [["",""]],
    switch_clutch_window_dimensions = [0,0],
    switch_clutch_space_dimensions = [0,0],
    switch_clutch_base_dimensions = [0,0,0],

    headphone_jack_plug_diameter = 14,
    headphone_jack_positions = [[0,0,0]],
    pcb_cherry_switch_position = PCB_CHERRY_SWITCH_POSITION,

    speaker_grill_dimensions = [0,0,0],
    speaker_grill_position = [0,0,0],

    battery_position = [0,0,0],

    keycap_dimensions = [10, 10],
    switch_clutch_actuator_dimensions = [6, 6, 6],

    label_size = ENCLOSURE_ENGRAVING_TEXT_SIZE,
    label_length = ENCLOSURE_ENGRAVING_LENGTH,
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

    control_gutter = control_clearance + tolerance;

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

    module _back_cavity(diameter, depth = ENCLOSURE_WALL) {
        translate([0,  -(depth + e), 0]) {
            rotate([-90, 0, 0]) {
                cylinder(
                    d = diameter,
                    h = depth + e * 2,
                    $fn = quick_preview ? undef : HIDEF_ROUNDING
                );
            }
        }
    }

    module _knob_cavities(
        labels = knob_labels
    ) {
        for (i = [0 : len(knob_positions) - 1]) {
            position = knob_positions[i];
            radius = knob_radii[i];

            y = position.y + radius + tolerance + label_gutter
                + label_length / 2;

            translate([position.x, position.y, cavity_z]) {
                _c(
                    (radius + control_gutter) * 2,
                    cavity_height
                );
            }

            render() enclosure_engraving(
                string = labels[i],
                size = label_size,
                position = [position.x, y + control_clearance],
                placard = [(radius + control_clearance) * 2, label_length],
                bottom = false,
                quick_preview = quick_preview,
                enclosure_height = dimensions.z
            );
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

    module _led_cavities(diameter = LED_BASE_DIAMETER + tolerance * 2) {
        hull() {
            for (position = led_positions) {
                translate([position.x, dimensions.y, 0]) {
                    translate([0, 0, position.z]) {
                        _back_cavity(diameter);
                    }

                    translate([
                        diameter / -2,
                        -ENCLOSURE_WALL - e,
                        bottom_height - e
                    ]) {
                        cube([diameter, ENCLOSURE_WALL + e * 2, e]);
                    }
                }
            }
        }
    }

    module _circular_wall(position = [0, 0, 0], inner_diameter = 0) {
        height = dimensions.z - position.z - ENCLOSURE_FLOOR_CEILING + e;

        translate([position.x, position.y, position.z]) {
            difference() {
                _c(
                    inner_diameter + ENCLOSURE_INNER_WALL * 2,
                    height,
                    chamfer = 0
                );

                translate([0, 0, -e]) {
                    _c(
                        inner_diameter,
                        height + e * 2,
                        chamfer = 0
                    );
                }
            }
        }
    }

    module _keycap_cavity(
        bleed = control_clearance + tolerance,
        z = cavity_z,
        height = cavity_height,
        include_dfm = show_dfm
    ) {
        function get_xy(i) = cherry_switch_center_position[i] - bleed
            - keycap_dimensions[i] / 2;

        width = keycap_dimensions.x + bleed * 2;
        length = keycap_dimensions.y + bleed * 2;

        translate([get_xy(0), get_xy(1), z - e]) {
            cube([width, length, height + e]);

            if (include_dfm) {
                translate([0, 0, height - chamfer]) {
                    flat_top_rectangular_pyramid(
                        top_width = width + chamfer * 2,
                        top_length = length + chamfer * 2,
                        bottom_width = width,
                        bottom_length = length,
                        height = chamfer
                    );
                }
            }
        }
    }

    module _switch_clutch_actuator_window_cavities() {
        _dimensions = [
            switch_clutch_window_dimensions.x,
            switch_clutch_window_dimensions.y,
            cavity_height
        ];

        for (i = [0 : len(switch_clutch_space_positions) - 1]) {
            position = switch_clutch_space_positions[i];
            label_y = position.y + _dimensions.y
                + label_gutter + label_length / 2;

            translate([position.x, position.y, cavity_z]) {
                cube(_dimensions);

                if (show_dfm) {
                    translate([0, 0, _dimensions.z - chamfer]) {
                        flat_top_rectangular_pyramid(
                            top_width = _dimensions.x + chamfer * 2,
                            top_length = _dimensions.y + chamfer * 2,
                            bottom_width = _dimensions.x,
                            bottom_length = _dimensions.y,
                            height = chamfer
                        );
                    }
                }
            }

            switch_clutch_enclosure_engraving(
                labels = switch_clutch_position_labels[i],
                actuator_window_dimensions = switch_clutch_window_dimensions,
                control_clearance = control_clearance,
                quick_preview = quick_preview,
                position = position,
                enclosure_height = dimensions.z
            );

            render() enclosure_engraving(
                string = switch_clutch_labels[i],
                size = label_size,
                position = [
                    position.x + switch_clutch_space_dimensions.x / 2,
                    label_y
                ],
                placard = [switch_clutch_space_dimensions.x, label_length],
                bottom = false,
                quick_preview = quick_preview,
                enclosure_height = dimensions.z
            );
        }
    }

    module _headphone_jack_cavities(
        bottom,

        cavity_diameter = HEADPHONE_JACK_BARREL_DIAMETER + tolerance * 2,
        plug_clearance_depth = .8, // NOTE: eyeballed

        labels = ["TRIG", "OUT"]
    ) {
        label_z = (headphone_jack_plug_diameter + label_length) / -2
            - label_gutter;
        label_width = headphone_jack_plug_diameter;

        module _entrance(jack_z) {
            height = bottom
                ? bottom_height + lip_height - jack_z
                : jack_z - bottom_height;
            z = bottom ? 0 : -height - e;

            if (height > 0) {
                translate([cavity_diameter / -2, -ENCLOSURE_WALL - e, z]) {
                    cube([cavity_diameter, ENCLOSURE_WALL + e * 2, height + e]);
                }
            }
        }

        for (i = [0 : len(headphone_jack_positions) - 1]) {
            position = headphone_jack_positions[i];

            translate([position.x, dimensions.y, position.z]) {
                _back_cavity(cavity_diameter);
                _back_cavity(
                    headphone_jack_plug_diameter,
                    plug_clearance_depth
                );
                _entrance(position.z);

                translate([0, 0, label_z]) rotate([90, 0, 0]) {
                    enclosure_engraving(
                        string = labels[i],
                        placard = [label_width, label_length],
                        chamfer_placard_top = !quick_preview,
                        bottom = true,
                        quick_preview = quick_preview,
                        enclosure_height = dimensions.z
                    );
                }
            }
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

    module _knob_collision_cavities() {
        z = pcb_position.z + pcb_height;
        height = dimensions.z - z - ENCLOSURE_FLOOR_CEILING;

        for (i = [0 : len(knob_positions) - 1]) {
            translate([knob_positions[i].x, knob_positions[i].y, z - e]) {
                cylinder(
                    d = (knob_radii[i] + control_brim_depth) * 2
                        + control_gutter * 2,
                    h = height + e * 3
                );
            }
        }
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

            _knob_collision_cavities();
        }
    }

    module _battery_holder(
        bottom,

        wall = ENCLOSURE_INNER_WALL,
        clearance = 1
    ) {
        total_width = BATTERY_WIDTH + BATTERY_SNAP_WIDTH;

        module _side_wall(
            length = BATTERY_LENGTH / 2,
            height = min(
                bottom_height - ENCLOSURE_FLOOR_CEILING + lip_height,
                BATTERY_HEIGHT
            )
        ) {
            translate([
                battery_position.x + total_width + clearance,
                ENCLOSURE_WALL - e,
                ENCLOSURE_FLOOR_CEILING - e
            ]) {
                flat_top_rectangular_pyramid(
                    top_width = wall,
                    top_length = 0,
                    bottom_width = wall,
                    bottom_length = length + e,
                    height = height + e,
                    top_weight_y = 0
                );
            }
        }

        module _top_ridges(
            length = BATTERY_LENGTH + clearance + e,
            count = 2
        ) {
            y = ENCLOSURE_WALL;
            z = battery_position.z + BATTERY_HEIGHT + clearance;

            plot = total_width / count;
            height = dimensions.z - ENCLOSURE_FLOOR_CEILING - z;

            for (i = [0 : count - 1]) {
                x = battery_position.x + plot * i + (plot - wall) / 2;

                translate([x, y - e, z]) {
                    cube([wall, length + e, height + e]);
                }
            }
        }

        module _back_rail(
            stalactite = false,

            width = total_width * .666,
            height = BATTERY_HEIGHT / 4
        ) {
            x = battery_position.x + (total_width - width) / 2;
            y = battery_position.y + BATTERY_LENGTH + clearance;
            z = stalactite
                ? dimensions.z - ENCLOSURE_FLOOR_CEILING - height + e
                : ENCLOSURE_FLOOR_CEILING - e;

            difference() {
                translate([x, y, z]) {
                    cube([width, wall, height + e]);

                    for (_x = [0, width - wall]) {
                        translate([_x, wall - e, 0]) {
                            flat_top_rectangular_pyramid(
                                top_width = wall,
                                top_length = stalactite ? height + e : 0,
                                bottom_width = wall,
                                bottom_length = stalactite ? 0 : height + e,
                                height = height + e,
                                top_weight_y = 0
                            );
                        }
                    }
                }

                if (stalactite) {
                    translate([speaker_position.x, speaker_position.y, z]) {
                        _c(
                            speaker_cavity_diameter + clearance * 2,
                            height + e,
                            chamfer = 0
                        );
                    }

                    _keycap_cavity(
                        bleed = control_brim_depth + control_gutter,
                        z = z,
                        height = height + e,
                        include_dfm = show_dfm
                    );
                }
            }
        }

        if (bottom) {
            _side_wall();
            _back_rail(stalactite = false);
        } else {
            _top_ridges();
            _back_rail(stalactite = true);
        }
    }

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
            string = "WUB PROTO PROOF C",
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
        color(outer_color) {
            _battery_holder(bottom = true);
        }

        difference() {
            color(outer_color) {
                _half(bottom_height, lip = true);
                _bottom_pcb_fixtures();
            }

            color(cavity_color) {
                _headphone_jack_cavities(bottom = true);
                _bottom_engraving();
                _led_cavities();
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
                    _speaker_plate();
                    _battery_holder(bottom = false);
                    _top_pcb_fixtures();
                }
            }

            color(cavity_color) {
                _knob_cavities();
                _speaker_cavity();
                _led_cavities();
                _keycap_cavity();
                _switch_clutch_actuator_window_cavities();
                _headphone_jack_cavities(bottom = false);
                _speaker_grill();
                _top_engraving();
                _disassembly_cavities(bottom = false);
            }
        }
    }
}
