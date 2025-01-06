include <../../parts_cafe/openscad/batteries-aaa.scad>;
include <../../parts_cafe/openscad/battery_holder.scad>;
include <../../parts_cafe/openscad/console.scad>;
include <../../parts_cafe/openscad/socket-35PM2A.scad>;
include <../../parts_cafe/openscad/speaker-AZ40R.scad>;

use <../../scout/openscad/switch_clutch.scad>;

include <button_rocker.scad>;
include <enclosure.scad>;
include <pcb.scad>;

SCOUT_DEFAULT_GUTTER = 3.4; // default_gutter = keys_x = ENCLOSURE_WALL + key_gutter
OUTER_GUTTER = 5;

// A quarter inch of standard "1/4" glue stick
LIGHTPIPE_DIAMETER = 7;
LIGHTPIPE_LENGTH = 25.4 / 4;

module higher_lower(
    width = 25.4 * 3,
    length = 25.4 * 3,
    height = 25.4 * 1,

    pcb_width = PCB_WIDTH,
    pcb_length = PCB_LENGTH,

    show_enclosure_bottom = true,
    show_battery_holder = true,
    show_batteries = true,
    show_pcb = true,
    show_switch_clutch = true,
    show_speaker = true,
    show_rocker = true,
    show_lightpipe = true,
    show_enclosure_top = true,

    show_clearance = false,

    button_exposure = 4,
    switch_exposure = 2,
    control_clearance = .6,

    outer_gutter = OUTER_GUTTER,
    default_gutter = SCOUT_DEFAULT_GUTTER,
    rocker_xy_clearance = SCOUT_DEFAULT_GUTTER / -2,
    rocker_z_clearance = 1,
    label_gutter = 2,

    accessory_fillet = 1,

    pcb_component_to_outer_part_clearance = 1,
    pcb_bottom_clearance = PCB_BOTTOM_CLEARANCE,

    pcb_post_hole_positions = [
        PCB_HOLE_POSITIONS[0],
        PCB_HOLE_POSITIONS[2],
        PCB_HOLE_POSITIONS[4],
    ],

    battery_count = 2,

    tolerance = 0,

    enclosure_outer_color = "#FF69B4",
    enclosure_cavity_color = "#CC5490",

    control_outer_color = "#FFFFFF",
    control_cavity_color = "#EEEEEE",

    side_switch_position = round($t),
    switch_clutch_web_length_extension = 4, // NOTE: eyeballed!

    quick_preview = true
) {
    e = .00319;

    available_width = width - outer_gutter * 2;
    available_length = length - outer_gutter * 2;

    // NOTE: 2:1 ratio here assumes portrait/square enclosure dimensions.
    // It will look odd if enclosure width > length.
    speaker_grill_size = (width - outer_gutter * 2 - default_gutter) / 3 * 2;
    button_width = speaker_grill_size / 2;
    button_length = (speaker_grill_size - rocker_xy_clearance) / 2;

    battery_holder_dimensions = get_battery_holder_dimensions(
        battery_count,
        tolerance
    );
    battery_holder_position = [
        (width - battery_holder_dimensions.x) * (2/3),
        ENCLOSURE_WALL + tolerance * 2,
        ENCLOSURE_FLOOR_CEILING
    ];

    speaker_grill_position = [
        outer_gutter,
        length - speaker_grill_size - outer_gutter
    ];
    speaker_position = [
        speaker_grill_position.x + speaker_grill_size / 2,
        speaker_grill_position.y + speaker_grill_size / 2,
        height - ENCLOSURE_FLOOR_CEILING - SPEAKER_HEIGHT
    ];

    // NOTE: ie, the closest it can get to speaker
    radius_difference = SPEAKER_DIAMETER / 2 + LIGHTPIPE_DIAMETER / 2
        + tolerance * 2 + ENCLOSURE_INNER_WALL;
    bump_xy = sqrt(pow(radius_difference, 2) / 2);
    lightpipe_position = [
        speaker_position.x - bump_xy,
        speaker_position.y + bump_xy
    ];

    // NOTE: This assumes LED is perfectly in top left corner...
    pcb_position = [
        lightpipe_position.x - LIGHTPIPE_DIAMETER / 2,
        lightpipe_position.y + LIGHTPIPE_DIAMETER / 2 - pcb_length,
        max(
            ENCLOSURE_FLOOR_CEILING + pcb_bottom_clearance,
            min(
                speaker_position.z
                    - (pcb_component_to_outer_part_clearance + PCB_TOP_CLEARANCE_UNDER_SPEAKER)
                    - PCB_HEIGHT,
                height - ENCLOSURE_FLOOR_CEILING
                    - LIGHTPIPE_LENGTH - pcb_component_to_outer_part_clearance
                    - LED_HEIGHT - PCB_Z_OFF_PCB
                    - PCB_HEIGHT
            )
        )
    ];

    button_rocker_position = [
        speaker_grill_position.x + speaker_grill_size + default_gutter,
        speaker_grill_position.y,
        height - ENCLOSURE_FLOOR_CEILING - ROCKER_BRIM_HEIGHT
            - rocker_z_clearance
    ];
    button_height = ROCKER_BRIM_HEIGHT + ENCLOSURE_FLOOR_CEILING + button_exposure;

    switch_clutch_grip_height = height
        - (pcb_position.z + PCB_HEIGHT + SWITCH_ACTUATOR_Z) * 2;

    enclosure_bottom_height = height / 2;
    enclosure_top_height = height - enclosure_bottom_height;

    echo("Enclosure", width / 25.4, length / 25.4, height / 25.4);
    echo("PCB", pcb_width / 25.4, pcb_length / 25.4);
    echo("Button", button_width / 25.4, button_length / 25.4);
    echo("Speaker",
        SPEAKER_DIAMETER / 2,
        get_speaker_fixture_diameter(tolerance),
        [
            // consts here are bottom left of PCB in KiCad
            (speaker_position.x - pcb_position.x) + 101.6,
            114.3 - (speaker_position.y - pcb_position.y),
        ]
    );

    if (show_batteries || show_battery_holder) {
        translate([
            BATTERY_HOLDER_DEFAULT_WALL + tolerance + battery_holder_position.x,
            battery_holder_position.y + BATTERY_HOLDER_DEFAULT_WALL + tolerance,
            battery_holder_position.z + BATTERY_HOLDER_DEFAULT_FLOOR + e
        ]) {
            if (show_batteries) {
                % battery_array(
                    count = battery_count
                );
            }

            if (show_battery_holder) {
                battery_holder(
                    wall = BATTERY_HOLDER_DEFAULT_WALL,
                    floor = BATTERY_HOLDER_DEFAULT_FLOOR,
                    tolerance = tolerance,
                    count = battery_count,

                    fillet = quick_preview ? 0 : BATTERY_HOLDER_FILLET,

                    include_wire_relief_hitches = false,
                    include_wire_channel = true,
                    use_wire_channel_as_relief = true,

                    outer_color = enclosure_outer_color,
                    cavity_color = enclosure_cavity_color,

                    quick_preview = quick_preview
                );
            }
        }
    }

    if (show_rocker) {
        offset = [
            button_rocker_position.x - pcb_position.x,
            button_rocker_position.y - pcb_position.y
        ];

        switch_centers = [
            get_rocker_switch_center(PCB_SWITCH_CENTERS[0], offset),
            get_rocker_switch_center(PCB_SWITCH_CENTERS[1], offset),
        ];

        translate(button_rocker_position) {
            button_rocker(
                button_width, button_length, button_height,
                switch_centers = switch_centers,
                plunge = button_rocker_position.z
                    - (pcb_position.z + PCB_HEIGHT + SPST_ACTUATOR_HEIGHT_OFF_PCB),
                xy_clearance = rocker_xy_clearance,
                brim_height = ROCKER_BRIM_HEIGHT,
                fillet = quick_preview ? 0 : accessory_fillet,
                tolerance = tolerance * 2, // intentionally loose
                outer_color = control_outer_color,
                cavity_color = control_cavity_color,
                quick_preview = quick_preview
            );
        }
    }

    if (show_enclosure_bottom || show_enclosure_top) {
        enclosure(
            show_top = show_enclosure_top,
            show_bottom = show_enclosure_bottom,

            dimensions = [width, length, height],
            bottom_height = enclosure_bottom_height,
            top_height = enclosure_top_height,

            control_clearance = control_clearance,

            pcb_position = pcb_position,

            speaker_position = speaker_position,
            speaker_grill_dimensions = [speaker_grill_size, speaker_grill_size],
            speaker_grill_position = speaker_grill_position,

            lightpipe_position = lightpipe_position,

            button_dimensions = [button_width, button_length],
            button_rocker_position = button_rocker_position,
            rocker_xy_clearance = rocker_xy_clearance,

            battery_holder_dimensions = battery_holder_dimensions,
            battery_holder_position = battery_holder_position,

            label_gutter = label_gutter,

            top_engraving_dimensions = [
                available_width,
                available_length - speaker_grill_size - default_gutter
            ],
            top_engraving_position = [outer_gutter, outer_gutter],

            pcb_width = pcb_width,
            pcb_length = pcb_length,

            pcb_post_hole_positions = pcb_post_hole_positions,

            switch_clutch_grip_height = switch_clutch_grip_height,
            switch_clutch_web_length_extension = switch_clutch_web_length_extension,

            tolerance = tolerance,

            outer_color = enclosure_outer_color,
            cavity_color = enclosure_cavity_color,

            show_dfm = !quick_preview,

            quick_preview = quick_preview
        );
    }

    translate([pcb_position.x, pcb_position.y, pcb_position.z - e * 2]) {
        pcb(
            show_board = show_pcb,
            show_switches = show_pcb,
            show_led = show_pcb,
            show_clearance = show_clearance,

            speaker_position = [
                speaker_position.x - pcb_position.x,
                speaker_position.y - pcb_position.y
            ],
            side_switch_position = side_switch_position,

            tolerance = tolerance,

            width = pcb_width,
            length = pcb_length
        );
    }

    if (show_switch_clutch) {
        // HACK: lots of arbitrary values here to make Scout's clutch work. eh
        translate([
            pcb_position.x + SWITCH_ORIGIN.x,
            pcb_position.y + PCB_SWITCH_Y + SWITCH_ORIGIN.y,
            0
        ]) {
            switch_clutch(
                position = side_switch_position,

                web_available_width = pcb_position.x - ENCLOSURE_WALL,
                web_length_extension = switch_clutch_web_length_extension,

                enclosure_height = height,

                x_clearance = .2,

                grip_height = switch_clutch_grip_height,

                fillet = accessory_fillet,
                side_overexposure = switch_exposure,
                tolerance = tolerance,

                outer_color = control_outer_color,
                cavity_color = control_cavity_color,

                quick_preview = quick_preview
            );
        }
    }

    if (show_speaker) {
        % translate([
            speaker_position.x,
            speaker_position.y,
            speaker_position.z - e
        ]) {
            speaker($fn = 120);
        }
    }

    if (show_lightpipe) {
        % translate([
            lightpipe_position.x,
            lightpipe_position.y,
            height - ENCLOSURE_FLOOR_CEILING - LIGHTPIPE_LENGTH - e
        ]) {
            % cylinder(
                d = LIGHTPIPE_DIAMETER,
                h = LIGHTPIPE_LENGTH
            );
        }
    }

    if (show_clearance) {
        translate([
            ENCLOSURE_WALL + SOCKET_INNER_HEIGHT + e,
            10,
            (ENCLOSURE_FLOOR_CEILING + enclosure_bottom_height + ENCLOSURE_LIP_HEIGHT) / 2
        ]) rotate([0, -90, 0]) {
            % socket();
        }
    }
}

SHOW_ENCLOSURE_BOTTOM = true;
SHOW_BATTERY_HOLDER = true;
SHOW_BATTERIES = true;
SHOW_PCB = true;
SHOW_SWITCH_CLUTCH = true;
SHOW_SPEAKER = true;
SHOW_ROCKER = true;
SHOW_LIGHTPIPE = true;
SHOW_ENCLOSURE_TOP = true;

SHOW_CLEARANCE = false;

DEFAULT_TOLERANCE = .1;

// rotate([0,180,0])
difference() {
higher_lower(
    show_enclosure_bottom = SHOW_ENCLOSURE_BOTTOM,
    show_battery_holder = SHOW_BATTERY_HOLDER,
    show_batteries = SHOW_BATTERIES,
    show_pcb = SHOW_PCB,
    show_switch_clutch = SHOW_SWITCH_CLUTCH,
    show_speaker = SHOW_SPEAKER,
    show_rocker = SHOW_ROCKER,
    show_lightpipe = SHOW_LIGHTPIPE,
    show_enclosure_top = SHOW_ENCLOSURE_TOP,

    show_clearance = SHOW_CLEARANCE,

    tolerance = DEFAULT_TOLERANCE,

    quick_preview = $preview
);

// rocker buttons
// translate([60.7, -1, -1]) cube([100, 100, 100]);

// middle
// translate([38, -1, -1]) cube([100, 100, 100]);

// lightpipe
// translate([10, -1, -1]) cube([100, 100, 100]);
}