include <../../parts_cafe/openscad/batteries-aaa.scad>;
include <../../parts_cafe/openscad/battery_holder.scad>;
include <../../parts_cafe/openscad/console.scad>;
include <../../parts_cafe/openscad/nuts_and_bolts.scad>;
include <../../parts_cafe/openscad/switch.scad>;
include <../../parts_cafe/openscad/speaker-AZ40R.scad>;

include <button_rocker.scad>;
include <enclosure.scad>;
include <pcb.scad>;

SCOUT_DEFAULT_GUTTER = 3.4; // default_gutter = keys_x = ENCLOSURE_WALL + key_gutter
OUTER_GUTTER = 5;

module higher_lower(
    width = 25.4 * 3,
    length = 25.4 * 3,
    height = 25.4 * 1,

    show_enclosure_bottom = true,
    show_battery_holder = true,
    show_batteries = true,
    show_pcb = true,
    show_accoutrements = true,
    show_rocker = true,
    show_enclosure_top = true,

    button_exposure = 2,

    outer_gutter = OUTER_GUTTER,
    default_gutter = SCOUT_DEFAULT_GUTTER,
    button_gutter = SCOUT_DEFAULT_GUTTER / -2,
    label_gutter = 1,

    accessory_fillet = 1,
    control_exposure = .6,

    speaker_bottom_clearance = 1,
    pcb_clearance = [5, 1, 5], // NOTE: should include/obviate tolerance

    pcb_screw_hole_positions = [
    ],
    pcb_post_hole_positions = [
    ],

    // Screw can be 3/4" to 1"
    screw_clearance = 1/4 * 25.4 + 2,
    screw_clearance_usage = .5,
    screw_length = 3/4 * 25.4,

    battery_count = 3,

    tolerance = 0,

    enclosure_outer_color = "#FF69B4",
    enclosure_cavity_color = "#CC5490",

    control_outer_color = "#FFFFFF",
    control_cavity_color = "#EEEEEE",

    quick_preview = true
) {
    e = .00319;

    // NOTE: 2:1 ratio here assumes portrait/square enclosure dimensions.
    // It will look odd if enclosure width > length.
    speaker_grill_width = (width - outer_gutter * 2 - default_gutter) / 3 * 2;
    speaker_grill_length = min(
        speaker_grill_width,
        length - outer_gutter * 2 - default_gutter
            - ENCLOSURE_TOP_ENGRAVING_MINIMUM_LENGTH
    );
    button_size = (speaker_grill_length - button_gutter) / 2;

    available_width = speaker_grill_width + button_size + default_gutter;
    available_length = length - outer_gutter * 2;

    battery_holder_dimensions = get_battery_holder_dimensions(
        battery_count,
        tolerance
    );
    battery_holder_position = [
        (width - battery_holder_dimensions.x) / 2,
        ENCLOSURE_WALL + tolerance * 2,
        ENCLOSURE_FLOOR_CEILING
    ];


    module _assert_minimimum_dimensions() {
        min_speaker_grill_width =
            get_speaker_fixture_diameter(tolerance, ENCLOSURE_INNER_WALL)
            - ENCLOSURE_INNER_WALL * 2 - (outer_gutter - ENCLOSURE_WALL) * 2;

        min_width = min_speaker_grill_width + button_size + default_gutter
            + outer_gutter * 2;
        min_length = ENCLOSURE_WALL * 2 + battery_holder_dimensions.y
            + PCB_MINIMUM_LENGTH + pcb_clearance.y * 2;
        min_height = ENCLOSURE_FLOOR_CEILING * 2 + battery_holder_dimensions.z
            + SPEAKER_HEIGHT + speaker_bottom_clearance;

        warn_if(speaker_grill_width < min_speaker_grill_width, str(
            "speaker_grill_width of ", speaker_grill_width,
            " < min_speaker_grill_width of ", min_speaker_grill_width
        ));

        warn_if(width < min_width, str(
            "width of ", width,
            " < min_width of ", min_width
        ));
        warn_if(length < min_length, str(
            "length of ", length,
            " < min_length of ", min_length
        ));
        warn_if(height < min_height, str(
            "height of ", height,
            " < min_height of ", min_height
        ));
    }
    _assert_minimimum_dimensions();

    speaker_grill_dimensions = [
        speaker_grill_width,
        speaker_grill_length
    ];
    speaker_grill_position = [
        outer_gutter,
        length - speaker_grill_length - outer_gutter
    ];
    speaker_position = [
        speaker_grill_position.x + speaker_grill_dimensions.x / 2,
        speaker_grill_position.y + speaker_grill_dimensions.y / 2,
        height - ENCLOSURE_FLOOR_CEILING - SPEAKER_HEIGHT
    ];

    pcb_position = [
        ENCLOSURE_WALL + pcb_clearance.x,
        battery_holder_position.y + battery_holder_dimensions.y + pcb_clearance.y,
        ENCLOSURE_FLOOR_CEILING + pcb_clearance.z
    ];

    pcb_width = width - (ENCLOSURE_WALL + pcb_clearance.x) * 2;
    pcb_length = min(
        (speaker_position.y - pcb_position.y) * 2,
        length - ENCLOSURE_WALL - pcb_clearance.y - pcb_position.y
    );
    pcb_height = PCB_HEIGHT;

    button_rocker_position = [
        speaker_grill_position.x + speaker_grill_dimensions.x + default_gutter,
        speaker_grill_position.y,
        height - ENCLOSURE_FLOOR_CEILING - ROCKER_BRIM_HEIGHT - e
    ];
    button_height = ROCKER_BRIM_HEIGHT + ENCLOSURE_FLOOR_CEILING + button_exposure;

    enclosure_bottom_height = pcb_position.z + ENCLOSURE_LIP_HEIGHT / 2;
    enclosure_top_height = height - enclosure_bottom_height;

    nut_z = height - ENCLOSURE_FLOOR_CEILING - NUT_HEIGHT - screw_clearance;
    screw_head_clearance = nut_z - screw_length
        + NUT_HEIGHT - SCREW_HEAD_HEIGHT
        + screw_clearance * screw_clearance_usage;

    echo("Enclosure", width / 25.4, length / 25.4, height / 25.4);
    echo("PCB", pcb_width / 25.4, pcb_length / 25.4);
    echo("Button", button_size / 25.4, button_size / 25.4);

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

                    outer_color = enclosure_outer_color,
                    cavity_color = enclosure_cavity_color,

                    quick_preview = false
                );
            }
        }
    }

    if (show_rocker) {
        translate(button_rocker_position) {
            button_rocker(
                button_size, button_size, button_height,
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
                available_length - speaker_grill_dimensions.y - default_gutter
            ],
            top_engraving_position = [outer_gutter, outer_gutter],

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
        translate([pcb_position.x, pcb_position.y, pcb_position.z - e * 2]) {
            pcb(
                show_board = show_pcb,
                show_silkscreen = false,
                show_switches = show_accoutrements,

                rocker_center_x = button_rocker_position.x - pcb_position.x
                    + button_size / 2,
                rocker_center_y = button_rocker_position.y - pcb_position.y
                    + button_size + button_gutter / 2,
                button_size = button_size,

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
SHOW_BATTERY_HOLDER = true;
SHOW_BATTERIES = true;
SHOW_PCB = true;
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
    show_accoutrements = SHOW_ACCOUTREMENTS,
    show_rocker = SHOW_ROCKER,
    show_enclosure_top = SHOW_ENCLOSURE_TOP,

    tolerance = DEFAULT_TOLERANCE,

    quick_preview = $preview
);
// translate([60, -1, -1]) cube([100, 100, 100]);
}