#include <Arduboy2.h>
#include <ArduboyTones.h>

// NOTES: max human-audible frequency is ~20k and max for int16_t is ~32k,
// but this value is the max that doesn't hurt my ears.
#define MIN_TONE 20
#define MAX_TONE 1000

#define LAST_TONE_DURATION 400
#define CURRENT_TONE_DURATION (LAST_TONE_DURATION / 2)

// TODO: increase
#define TONES_COUNT 10

#define INTERVAL_CHUNK ((MAX_TONE - MIN_TONE) / TONES_COUNT)
#define MIN_INTERVAL (INTERVAL_CHUNK / 2)

// NOTE: Yes, we start at 1 instead of 0,
// because we want an interval between tones.
// Ya can't diff off nuthin, charlie!
#define STARTING_INDEX 1

int16_t tones[TONES_COUNT];
uint8_t index = STARTING_INDEX;

Arduboy2 arduboy;
ArduboyTones arduboyTones(arduboy.audio.enabled);

inline int8_t getDirection() { return random(0, 2) ? -1 : 1; }

int16_t getNextTone(int16_t fromTone, uint8_t nextIndex) {
  int16_t nextTone = constrain(
      fromTone + getDirection() * (random(MIN_INTERVAL, INTERVAL_CHUNK) *
                                   (TONES_COUNT - STARTING_INDEX - nextIndex)),
      MIN_TONE, MAX_TONE);

  if (nextTone == fromTone) {
    return getNextTone(fromTone, nextIndex);
  }

  if (nextTone < MIN_TONE || nextTone > MAX_TONE) {
    return getNextTone(fromTone, nextIndex);
  }

  return nextTone;
}

void randomize() {
  // TODO: later, only seed on first play
  arduboy.initRandomSeed();

  tones[0] = random(MIN_TONE, MAX_TONE + 1);

  for (uint8_t i = 1; i < TONES_COUNT; i++) {
    tones[i] = getNextTone(tones[i - 1], i - 1);
    printInterval(i);
  }
}

void printInterval(uint8_t i) {
  Serial.print(i);
  Serial.print(F(": "));
  Serial.print(tones[i - 1]);
  Serial.print(F(" -> "));
  Serial.print(tones[i]);
  Serial.print(F(" ("));
  Serial.print(tones[i] - tones[i - 1]);
  Serial.print(F(")"));
  Serial.println();
}

void playInterval(uint8_t i) {
  arduboyTones.tone(tones[i - 1], LAST_TONE_DURATION, tones[i],
                    CURRENT_TONE_DURATION);
}

void reset() {
  Serial.println();
  randomize();
  Serial.println();

  index = STARTING_INDEX;

  playInterval(index);
  printInterval(index);
}

void setup() {
  arduboy.beginDoFirst();
  arduboy.waitNoButtons();

  arduboy.setFrameRate(15);

  reset();

  Serial.begin(9600);
}

void increment() { index = constrain(index + 1, 0, TONES_COUNT - 1); }

void loop() {
  arduboy.pollButtons();

  if (arduboy.justPressed(B_BUTTON)) {
    increment();

    playInterval(index);
    printInterval(index);
  }

  if (arduboy.justPressed(A_BUTTON)) {
    reset();
  }
}
