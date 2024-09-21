include <../../parts_cafe/openscad/nuts_and_bolts.scad>;
include <../../parts_cafe/openscad/switch.scad>;
include <../../parts_cafe/openscad/speaker-AZ40R.scad>;

include <enclosure.scad>;
include <pcb.scad>;

SCOUT_KNOB_RADIUS = 10;

module higher_lower(
    show_enclosure_bottom = true,
    show_battery = true,
    show_pcb = true,
    show_accoutrements = true,
    show_enclosure_top = true,

    default_gutter = 5,
    label_gutter = 1,

    // TODO: what'd these do?
    accessory_fillet = 1,
    control_exposure = .6,

    pcb_width = PCB_WIDTH,
    pcb_length = PCB_LENGTH,
    pcb_height = PCB_HEIGHT,

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

    tolerance = 0,

    enclosure_outer_color = "#FF69B4",
    enclosure_cavity_color = "#CC5490",

    control_outer_color = "#FFFFFF",
    control_cavity_color = "#EEEEEE",

    quick_preview = true
) {
    e = .00319;

    // TODO: measure
    BATTERY_HOLDER_DIMENSIONS = [40, 30, 20];

    pcb_clearance = [1, 1, 2];

    speaker_fixture_diameter = get_speaker_fixture_diameter(tolerance);
    speaker_grill_size = speaker_fixture_diameter;

    button_size = speaker_grill_size / 2;

    width = speaker_grill_size + button_size + default_gutter * 3;
    length = 75;
    height = 20;

    battery_position = [
        (width - BATTERY_HOLDER_DIMENSIONS.x) / 2,
        ENCLOSURE_WALL + tolerance * 2,
        ENCLOSURE_FLOOR_CEILING
    ];

    pcb_position = [
        (width - pcb_width) / 2,
        length - ENCLOSURE_WALL - pcb_length - pcb_clearance.y,
        ENCLOSURE_FLOOR_CEILING + pcb_clearance.z
    ];

    speaker_grill_dimensions = [
        speaker_grill_size,
        speaker_grill_size
    ];
    speaker_grill_position = [
        default_gutter,
        top_engraving_position.y + top_engraving_dimensions.y + default_gutter
    ];
    speaker_position = [
        speaker_grill_position.x + speaker_grill_dimensions.x / 2,
        speaker_grill_position.y + speaker_grill_dimensions.y / 2,
        height - ENCLOSURE_FLOOR_CEILING - SPEAKER_HEIGHT
    ];

    enclosure_bottom_height = pcb_position.z + ENCLOSURE_LIP_HEIGHT / 2;
    enclosure_top_height = height - enclosure_bottom_height;

    nut_z = height - ENCLOSURE_FLOOR_CEILING - NUT_HEIGHT - screw_clearance;
    screw_head_clearance = nut_z - screw_length
        + NUT_HEIGHT - SCREW_HEAD_HEIGHT
        + screw_clearance * screw_clearance_usage;

    if (show_battery) {
        position = battery_position;
        translate([position.x + e, position.y + e, position.z + e]) {
            % cube(BATTERY_HOLDER_DIMENSIONS);
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

            speaker_position = speaker_position,

            speaker_grill_dimensions = speaker_grill_dimensions,
            speaker_grill_position = speaker_grill_position,

            battery_position = battery_position,

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
                show_silkscreen = false,

                dimensions = [pcb_width, pcb_length, pcb_height]
            );
        }
    }

    if (show_accoutrements) {
        % translate(speaker_position) speaker();

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

SHOW_ENCLOSURE_BOTTOM = false;
SHOW_BATTERY = false;
SHOW_PCB = false;
SHOW_ACCOUTREMENTS = false;
SHOW_ENCLOSURE_TOP = true;

DEFAULT_TOLERANCE = .1;

higher_lower(
    show_enclosure_bottom = SHOW_ENCLOSURE_BOTTOM,
    show_battery = SHOW_BATTERY,
    show_pcb = SHOW_PCB,
    show_accoutrements = SHOW_ACCOUTREMENTS,
    show_enclosure_top = SHOW_ENCLOSURE_TOP,

    tolerance = DEFAULT_TOLERANCE,

    quick_preview = $preview
);
