#ifdef __AVR_ATtiny85__
#define SPKR_PIN 4
#define LED_PIN 1
#define UP_BUTTON 2
#define DOWN_BUTTON 3
#define SKIP_BUTTON 0
#else
#define SPKR_PIN 5
#define LED_PIN 9
#define UP_BUTTON A0
#define DOWN_BUTTON A3
#define SKIP_BUTTON 8
#endif

#define THEME_NOTE_LENGTH 180

// NOTES: max human-audible frequency is ~20k and max for int16_t is ~32k,
// but this max is the max that doesn't hurt my ears.
#define MIN_TONE 60
#define MAX_TONE 1000

#define GUESSES_PER_ROUND 5
#define TONES_COUNT (GUESSES_PER_ROUND + 1)

#define SUCCESS_TONES_BUNCH 5
#define SUCCESS_TONES_BREAK 125

// NOTE: Yes, we start at 1 instead of 0,
// because we want an interval between tones.
// Ya can't diff off nuthin, charlie!
#define STARTING_INDEX 1

#define LAST_TONE_DURATION THEME_NOTE_LENGTH * 4
#define CURRENT_TONE_DURATION (LAST_TONE_DURATION / 2)

#define RESET_PAUSE 1000
#define NEW_ROUND_PAUSE 500
#define PRE_INTERVAL_PAUSE THEME_NOTE_LENGTH / 2
#define MID_INTERVAL_PAUSE PRE_INTERVAL_PAUSE / 2

#define INTERVAL_CHUNK ((MAX_TONE - MIN_TONE) / TONES_COUNT)
#define MIN_INTERVAL 5

#define DIMINISH .75