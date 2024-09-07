#include <Arduboy2.h>
#include <ArduboyTones.h>

// NOTES: max human-audible frequency is ~20k and max for int16_t is ~32k,
// but this max is the max that doesn't hurt my ears.
#define MIN_TONE 60
#define MAX_TONE 1000

#define GUESSES_PER_ROUND 5
#define TONES_COUNT (GUESSES_PER_ROUND + 1)

#define LAST_TONE_DURATION 400
#define CURRENT_TONE_DURATION (LAST_TONE_DURATION / 2)

#define INTERVAL_CHUNK ((MAX_TONE - MIN_TONE) / TONES_COUNT)
#define MIN_INTERVAL 10

#define DIMINISH .9

#define RESET_PAUSE 500

// NOTE: Yes, we start at 1 instead of 0,
// because we want an interval between tones.
// Ya can't diff off nuthin, charlie!
#define STARTING_INDEX 1

int16_t tones[TONES_COUNT];
uint8_t index = STARTING_INDEX;
int8_t currentRound = 0;

Arduboy2 arduboy;
ArduboyTones arduboyTones(arduboy.audio.enabled);

inline int8_t getDirection() { return random(0, 2) ? -1 : 1; }

const uint16_t SUCCESS_TONES[] PROGMEM = {
    NOTE_G3, 17, NOTE_C4, 34, NOTE_E4, 34, NOTE_C5, 68, TONES_END};
const uint16_t SUCCESS_TONES_LENGTH = 153;

const uint16_t LOSE_TONES[] PROGMEM = {
    NOTE_G2, 136, NOTE_E2,  136, NOTE_B2, 136, NOTE_C2, 136, NOTE_G2, 136,
    NOTE_E2, 136, NOTE_B2,  136, NOTE_C2, 136, NOTE_G2, 136, NOTE_E2, 136,
    NOTE_B2, 136, NOTE_C2,  136, NOTE_G2, 136, NOTE_E2, 136, NOTE_B2, 136,
    NOTE_C2, 136, TONES_END};
const uint16_t LOSE_TONES_LENGTH = 136 * 8;

int16_t getNextTone(int16_t fromTone, uint8_t nextIndex) {
  int16_t nextTone = constrain(
      fromTone + getDirection() *
                     (random(MIN_INTERVAL,
                             INTERVAL_CHUNK * pow(DIMINISH, currentRound)) *
                      (GUESSES_PER_ROUND - nextIndex)),
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
  tones[0] = random(MIN_TONE, MAX_TONE + 1);

  Serial.println();
  for (uint8_t i = 1; i < TONES_COUNT; i++) {
    tones[i] = getNextTone(tones[i - 1], i - 1);
    printInterval(i);
  }
  Serial.println();
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
  arduboyTones.tone(tones[i - 1],
                    LAST_TONE_DURATION * pow(DIMINISH, currentRound), tones[i],
                    CURRENT_TONE_DURATION * pow(DIMINISH, currentRound));
}

void setRound(int8_t r) {
  currentRound = r;

  // NOTE: Yeah, we're seeding at the start of the second round.
  // Otherwise we'd need to delay the first til user input.
  if (currentRound == 1) {
    arduboy.initRandomSeed();
  }

  randomize();
  index = STARTING_INDEX;

  playInterval(index);
  printInterval(index);
}

void setup() {
  arduboy.beginDoFirst();
  arduboy.waitNoButtons();
  arduboy.setFrameRate(15);

  Serial.begin(9600);

  playSuccessSound();
  setRound(0);
}

void playSuccessSound() {
  for (uint8_t i = 0; i <= currentRound; i++) {
    arduboyTones.tones(SUCCESS_TONES);
    delay(SUCCESS_TONES_LENGTH);
  }

  delay(RESET_PAUSE);
}

void playGameOverSound() {
  arduboyTones.tones(LOSE_TONES);
  delay(LOSE_TONES_LENGTH);

  delay(RESET_PAUSE);
}

void increment() { index = constrain(index + 1, 0, TONES_COUNT - 1); }

void handleGuess(bool success) {
  if (success) {
    if (index == TONES_COUNT - 1) {
      playSuccessSound();
      setRound(currentRound + 1);

      return;
    }

    increment();

    playInterval(index);
    printInterval(index);

    return;
  }

  playGameOverSound();
  setRound(0);
}

void loop() {
  arduboy.pollButtons();

  if (arduboy.justPressed(B_BUTTON)) {
    index = TONES_COUNT - 1;
    handleGuess(true);
  }

  if (arduboy.justPressed(DOWN_BUTTON)) {
    handleGuess(tones[index] < tones[index - 1]);
  }

  if (arduboy.justPressed(UP_BUTTON)) {
    handleGuess(tones[index] > tones[index - 1]);
  }
}
