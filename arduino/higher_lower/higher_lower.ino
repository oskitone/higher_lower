#include "common.h"
#include "interface.h"
#include "noise.h"

int16_t tones[tonesPerRound];
uint8_t difficulty = defaultDifficulty;
uint8_t index = startingIndex;
uint8_t roundsWon = 0;

inline uint8_t getProgress() { return roundsWon * difficulty; }

inline bool isBeyondMinMax(int16_t nextTone) {
  return nextTone < minTone || nextTone > maxTone;
}

int16_t getNextToneInScale(uint8_t previousIndex) {
  int16_t nextTone = scale[random(0, scaleTonesCount)];

  if (nextTone == tones[previousIndex]) {
    return getNextToneInScale(previousIndex);
  }

  return nextTone;
}

int16_t getNextTone(uint8_t previousIndex) {
  int8_t direction = random(0, 2) ? -1 : 1;
  int16_t nextTone = tones[previousIndex];

  for (uint8_t i = 0; i < (guessesPerRound - previousIndex); i++) {
    nextTone += direction *
                random(minInterval,
                       intervalChunk * pow(intervalDiminish, getProgress()));
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
  tones[0] = roundsWon == 0 || isBeyondMinMax(tones[tonesPerRound - 1])
                 ? NOTE_C5
                 : tones[tonesPerRound - 1];

  for (uint8_t i = 1; i < tonesPerRound; i++) {
    tones[i] =
        getProgress() == 0 ? getNextToneInScale(i - 1) : getNextTone(i - 1);
  }
}

void setRoundsWon(uint8_t r) {
  roundsWon = r;

  if (roundsWon >= roundsPerGame) {
    playWinnerSong();
    delay(resetPause);
    reset();
    return;
  }

  randomize();
  index = startingIndex;

  printRoundToSerial(r);
  printBlankLineToSerial();
  printAllTones(tones);
  printBlankLineToSerial();

  printIntervalToSerial(index, tones);
  playInterval(tones[index - 1], tones[index], getProgress());
}

void reset() {
  difficulty = getDifficulty();

  playIntro(difficulty);
  delay(newRoundPause);

  printBlankLineToSerial();
  setRoundsWon(0);
}

void setup() {
  // NOTE: seed before setup, before input pins are pulled
  initRandomSeed();
  setupInterface();

  setupSerial();
  reset();
}

void handleGuess(bool success) {
  delay(postButtonPressPause);

  if (success) {
    if (index == tonesPerRound - 1) {
      playSuccessSound(roundsWon + 1);
      delay(newRoundPause);
      printBlankLineToSerial();
      setRoundsWon(roundsWon + 1);

      return;
    }

    index = index + 1;

    printIntervalToSerial(index, tones);
    playInterval(tones[index - 1], tones[index], getProgress());

    return;
  }

  playGameOverSound(roundsWon);
  delay(resetPause);

  reset();
}

void loop() {
  if (justPressed(downPin)) {
    handleGuess(tones[index] < tones[index - 1]);
  }

  if (justPressed(upPin)) {
    handleGuess(tones[index] > tones[index - 1]);
  }
}
