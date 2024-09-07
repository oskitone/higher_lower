// NOTES: max human-audible frequency is ~20k and max for int16_t is ~32k,
// but this max is the max that doesn't hurt my ears.
#define MIN_TONE 60
#define MAX_TONE 1000

#define GUESSES_PER_ROUND 5
#define TONES_COUNT (GUESSES_PER_ROUND + 1)

#define RESET_PAUSE 500

// NOTE: Yes, we start at 1 instead of 0,
// because we want an interval between tones.
// Ya can't diff off nuthin, charlie!
#define STARTING_INDEX 1

#define LAST_TONE_DURATION 400
#define CURRENT_TONE_DURATION (LAST_TONE_DURATION / 2)

#define INTERVAL_CHUNK ((MAX_TONE - MIN_TONE) / TONES_COUNT)
#define MIN_INTERVAL 10

#define DIMINISH .9