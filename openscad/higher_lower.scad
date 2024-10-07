include <../../parts_cafe/openscad/batteries-aaa.scad>;
include <../../parts_cafe/openscad/battery_holder.scad>;
include <../../parts_cafe/openscad/console.scad>;
include <../../parts_cafe/openscad/nuts_and_bolts.scad>;
include <../../parts_cafe/openscad/speaker-AZ40R.scad>;

use <../../scout/openscad/switch_clutch.scad>;

include <button_rocker.scad>;
include <enclosure.scad>;
include <pcb.scad>;

SCOUT_DEFAULT_GUTTER = 3.4; // default_gutter = keys_x = ENCLOSURE_WALL + key_gutter
OUTER_GUTTER = 5;

module higher_lower(
    width = 25.4 * 3,
    length = 25.4 * 3,
    height = 25.4 * 1, // TODO: reduce

    pcb_width = PCB_WIDTH,
    pcb_length = PCB_LENGTH,

    show_enclosure_bottom = true,
    show_battery_holder = true,
    show_batteries = true,
    show_pcb = true,
    show_switch_clutch = true,
    show_speaker = true,
    show_fasteners = true,
    show_accoutrements = true,
    show_rocker = true,
    show_enclosure_top = true,

    control_exposure = 2,
    control_clearance = .6,

    outer_gutter = OUTER_GUTTER,
    default_gutter = SCOUT_DEFAULT_GUTTER,
    button_gutter = SCOUT_DEFAULT_GUTTER / -2,
    label_gutter = 1,

    accessory_fillet = 1,

    // NOTE: clearances supercede tolerance
    pcb_top_clearance = PCB_TOP_CLEARANCE,
    pcb_bottom_clearance = PCB_BOTTOM_CLEARANCE,

    pcb_screw_hole_positions = [
        [PCB_WIDTH / 2, 0]
    ],
    pcb_post_hole_positions = [
        PCB_HOLE_POSITIONS[0],
        PCB_HOLE_POSITIONS[3]
    ],

    screw_length = 1/2 * 25.4,
    screw_head_clearance = 1,
    screw_beyond_nut = 1,

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
    button_length = (speaker_grill_size - button_gutter) / 2;

    battery_holder_dimensions = get_battery_holder_dimensions(
        battery_count,
        tolerance
    );
    battery_holder_position = [
        (width - battery_holder_dimensions.x) / 2,
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

    pcb_position = [
        (width - pcb_width) / 2,
        speaker_position.y - pcb_length / 2,
        speaker_position.z - PCB_HEIGHT - pcb_top_clearance
    ];

    button_rocker_position = [
        speaker_grill_position.x + speaker_grill_size + default_gutter,
        speaker_grill_position.y,
        height - ENCLOSURE_FLOOR_CEILING - ROCKER_BRIM_HEIGHT - e
    ];
    button_height = ROCKER_BRIM_HEIGHT + ENCLOSURE_FLOOR_CEILING + control_exposure;

    enclosure_bottom_height = height / 2 - ENCLOSURE_LIP_HEIGHT / 2;
    enclosure_top_height = height - enclosure_bottom_height;

    nut_z = screw_head_clearance + SCREW_HEAD_HEIGHT + screw_length
        - screw_beyond_nut - NUT_HEIGHT;
    screw_clearance = height - nut_z - ENCLOSURE_FLOOR_CEILING - NUT_HEIGHT;

    echo("Enclosure", width / 25.4, length / 25.4, height / 25.4);
    echo("PCB", pcb_width / 25.4, pcb_length / 25.4);
    echo("Button", button_width / 25.4, button_length / 25.4);
    echo("Speaker center on PCB", [
        (speaker_position.x - pcb_position.x) / 25.4,
        (speaker_position.y - pcb_position.y) / 25.4,
    ]);

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
                    include_nub_fixture_cavities = false,
                    include_wire_channel = false,

                    outer_color = enclosure_outer_color,
                    cavity_color = enclosure_cavity_color,

                    quick_preview = quick_preview
                );
            }
        }
    }

    if (show_rocker) {
        // TODO: account for distance to buttons
        translate(button_rocker_position) {
            button_rocker(
                button_width, button_length, button_height,
                gutter = button_gutter,
                brim_height = ROCKER_BRIM_HEIGHT,
                fillet = quick_preview ? 0 : accessory_fillet,
                outer_color = control_outer_color,
                cavity_color = control_cavity_color
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

            button_dimensions = [button_width, button_length],
            button_rocker_position = button_rocker_position,
            button_gutter = button_gutter,

            label_gutter = label_gutter,

            top_engraving_dimensions = [
                available_width,
                available_length - speaker_grill_size - default_gutter
            ],
            top_engraving_position = [outer_gutter, outer_gutter],

            pcb_width = pcb_width,
            pcb_length = pcb_length,

            pcb_screw_hole_positions = pcb_screw_hole_positions,
            pcb_post_hole_positions = pcb_post_hole_positions,

            screw_clearance = screw_clearance,
            screw_head_clearance = screw_head_clearance,

            switch_clutch_web_length_extension = switch_clutch_web_length_extension,

            tolerance = tolerance,

            outer_color = enclosure_outer_color,
            cavity_color = enclosure_cavity_color,

            show_dfm = !quick_preview,

            quick_preview = quick_preview
        );
    }

    if (show_pcb) {
        translate([pcb_position.x, pcb_position.y, pcb_position.z - e * 2]) {
            pcb(
                show_board = show_pcb,
                show_switches = show_accoutrements,
                show_led = show_accoutrements,

                rocker_center_x = button_rocker_position.x - pcb_position.x
                    + button_width / 2,
                rocker_center_y = button_rocker_position.y - pcb_position.y
                    + button_length + button_gutter / 2,
                button_dimensions = [button_width, button_length],
                button_gutter = button_gutter,

                side_switch_position = side_switch_position,

                width = pcb_width,
                length = pcb_length
            );
        }
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

                fillet = accessory_fillet,
                side_overexposure = control_exposure,
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

    if (show_fasteners) {
        % screws(
            positions = pcb_screw_hole_positions,
            pcb_position = pcb_position,
            length = screw_length,
            z = screw_head_clearance - e
        );

        % nuts(
            pcb_position = pcb_position,
            positions = pcb_screw_hole_positions,
            z = nut_z - e
        );
    }
}

SHOW_ENCLOSURE_BOTTOM = true;
SHOW_BATTERY_HOLDER = true;
SHOW_BATTERIES = true;
SHOW_PCB = true;
SHOW_SWITCH_CLUTCH = true;
SHOW_SPEAKER = true;
SHOW_FASTENERS = true;
SHOW_ACCOUTREMENTS = true;
SHOW_ROCKER = true;
SHOW_ENCLOSURE_TOP = true;

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
    show_fasteners = SHOW_FASTENERS,
    show_accoutrements = SHOW_ACCOUTREMENTS,
    show_rocker = SHOW_ROCKER,
    show_enclosure_top = SHOW_ENCLOSURE_TOP,

    tolerance = DEFAULT_TOLERANCE,

    quick_preview = $preview
);

// rocker buttons
// translate([60, -1, -1]) cube([100, 100, 100]);

// fastener
// translate([38, -1, -1]) cube([100, 100, 100]);
}