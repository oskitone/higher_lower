#include "common.h"

#include "noise.h"

int16_t tones[TONES_COUNT];
uint8_t index = STARTING_INDEX;
uint8_t currentRound; // TODO: rename to level? score?
// TODO: guess countdown timer

#include "interface.h"

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
    nextTone += direction *
                random(MIN_INTERVAL,
                       INTERVAL_CHUNK * pow(INTERVAL_DIMINISH, currentRound));
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
  tones[0] = currentRound == 0 || isBeyondMinMax(tones[TONES_COUNT - 1])
                 ? NOTE_C5
                 : tones[TONES_COUNT - 1];

  for (uint8_t i = 1; i < TONES_COUNT; i++) {
    tones[i] =
        currentRound == 0 ? getNextToneInScale(i - 1) : getNextTone(i - 1);
    printIntervalToSerial(i);
  }

  printBlankLineToSerial();
}

void setRound(uint8_t r) {
  currentRound = r;

  printRoundToSerial(r);
  printBlankLineToSerial();

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
  delay(NEW_ROUND_PAUSE);
  setRound(0);
}

void increment() { index = constrain(index + 1, 0, TONES_COUNT - 1); }

void handleGuess(bool success) {
  delay(POST_BUTTON_PRESS_PAUSE);

  if (success) {
    if (index == TONES_COUNT - 1) {
      playSuccessSound(currentRound + 1);
      delay(NEW_ROUND_PAUSE);
      printBlankLineToSerial();
      setRound(currentRound + 1);

      return;
    }

    increment();

    printIntervalToSerial(index);
    playInterval(tones[index - 1], tones[index], currentRound);

    return;
  }

  playGameOverSound(currentRound);
  delay(RESET_PAUSE);
  playIntro();
  delay(NEW_ROUND_PAUSE);

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
