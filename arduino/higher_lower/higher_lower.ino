#include "common.h"

#include "noise.h"

int16_t tones[TONES_COUNT];
uint8_t index = STARTING_INDEX;
int8_t currentRound = 0;
// TODO: guess countdown timer

#include "interface.h"

inline int8_t getDirection() { return random(0, 2) ? -1 : 1; }

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
  // TODO: fix tones[TONES_COUNT - 1] == 0 after failure
  tones[0] = currentRound == 0 ? NOTE_C5 : tones[TONES_COUNT - 1];

  for (uint8_t i = 1; i < TONES_COUNT; i++) {
    tones[i] = currentRound == 0 ? scale[random(0, 8 + 1)]
                                 : getNextTone(tones[i - 1], i - 1);
    printIntervalToSerial(i);
  }

  printBlankLineToSerial();
}

void setRound(int8_t r) {
  currentRound = r;

  // NOTE: Yeah, we're seeding at the start of the second round.
  // Otherwise we'd need to delay the first til user input.
  if (currentRound == 1) {
    initRandomSeed();
  }

  randomize();
  index = STARTING_INDEX;

  printIntervalToSerial(index);
  playInterval(tones[index - 1], tones[index], currentRound);
}

void setup() {
  setupInterface();

  setupSerial();

  playIntro();
  delay(RESET_PAUSE);
  setRound(0);
}

void increment() { index = constrain(index + 1, 0, TONES_COUNT - 1); }

void handleGuess(bool success) {
  if (success) {
    if (index == TONES_COUNT - 1) {
      playSuccessSound(currentRound);
      delay(RESET_PAUSE);
      printBlankLineToSerial();
      setRound(currentRound + 1);

      return;
    }

    increment();

    printIntervalToSerial(index);
    playInterval(tones[index - 1], tones[index], currentRound);

    return;
  }

  playGameOverSound();
  delay(RESET_PAUSE);
  printBlankLineToSerial();
  setRound(0);
}

void loop() {
  if (justPressed(SKIP_BUTTON)) {
    index = TONES_COUNT - 1;
    handleGuess(true);
  }

  if (justPressed(DOWN_BUTTON)) {
    handleGuess(tones[index] < tones[index - 1]);
  }

  if (justPressed(UP_BUTTON)) {
    handleGuess(tones[index] > tones[index - 1]);
  }
}
