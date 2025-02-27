#include "common.h"
#include "interface.h"

#include "noise.h"

int16_t tones[tonesPerRound];
uint8_t index = startingIndex;
uint8_t roundsWon = 0;

uint8_t difficulty = defaultDifficulty;
uint8_t consecutiveGamesWon = 0;

inline uint8_t getProgress() { return roundsWon * difficulty; }

inline bool isBeyondMinMax(int16_t nextTone) {
  return nextTone < minTone || nextTone > maxTone;
}

int16_t getNextToneInFirstRound(uint8_t previousIndex) {
  return firstRoundTones[previousIndex + 1];
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
        roundsWon == 0 ? getNextToneInFirstRound(i - 1) : getNextTone(i - 1);
  }
}

void playNextInterval() {
  printIntervalToSerial(index, tones);
  playInterval(tones[index - 1], tones[index], getProgress());
  updateDisplay();
}

void handleGameOver() {
  playGameOverSound(roundsWon);
  _delay(resetPause);

  reset();
}

void handleGameWon() {
  consecutiveGamesWon += 1;
  difficulty += 1;

  playWinnerSong(difficulty);
  _delay(resetPause);

  printGameToSerial(consecutiveGamesWon, difficulty);
  resetWithoutIntro();
}

void setRoundsWon(uint8_t r) {
  roundsWon = r;

  if (roundsWon >= roundsPerGame) {
    handleGameWon();
    return;
  }

  if (consecutiveGamesWon == 0 && roundsWon == 1) {
    initRandomSeed();
  }

  randomize();
  index = startingIndex;

  printRoundToSerial(r, tones);

  playNextInterval();
}

void resetWithoutIntro() { setRoundsWon(0); }

void reset() {
  consecutiveGamesWon = 0;
  difficulty = getStartingDifficulty();

  printGameToSerial(consecutiveGamesWon, difficulty);

  playIntro(difficulty);
  _delay(newRoundPause);

  resetWithoutIntro();
}

void setup() {
  setupInterface();
  setupSerial();

  _delay(bootPause);

  reset();
}

void handleGuess(Intent intent, bool guessSuccess,
                 bool roundSuccess = index == tonesPerRound - 1) {
  _delay(postButtonPressPause, intent);

  if (guessSuccess) {
    if (roundSuccess) {
      playSuccessSound(roundsWon + 1);
      _delay(newRoundPause);
      setRoundsWon(roundsWon + 1);

      return;
    }

    index = index + 1;

    playNextInterval();

    return;
  }

  handleGameOver();
}

void loop() {
  if (justPressed(Intent::DOWN)) {
    handleGuess(Intent::DOWN, tones[index] < tones[index - 1]);
  }

  if (justPressed(Intent::UP)) {
    handleGuess(Intent::UP, tones[index] > tones[index - 1]);
  }

  if (justPressed(Intent::SKIP)) {
    handleGuess(Intent::NONE, true, true);
  }
}
