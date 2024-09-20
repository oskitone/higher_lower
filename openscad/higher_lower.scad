include <../../parts_cafe/openscad/battery.scad>;
include <../../parts_cafe/openscad/cherry_switch_keycap.scad>;
include <../../parts_cafe/openscad/nuts_and_bolts.scad>;
include <../../parts_cafe/openscad/switch_clutch_enclosure_engraving.scad>;
include <../../parts_cafe/openscad/switch_clutch.scad>;
include <../../parts_cafe/openscad/switch.scad>;
include <../../parts_cafe/openscad/wheel.scad>;

include <enclosure.scad>;
include <pcb.scad>;

SCOUT_KNOB_RADIUS = 10;

module wub(
    show_enclosure_bottom = true,
    show_battery = true,
    show_pcb = true,
    show_accoutrements = true,
    show_knobs = true,
    show_keycap = true,
    show_switch_clutches = true,
    show_enclosure_top = true,

    // NOTE: all layout is based on this!
    small_knob_radius = SCOUT_KNOB_RADIUS,

    knob_exposure = 8,
    keycap_exposure = 6,
    switch_exposure = 4,
    led_exposure = LED_DIAMETER / 2,

    enclosure_gutter = [5, 5],
    default_gutter = 5,
    label_gutter = 1,

    accessory_fillet = 1,

    control_exposure = .6,
    knob_vertical_clearance = .8,
    switch_clutch_vertical_clearance = .2,
    cherry_switch_vertical_clearance = .8,

    pcb_width = PCB_WIDTH,
    pcb_length = PCB_LENGTH,
    pcb_height = PCB_HEIGHT,

    pcb_screw_hole_positions = [
        // TODO: bring back and increase count
        /* PCB_HOLE_POSITIONS[5], */
    ],
    pcb_post_hole_positions = [
        PCB_HOLE_POSITIONS[0],
        PCB_HOLE_POSITIONS[1],
        PCB_HOLE_POSITIONS[3],
        PCB_HOLE_POSITIONS[4],
    ],

    pcb_speaker_position = PCB_SPEAKER_POSITION,
    pcb_switch_positions = PCB_SWITCH_POSITIONS,
    pcb_led_positions = PCB_LED_POSITIONS,
    pcb_cherry_switch_position = PCB_CHERRY_SWITCH_POSITION,
    pcb_headphone_jack_positions = PCB_HEADPHONE_JACK_POSITIONS,

    top_engraving_model_text_size = ENCLOSURE_ENGRAVING_TEXT_SIZE,

    label_size = ENCLOSURE_ENGRAVING_TEXT_SIZE,
    label_length = ENCLOSURE_ENGRAVING_LENGTH,

    // Screw can be 3/4" to 1"
    screw_clearance = 1/4 * 25.4 + 2,
    screw_clearance_usage = .5,
    screw_length = 3/4 * 25.4,

    tolerance = 0,

    switch_position = abs($t - .5) * 2,

    enclosure_outer_color = "#FF69B4",
    enclosure_cavity_color = "#CC5490",

    control_outer_color = "#FFFFFF",
    control_cavity_color = "#EEEEEE",

    quick_preview = true
) {
    e = .00319;

    pcb_to_battery_clearance = 11 + 2.54; // eyeballed
    pcb_bottom_clearance = max(2, CHERRY_SWITCH_PINS_CLEARANCE - pcb_height);

    width = ((small_knob_radius + control_exposure) * 2) * 3
        + default_gutter * 2
        + enclosure_gutter.x * 2;
    full_width_space = width - enclosure_gutter.x * 2;
    half_width_space = (full_width_space - default_gutter) / 2;

    // Intentionally no tolerance here for 1) tight fit and 2) so layout
    // doesn't unexpectedly change for arbitrarily loosener fits
    battery_position = [
        ENCLOSURE_WALL,
        ENCLOSURE_WALL,
        ENCLOSURE_FLOOR_CEILING
    ];

    pcb_position = [
        (width - pcb_width) / 2,
        battery_position.y + BATTERY_LENGTH + pcb_to_battery_clearance,
        battery_position.z + BATTERY_HEIGHT + BATTERY_SNAP_CLEARANCE
            - (pcb_height + CHERRY_SWITCH_BASE_HEIGHT)
            - (STOCK_CHERRY_SWITCH_KEYCAP_DIMENSIONS.z - ENCLOSURE_FLOOR_CEILING)
            + keycap_exposure
    ];

    function pcb_to_absolute_position(position, bump = [0, 0, 0]) = [
        position.x + pcb_position.x + bump.x,
        position.y + pcb_position.y + bump.y,
        pcb_position.z + pcb_height + bump.z
    ];

    big_knob_diameter = half_width_space - control_exposure * 2;
    big_knob_radius = big_knob_diameter / 2;
    big_knob_space_length = big_knob_diameter + control_exposure * 2
        + label_gutter + label_length;

    top_engraving_model_length = ENCLOSURE_ENGRAVING_GUTTER * 2
        + top_engraving_model_text_size;
    top_engraving_dimensions = [
        full_width_space,
        full_width_space * OSKITONE_LENGTH_WIDTH_RATIO
            + label_gutter + top_engraving_model_length
    ];
    top_engraving_position = enclosure_gutter;

    keycap_dimensions = [
        half_width_space - control_exposure * 2,
        half_width_space * (3 / 4) - control_exposure * 2,
        STOCK_CHERRY_SWITCH_KEYCAP_DIMENSIONS.z
    ];
    cherry_switch_z = pcb_position.z + pcb_height + CHERRY_SWITCH_BASE_HEIGHT;
    cherry_switch_center_position = [
        enclosure_gutter.x + half_width_space + default_gutter
            + half_width_space / 2,
        top_engraving_position.y
            + top_engraving_dimensions.y + default_gutter
            + keycap_dimensions.y / 2 + control_exposure
    ];

    speaker_grill_dimensions = [
        half_width_space,
        keycap_dimensions.y + control_exposure * 2
    ];
    speaker_grill_position = [
        enclosure_gutter.x,
        top_engraving_position.y + top_engraving_dimensions.y + default_gutter
    ];
    speaker_position = [
        speaker_grill_position.x + speaker_grill_dimensions.x / 2,
        speaker_grill_position.y + speaker_grill_dimensions.y / 2,
        pcb_position.z + pcb_height
    ];

    knob_row_space_dimensions = [
        (small_knob_radius + control_exposure) * 2 + default_gutter,
        (small_knob_radius + control_exposure) * 2
            + label_gutter + label_length
    ];

    knob_row_y = speaker_grill_position.y + speaker_grill_dimensions.y
        + default_gutter
        + big_knob_radius * 2 + control_exposure * 2
        + label_gutter + label_length
        + default_gutter;
    function get_small_knob_position(i = 0) = [
        knob_row_space_dimensions.x * i + enclosure_gutter.x
            + small_knob_radius + control_exposure,
        knob_row_y + small_knob_radius + control_exposure,
        pcb_position.z + pcb_height + PTV09A_POT_BASE_HEIGHT_FROM_PCB
    ];

    knob_positions = [
        [
            enclosure_gutter.x + big_knob_radius + control_exposure,
            speaker_grill_position.y + speaker_grill_dimensions.y
                + default_gutter
                + big_knob_radius + control_exposure,
            pcb_position.z + pcb_height + PTV09A_POT_BASE_HEIGHT_FROM_PCB
        ],
        get_small_knob_position(0),
        get_small_knob_position(1),
        get_small_knob_position(2),
    ];
    knob_radii = [
        big_knob_radius,
        small_knob_radius,
        small_knob_radius,
        small_knob_radius
    ];

    switch_clutch_space_dimensions = [
        half_width_space,
        (big_knob_space_length - default_gutter) / 2
    ];
    switch_clutch_window_dimensions = get_actuator_window_dimensions(
        width = (switch_clutch_space_dimensions.x - label_gutter) / 3,
        length = switch_clutch_space_dimensions.y
            - (label_gutter + label_length) - control_exposure * 2,
        label_gutter = label_gutter,
        control_clearance = control_exposure
    );
    switch_clutch_space_positions = [
        for (i = [0 : 1]) [
            enclosure_gutter.x + default_gutter
                + big_knob_radius * 2 + control_exposure * 2,
            speaker_grill_position.y + speaker_grill_dimensions.y
                + default_gutter
                + (switch_clutch_space_dimensions.y + default_gutter) * i
        ]
    ];

    length = knob_positions[1].y
        + small_knob_radius + control_exposure
        + label_gutter + label_length
        + enclosure_gutter.y;
    height = max(
        pcb_position.z + pcb_height + max(
            SPEAKER_HEIGHT,
            CHERRY_SWITCH_BASE_HEIGHT
        ) + ENCLOSURE_FLOOR_CEILING,
        ENCLOSURE_FLOOR_CEILING * 2 + BATTERY_HEIGHT + BATTERY_SNAP_CLEARANCE
    );

    knob_height = height + knob_exposure - knob_positions[0].z;

    control_brim_depth = ENCLOSURE_INNER_WALL + control_exposure;

    enclosure_bottom_height = pcb_position.z + ENCLOSURE_LIP_HEIGHT / 2;
    enclosure_top_height = height - enclosure_bottom_height;

    back_gutter = default_gutter * 2;

    headphone_jack_plug_diameter = 14;
    headphone_jack_positions = [
        for (x = [
            back_gutter + headphone_jack_plug_diameter / 2,
            back_gutter + headphone_jack_plug_diameter / 2
                + headphone_jack_plug_diameter + default_gutter
        ]) [
            x,
            length - ENCLOSURE_WALL - control_exposure
                - (HEADPHONE_JACK_LENGTH + HEADPHONE_JACK_BRIM_LENGTH),
            pcb_position.z + pcb_height + HEADPHONE_JACK_BARREL_Z
        ]
    ];

    led_positions = [
        for (x = [
            width - back_gutter - LED_DIAMETER / 2,
            width - back_gutter - LED_BASE_DIAMETER - LED_DIAMETER / 2,
        ]) [
            x,
            length - LED_HEIGHT + led_exposure,
            pcb_position.z + pcb_height + LED_BASE_DIAMETER / 2
        ]
    ];

    switch_clutch_base_dimensions = [
        switch_clutch_window_dimensions.x + 2, // NOTE: eyeballed
        switch_clutch_window_dimensions.y + 5, // NOTE: eyeballed
        height - ENCLOSURE_FLOOR_CEILING - (pcb_position.z + pcb_height)
            - switch_clutch_vertical_clearance
    ];
    switch_clutch_actuator_dimensions = [
        switch_clutch_window_dimensions.x
            - control_exposure * 2 - tolerance * 2,
        switch_clutch_window_dimensions.y
            - control_exposure * 2 - tolerance * 2
            - SWITCH_ACTUATOR_TRAVEL,
        ENCLOSURE_FLOOR_CEILING + switch_exposure,
    ];

    nut_z = height - ENCLOSURE_FLOOR_CEILING - NUT_HEIGHT - screw_clearance;
    screw_head_clearance = nut_z - screw_length
        + NUT_HEIGHT - SCREW_HEAD_HEIGHT
        + screw_clearance * screw_clearance_usage;

    // TODO: remove when PCB_ placements are correct
    function get_hacked_pcb_xy(
        xy,
        bump = [0, 0],
        z = PCB_HEIGHT,
        pcb_offset = [-pcb_position.x, -pcb_position.y]
    ) = [
        xy.x + bump.x + pcb_offset.x,
        xy.y + bump.y + pcb_offset.y,
        z
    ];

    function get_hacked_pcb_xys(xys, bump = [0, 0]) = [for (xy = xys)
        get_hacked_pcb_xy(xy, bump)
    ];

    echo(
        "Enclosure",
        [width, length, height],
        [enclosure_bottom_height, enclosure_top_height]
    );
    echo(
        "Knobs",
        [[big_knob_diameter, knob_height], [small_knob_radius * 2, knob_height]]
    );
    echo(
        "Keycap",
        keycap_dimensions
    );
    echo(
        "Switch clutches (base + travel)", [
        switch_clutch_base_dimensions.x,
        switch_clutch_base_dimensions.y + SWITCH_ACTUATOR_TRAVEL,
        switch_clutch_base_dimensions.z
    ]);

    if (show_battery) {
        position = battery_position;
        translate([position.x + e, position.y + e, position.z + e]) {
            % battery();
        }
    }

    if (show_enclosure_bottom || show_enclosure_top) {
        enclosure(
            show_top = show_enclosure_top,
            show_bottom = show_enclosure_bottom,

            dimensions = [width, length, height],
            bottom_height = enclosure_bottom_height,
            top_height = enclosure_top_height,

            pcb_position = pcb_position,

            knob_positions = knob_positions,
            knob_radii = knob_radii,
            knob_labels = ["PITCH", "DIFF", "RATE", "VOL"],

            control_clearance = control_exposure,
            control_brim_depth = control_brim_depth,

            speaker_position = speaker_position,
            led_positions = led_positions,
            cherry_switch_center_position = cherry_switch_center_position,

            switch_clutch_space_positions = switch_clutch_space_positions,
            switch_clutch_labels = ["MODE", "GLIDE"],
            switch_clutch_position_labels = [
                ["HORN", "SIREN"],
                ["OFF", "ON"],
            ],
            switch_clutch_window_dimensions = switch_clutch_window_dimensions,
            switch_clutch_space_dimensions = switch_clutch_space_dimensions,
            switch_clutch_base_dimensions = switch_clutch_base_dimensions,

            headphone_jack_positions = headphone_jack_positions,
            headphone_jack_plug_diameter = headphone_jack_plug_diameter,

            speaker_grill_dimensions = speaker_grill_dimensions,
            speaker_grill_position = speaker_grill_position,

            battery_position = battery_position,

            keycap_dimensions = keycap_dimensions,
            switch_clutch_actuator_dimensions =
                switch_clutch_actuator_dimensions,

            label_size = label_size,
            label_length = label_length,
            label_gutter = label_gutter,

            top_engraving_dimensions = top_engraving_dimensions,
            top_engraving_position = top_engraving_position,
            top_engraving_model_text_size = top_engraving_model_text_size,
            top_engraving_model_length = top_engraving_model_length,

            pcb_width = pcb_width,
            pcb_length = pcb_length,
            pcb_height = pcb_height,

            pcb_screw_hole_positions = pcb_screw_hole_positions,
            pcb_post_hole_positions = pcb_post_hole_positions,

            screw_clearance = screw_clearance,
            screw_head_clearance = screw_head_clearance,

            tolerance = tolerance,

            outer_color = enclosure_outer_color,
            cavity_color = enclosure_cavity_color,

            show_dfm = !quick_preview,

            quick_preview = quick_preview
        );
    }

    if (show_pcb || show_accoutrements) {
        position = pcb_position;
        translate([position.x, position.y, position.z - e * 2]) {
            pcb(
                show_board = show_pcb,
                show_silkscreen = show_pcb,

                show_speaker = show_accoutrements,
                show_cherry_switch = show_accoutrements,
                show_leds = show_accoutrements,
                show_pots = show_accoutrements,
                show_switches = show_accoutrements,
                show_headphone_jacks = show_accoutrements,

                switch_position = switch_position,

                dimensions = [pcb_width, pcb_length, pcb_height],

                cherry_switch_position = get_hacked_pcb_xy(
                    cherry_switch_center_position,
                    [CHERRY_SWITCH_BASE_WIDTH / -2, CHERRY_SWITCH_BASE_LENGTH / -2]
                ),
                headphone_jack_positions = get_hacked_pcb_xys(
                    headphone_jack_positions,
                    [HEADPHONE_JACK_WIDTH / -2, 0, 0]
                ),
                led_positions = get_hacked_pcb_xys(led_positions),
                pot_positions = get_hacked_pcb_xys(knob_positions),
                speaker_position = get_hacked_pcb_xy(speaker_position),
                switch_positions = get_hacked_pcb_xys(
                    switch_clutch_space_positions,
                    [
                        switch_clutch_actuator_dimensions.x / 2
                            + control_exposure + tolerance,
                        switch_clutch_window_dimensions.y / 2
                            - SWITCH_ORIGIN.y - SWITCH_BASE_LENGTH / 2
                    ]
                )
            );
        }
    }

    if (show_knobs) {
        for (i = [0 : len(knob_positions) - 1]) {
            translate(knob_positions[i]) {
                wheel(
                    diameter = knob_radii[i] * 2,
                    height = knob_height,
                    spokes_count = 0,
                    brodie_knob_count = 0,
                    dimple_count = 1,
                    round_bottom = false,
                    brim_diameter = (knob_radii[i] + control_brim_depth) * 2,
                    brim_height = height - knob_positions[i].z
                        - ENCLOSURE_FLOOR_CEILING - knob_vertical_clearance,
                    color = control_outer_color,
                    cavity_color = control_cavity_color,
                    tolerance = tolerance,
                    $fn = quick_preview ? undef : 36
                );
            }
        }
    }

    if (show_accoutrements) {
        % screws(
            positions = pcb_screw_hole_positions,
            pcb_position = pcb_position,
            length = screw_length,
            z = screw_head_clearance
        );

        % nuts(
            pcb_position = pcb_position,
            positions = pcb_screw_hole_positions,
            z = nut_z
        );
    }

    if (show_keycap) {
        translate([
            cherry_switch_center_position.x - keycap_dimensions.x / 2,
            cherry_switch_center_position.y - keycap_dimensions.y / 2,
            cherry_switch_z + e
        ]) {
            color(control_outer_color) cherry_switch_keycap(
                keycap_dimensions,
                exposed_height = keycap_exposure - CHERRY_SWITCH_TRAVEL,
                contact_width = keycap_dimensions.x - default_gutter,
                contact_length = keycap_dimensions.y - default_gutter,
                fillet = accessory_fillet,
                switch_position = switch_position,
                tolerance = tolerance,
                stem_fit_tolerance = tolerance / 2, // intentionally tight
                brim_dimensions = [
                    keycap_dimensions.x + control_brim_depth * 2,
                    keycap_dimensions.y + control_brim_depth * 2,
                    height - cherry_switch_z - ENCLOSURE_FLOOR_CEILING
                        - cherry_switch_vertical_clearance
                ],
                $fn = quick_preview ? undef : 12
            );
        }
    }

    if (show_switch_clutches) {
        for (position = switch_clutch_space_positions) {
            translate([
                position.x + switch_clutch_window_dimensions.x / 2,
                position.y + switch_clutch_window_dimensions.y / 2
                    - SWITCH_ORIGIN.y - SWITCH_BASE_LENGTH / 2,
                pcb_position.z + pcb_height - e
            ]) {
                switch_clutch(
                    base_width = switch_clutch_base_dimensions.x,
                    base_length = switch_clutch_base_dimensions.y,
                    base_height = switch_clutch_base_dimensions.z - e,

                    actuator_width = switch_clutch_actuator_dimensions.x,
                    actuator_length = switch_clutch_actuator_dimensions.y,
                    actuator_height = switch_clutch_actuator_dimensions.z
                        + switch_clutch_vertical_clearance,

                    position = switch_position,

                    fillet = accessory_fillet,

                    color = control_outer_color,
                    cavity_color = control_cavity_color,

                    tolerance = tolerance,

                    $fn = quick_preview ? undef : 12
                );
            }
        }
    }
}

SHOW_ENCLOSURE_BOTTOM = true;
SHOW_BATTERY = true;
SHOW_PCB = true;
SHOW_ACCOUTREMENTS = true;
SHOW_KNOBS = true;
SHOW_KEYCAP = true;
SHOW_SWITCH_CLUTCHES = true;
SHOW_ENCLOSURE_TOP = true;

DEFAULT_TOLERANCE = .1;

wub(
    show_enclosure_bottom = SHOW_ENCLOSURE_BOTTOM,
    show_battery = SHOW_BATTERY,
    show_pcb = SHOW_PCB,
    show_accoutrements = SHOW_ACCOUTREMENTS,
    show_knobs = SHOW_KNOBS,
    show_keycap = SHOW_KEYCAP,
    show_switch_clutches = SHOW_SWITCH_CLUTCHES,
    show_enclosure_top = SHOW_ENCLOSURE_TOP,

    tolerance = DEFAULT_TOLERANCE,

    quick_preview = $preview
);
