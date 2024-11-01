#ifdef __AVR_ATtiny85__
#define OUTPUT_PIN 4
#define LED_PIN 1
#define UP_PIN 0
#define DOWN_PIN 3
#define CTRL_PIN A1
#else
#define OUTPUT_PIN 5
#define LED_PIN 9
#define UP_PIN A0
#define DOWN_PIN A3
#define CTRL_PIN 8
#endif

#define SEED_PIN UP_PIN

#define THEME_NOTE_LENGTH 180

// NOTES: max human-audible frequency is ~20k and max for int16_t is ~32k,
// but this max is the max that doesn't hurt my ears.
#define MIN_TONE 60
#define MAX_TONE 1000

#define GUESSES_PER_ROUND 4
#define ROUNDS_PER_LEVEL 5
#define LEVELS_PER_GAME 10

#define TONES_PER_ROUND (GUESSES_PER_ROUND + 1)

// NOTE: Yes, we start at 1 instead of 0,
// because we want an interval between tones.
// Ya can't diff off nuthin, charlie!
#define STARTING_INDEX 1

#define LAST_TONE_DURATION THEME_NOTE_LENGTH * 4
#define CURRENT_TONE_DURATION (LAST_TONE_DURATION / 2)
#define MIN_TONE_OR_INTERVAL_PAUSE_DURATION 8

#define RESET_PAUSE 1000
#define POST_BUTTON_PRESS_PAUSE 125
#define NEW_ROUND_PAUSE 500
#define PRE_INTERVAL_PAUSE THEME_NOTE_LENGTH / 2
#define MID_INTERVAL_PAUSE PRE_INTERVAL_PAUSE / 2

#define INTERVAL_CHUNK ((MAX_TONE - MIN_TONE) / TONES_PER_ROUND)
#define MIN_INTERVAL 5

#define INTERVAL_DIMINISH .65
#define DURATION_DIMINISH .75

#define MIN_DIFFICULTY 0
#define MAX_DIFFICULTY 4

// NOTE: For emulation, in lieu of analog input
#define DEFAULT_DIFFICULTY 1