#include "common.h"

#ifdef __AVR_ATtiny85__
#include "interface_attiny85.h"
#else
#include "interface_arduboy.h"
#endif

#include "noise.h"

int16_t tones[TONES_COUNT];
uint8_t index = STARTING_INDEX;
int8_t currentRound = 0;

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

void setRound(int8_t r) {
  currentRound = r;

  // NOTE: Yeah, we're seeding at the start of the second round.
  // Otherwise we'd need to delay the first til user input.
  if (currentRound == 1) {
    initRandomSeed();
  }

  randomize();
  index = STARTING_INDEX;

  printInterval(index);
  playInterval(tones[index - 1], tones[index], currentRound);
}

void setup() {
  setupInterface();

  Serial.begin(9600);

  playSuccessSound(currentRound);
  delay(RESET_PAUSE);
  setRound(0);
}

void increment() { index = constrain(index + 1, 0, TONES_COUNT - 1); }

void handleGuess(bool success) {
  if (success) {
    if (index == TONES_COUNT - 1) {
      playSuccessSound(currentRound);
      delay(RESET_PAUSE);
      setRound(currentRound + 1);

      return;
    }

    increment();

    printInterval(index);
    playInterval(tones[index - 1], tones[index], currentRound);

    return;
  }

  playGameOverSound();
  delay(RESET_PAUSE);
  setRound(0);
}

void loop() {
  pollButtons();

  if (justPressed(B_BUTTON)) {
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
