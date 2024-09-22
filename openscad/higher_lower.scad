include <../../parts_cafe/openscad/nuts_and_bolts.scad>;
include <../../parts_cafe/openscad/switch.scad>;
include <../../parts_cafe/openscad/speaker-AZ40R.scad>;

include <button_rocker.scad>;
include <enclosure.scad>;
include <pcb.scad>;

SCOUT_DEFAULT_GUTTER = 3.4; // default_gutter = keys_x = ENCLOSURE_WALL + key_gutter
OUTER_GUTTER = 5;

module higher_lower(
    show_enclosure_bottom = true,
    show_battery = true,
    show_pcb = true,
    show_accoutrements = true,
    show_buttons = true,
    show_enclosure_top = true,

    button_exposure = 2,

    outer_gutter = OUTER_GUTTER,
    default_gutter = SCOUT_DEFAULT_GUTTER,
    button_gutter = SCOUT_DEFAULT_GUTTER / -2,
    label_gutter = 1,

    accessory_fillet = 1,
    control_exposure = .6,

    speaker_bottom_clearance = 1,
    pcb_clearance = [1, 1, 5],

    pcb_screw_hole_positions = [
    ],
    pcb_post_hole_positions = [
    ],

    top_engraving_model_text_size = ENCLOSURE_ENGRAVING_TEXT_SIZE,

    label_size = ENCLOSURE_ENGRAVING_TEXT_SIZE,
    label_length = ENCLOSURE_ENGRAVING_LENGTH,

    // Screw can be 3/4" to 1"
    screw_clearance = 1/4 * 25.4 + 2,
    screw_clearance_usage = .5,
    screw_length = 3/4 * 25.4,

    battery_holder_dimensions = [60, 35, 12],

    tolerance = 0,

    enclosure_outer_color = "#FF69B4",
    enclosure_cavity_color = "#CC5490",

    control_outer_color = "#FFFFFF",
    control_cavity_color = "#EEEEEE",

    quick_preview = true
) {
    e = .00319;

    speaker_grill_size =
        get_speaker_fixture_diameter(tolerance, ENCLOSURE_INNER_WALL)
        - ENCLOSURE_INNER_WALL * 2 - (outer_gutter - ENCLOSURE_WALL) * 2;
    button_size = (speaker_grill_size - button_gutter) / 2;

    available_width = speaker_grill_size + button_size + default_gutter;

    width = available_width + outer_gutter * 2;
    length = width;
    height = ENCLOSURE_FLOOR_CEILING * 2 + battery_holder_dimensions.z
        + SPEAKER_HEIGHT + speaker_bottom_clearance;

    pcb_width = available_width;
    pcb_length = length - battery_holder_dimensions.y - pcb_clearance.y * 2
        - ENCLOSURE_WALL * 2;
    pcb_height = PCB_HEIGHT;

    pcb_position = [
        (width - pcb_width) / 2,
        ENCLOSURE_WALL + battery_holder_dimensions.y + pcb_clearance.y,
        ENCLOSURE_FLOOR_CEILING + pcb_clearance.z
    ];

    speaker_grill_dimensions = [
        speaker_grill_size,
        speaker_grill_size
    ];
    speaker_grill_position = [
        outer_gutter,
        length - speaker_grill_size - outer_gutter
    ];
    speaker_position = [
        speaker_grill_position.x + speaker_grill_dimensions.x / 2,
        speaker_grill_position.y + speaker_grill_dimensions.y / 2,
        height - ENCLOSURE_FLOOR_CEILING - SPEAKER_HEIGHT
    ];

    button_rocker_position = [
        speaker_grill_position.x + speaker_grill_dimensions.x + default_gutter,
        speaker_grill_position.y,
        height - ENCLOSURE_FLOOR_CEILING - ROCKER_BRIM_HEIGHT - e
    ];

    top_engraving_model_length = ENCLOSURE_ENGRAVING_GUTTER * 2
        + top_engraving_model_text_size;
    top_engraving_length =
        available_width * OSKITONE_LENGTH_WIDTH_RATIO
        + label_gutter + top_engraving_model_length;
    top_engraving_position = [default_gutter, default_gutter];

    enclosure_bottom_height = pcb_position.z + ENCLOSURE_LIP_HEIGHT / 2;
    enclosure_top_height = height - enclosure_bottom_height;

    nut_z = height - ENCLOSURE_FLOOR_CEILING - NUT_HEIGHT - screw_clearance;
    screw_head_clearance = nut_z - screw_length
        + NUT_HEIGHT - SCREW_HEAD_HEIGHT
        + screw_clearance * screw_clearance_usage;

    if (show_battery) {
        translate([
            (width - battery_holder_dimensions.x) / 2,
            ENCLOSURE_WALL + tolerance * 2,
            ENCLOSURE_FLOOR_CEILING + e
        ]) {
            % cube(battery_holder_dimensions);
        }
    }

    if (show_buttons) {
        _height = ROCKER_BRIM_HEIGHT + ENCLOSURE_FLOOR_CEILING + button_exposure;

        translate(button_rocker_position) {
            button_rocker(
                button_size, button_size, _height,
                gutter = button_gutter,
                brim_height = ROCKER_BRIM_HEIGHT,
                fillet = quick_preview ? 0 : accessory_fillet
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

            control_exposure = control_exposure,

            pcb_position = pcb_position,

            speaker_position = speaker_position,
            speaker_grill_dimensions = speaker_grill_dimensions,
            speaker_grill_position = speaker_grill_position,

            button_size = button_size,
            button_rocker_position = button_rocker_position,
            button_gutter = button_gutter,

            label_gutter = label_gutter,

            top_engraving_dimensions = [
                available_width,
                top_engraving_length
            ],
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

    if (show_pcb) {
        position = pcb_position;
        translate([position.x, position.y, position.z - e * 2]) {
            pcb(
                show_board = show_pcb,
                show_silkscreen = false,

                width = pcb_width,
                length = pcb_length
            );
        }
    }

    if (show_accoutrements) {
        % translate([
            speaker_position.x,
            speaker_position.y,
            speaker_position.z - e
        ]) {
            speaker($fn = 120);
        }

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
}

SHOW_ENCLOSURE_BOTTOM = true;
SHOW_BATTERY = true;
SHOW_PCB = true;
SHOW_ACCOUTREMENTS = true;
SHOW_BUTTONS = true;
SHOW_ENCLOSURE_TOP = true;

DEFAULT_TOLERANCE = .1;

// rotate([0,180,0])
difference() {
higher_lower(
    show_enclosure_bottom = SHOW_ENCLOSURE_BOTTOM,
    show_battery = SHOW_BATTERY,
    show_pcb = SHOW_PCB,
    show_accoutrements = SHOW_ACCOUTREMENTS,
    show_buttons = SHOW_BUTTONS,
    show_enclosure_top = SHOW_ENCLOSURE_TOP,

    tolerance = DEFAULT_TOLERANCE,

    quick_preview = $preview
);
// translate([60, -1, -1]) cube([100, 100, 100]);
}