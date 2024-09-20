include <../../parts_cafe/openscad/cherry_switch.scad>;
include <../../parts_cafe/openscad/headphone_jack.scad>;
include <../../parts_cafe/openscad/led.scad>;
include <../../parts_cafe/openscad/pot.scad>;
include <../../parts_cafe/openscad/switch.scad>;

PCB_WIDTH = 65.836;
PCB_LENGTH = 99.314;
PCB_HEIGHT = 1.6;

function get_xy(
    xy,

    component_offset = [0, 0],

    z = PCB_HEIGHT,

    pcb_offset = [.46, -.41 - 2.54] // NOTE: eyeballed
) = [
    xy.x + component_offset.x + pcb_offset.x,
    -xy.y + component_offset.y + pcb_offset.y,
    z
];

PCB_SPEAKER_POSITION = get_xy([8.35, -8.62762], [3.8, 0]);

PCB_SWITCH_POSITIONS = [
    get_xy([39.85, -64.346]),
    get_xy([39.85, -86.696]),
];

PCB_LED_POSITIONS = [
    get_xy([60.96, -87.884], [2.54 / -2, 0]),
    get_xy([54.356, -87.884], [2.54 / -2, 0]),
];

PCB_POT_POSITIONS = [
    get_xy([14.6, -66.461], [-2.45, 7.05]),
    get_xy([8.15, -28.211], [-2.45, 7.05]),
    get_xy([33.95, -28.211], [-2.45, 7.05]),
    get_xy([59.75, -28.211], [-2.45, 7.05]),
];

PCB_CHERRY_SWITCH_POSITION = get_xy([53.3, -13.6776], CHERRY_SWITCH_ORIGIN);

// 36MS30008-PN
SPEAKER_DIAMETER = 29.85;
SPEAKER_HEIGHT = 12.7;
SPEAKER_RIM = 2;

PCB_HEADPHONE_JACK_POSITIONS = [
    get_xy([6.78, -94.861], [HEADPHONE_JACK_WIDTH / -2, -7.5]),
    get_xy([23.26, -94.861], [HEADPHONE_JACK_WIDTH / -2, -7.5]),
];

PCB_HOLE_POSITIONS = [
    get_xy([41.148, -97.282]),
    get_xy([56.261, -5.5118]),
    get_xy([31.7802, -6.2992]),
    get_xy([26.924, -26.416]),
    get_xy([19.304, -86.36]),
];
PCB_HOLE_DIAMETER = 3.2;

module pcb(
    show_board = true,
    show_speaker = true,
    show_cherry_switch = true,
    show_silkscreen = true,
    show_leds = true,
    show_pots = true,
    show_switches = true,
    show_headphone_jacks = true,

    switch_position = 0,

    dimensions = [PCB_WIDTH, PCB_LENGTH, PCB_HEIGHT],

    cherry_switch_position = PCB_CHERRY_SWITCH_POSITION,
    headphone_jack_positions = PCB_HEADPHONE_JACK_POSITIONS,
    led_positions = PCB_LED_POSITIONS,
    pot_positions = PCB_POT_POSITIONS,
    speaker_position = PCB_SPEAKER_POSITION,
    switch_positions = PCB_SWITCH_POSITIONS,

    hole_positions = PCB_HOLE_POSITIONS,
    hole_diameter = PCB_HOLE_DIAMETER,

    echo_positions = false,

    pcb_color = "purple"
) {
    e = .0143;
    silkscreen_height = e;

    function _(position, bump = [0, 0]) = [
        position.x - bump.x,
        position.y - bump.y
    ];
    function _list(positions, bump = [0, 0]) = [
        for (position = positions) _(position, bump)
    ];

    if (echo_positions) {
        echo(
            "PCB cherry_switch_position",
            _(cherry_switch_position, CHERRY_SWITCH_ORIGIN)
        );
        echo(
            "PCB headphone_jack_positions",
            _list(headphone_jack_positions, [HEADPHONE_JACK_WIDTH / -2, -7.5])
        );
        echo(
            "PCB led_positions",
            _list(led_positions, [2.54 / -2, 0])
        );
        echo(
            "PCB pot_positions",
            _list(pot_positions, [-2.45, 7.05])
        );
        echo(
            "PCB speaker_position",
            _(speaker_position, [3.8, 0])
        );
        echo(
            "PCB switch_positions",
            _list(switch_positions)
        );
    }

    module _translate(position, z = -e) {
        translate([position.x, position.y, z + position.z]) {
            children();
        }
    }

    if (show_board) {
        difference() {
            union() {
                color(pcb_color) {
                    cube(dimensions);
                }

                if (show_silkscreen) {
                    intersection() {
                        // NOTE: eyeballed
                        // translate([-3.44, -2.54 * 3, dimensions.z - e]) {
                        //     linear_extrude(silkscreen_height + e) {
                        //         import("../kicad/wub-brd.svg");
                        //     }
                        // }

                        translate([e, e, e]) {
                            cube([
                                dimensions.x - e * 2,
                                dimensions.y - e * 2,
                                dimensions.z + silkscreen_height + e,
                            ]);
                        }
                    }
                }
            }

            color(pcb_color) {
                for (xy = hole_positions) {
                    translate([xy.x, xy.y, -e]) {
                        cylinder(
                            d = hole_diameter,
                            h = dimensions.z + silkscreen_height + e * 2,
                            $fn = 12
                        );
                    }
                }
            }
        }
    }

    if (show_speaker) {
        _translate(speaker_position) {
            % cylinder(d = SPEAKER_DIAMETER, h = 12.7 + e);
        }
    }

    if (show_switches) {
        for (position = switch_positions) {
            _translate(position) {
                % switch(switch_position);
            }
        }
    }

    if (show_leds) {
        for (position = led_positions) {
            _translate(position, LED_BASE_DIAMETER / 2) {
                rotate([-90, 0, 0]) {
                    % led();
                }
            }
        }
    }

    if (show_pots) {
        for (position = pot_positions) {
            _translate(position) {
                % pot();
            }
        }
    }

    if (show_headphone_jacks) {
        for (position = headphone_jack_positions) {
            _translate(position) {
                % headphone_jack();
            }
        }
    }

    if (show_cherry_switch) {
        _translate(cherry_switch_position) {
            % cherry_switch(
                position = switch_position
            );
        }
    }
}
