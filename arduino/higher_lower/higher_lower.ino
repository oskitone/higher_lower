#include "common.h"

#include "noise.h"

int16_t tones[TONES_PER_ROUND];
uint8_t index = STARTING_INDEX;

uint8_t roundsWon = 0;

// TODO: guess countdown timer

#include "interface.h"

inline uint8_t getLevelsWon() { return roundsWon / ROUNDS_PER_LEVEL; }

inline int8_t getDirection() { return random(0, 2) ? -1 : 1; }

int16_t getNextToneInScale(uint8_t previousIndex) {
  int16_t nextTone = scale[random(0, SCALE_TONES_COUNT)];

  if (nextTone == tones[previousIndex]) {
    return getNextToneInScale(previousIndex);
  }

  return nextTone;
}

inline bool isBeyondMinMax(int16_t nextTone) {
  return nextTone < MIN_TONE || nextTone > MAX_TONE;
}

int16_t getNextTone(uint8_t previousIndex) {
  int8_t direction = getDirection();
  int16_t nextTone = tones[previousIndex];

  for (uint8_t i = 0; i < (GUESSES_PER_ROUND - previousIndex); i++) {
    nextTone +=
        direction * random(MIN_INTERVAL,
                           INTERVAL_CHUNK * pow(INTERVAL_DIMINISH, roundsWon));
  }

  if (nextTone == tones[previousIndex]) {
    return getNextTone(previousIndex);
  }

  if (isBeyondMinMax(nextTone)) {
    return getNextTone(previousIndex);
  }

  return nextTone;
}

void randomize() {
  tones[0] = roundsWon == 0 || isBeyondMinMax(tones[TONES_PER_ROUND - 1])
                 ? NOTE_C5
                 : tones[TONES_PER_ROUND - 1];

  for (uint8_t i = 1; i < TONES_PER_ROUND; i++) {
    tones[i] = roundsWon == 0 ? getNextToneInScale(i - 1) : getNextTone(i - 1);
  }
}

void setRoundsWon(uint8_t r) {
  roundsWon = r;

  if (getLevelsWon() == LEVELS_PER_GAME) {
    // TODO: something special!
    reset();
    return;
  }

  // TODO: rethink when to do this
  if (roundsWon == 1) {
    initRandomSeed();
  }

  randomize();
  index = STARTING_INDEX;

  printLevelAndRoundToSerial(getLevelsWon(), r);
  printBlankLineToSerial();
  printAllTones();
  printBlankLineToSerial();

  printIntervalToSerial(index);
  playInterval(tones[index - 1], tones[index], roundsWon);
}

void reset() {
  playIntro();
  delay(NEW_ROUND_PAUSE);

  printBlankLineToSerial();
  setRoundsWon(0);
}

void setup() {
  setupInterface();
  setupSerial();
  reset();
}

void increment() { index = constrain(index + 1, 0, TONES_PER_ROUND - 1); }

void handleGuess(bool success) {
  delay(POST_BUTTON_PRESS_PAUSE);

  if (success) {
    if (index == TONES_PER_ROUND - 1) {
      playSuccessSound(roundsWon + 1);
      delay(NEW_ROUND_PAUSE);
      printBlankLineToSerial();
      setRoundsWon(roundsWon + 1);

      return;
    }

    increment();

    printIntervalToSerial(index);
    playInterval(tones[index - 1], tones[index], roundsWon);

    return;
  }

  playGameOverSound(roundsWon);
  delay(RESET_PAUSE);

  reset();
}

void loop() {
  if (justPressed(SKIP_BUTTON)) {
    index = TONES_PER_ROUND - 1;
    handleGuess(true);
  }

  if (justPressed(DOWN_BUTTON)) {
    handleGuess(tones[index] < tones[index - 1]);
  }

  if (justPressed(UP_BUTTON)) {
    handleGuess(tones[index] > tones[index - 1]);
  }
}
