inline uint8_t getProgress(uint8_t roundsWon, uint8_t difficulty) {
  return roundsWon * difficulty;
}

inline bool isBeyondMinMax(int16_t nextTone) {
  return nextTone < minTone || nextTone > maxTone;
}

int16_t getNextToneInFirstRound(uint8_t previousIndex) {
  return firstRoundTones[previousIndex + 1];
}

int16_t getNextTone(uint8_t previousIndex, int16_t *tones, uint8_t progress) {
  int8_t direction = random(0, 2) ? -1 : 1;
  int16_t nextTone = tones[previousIndex];

  for (uint8_t i = 0; i < (guessesPerRound - previousIndex); i++) {
    nextTone +=
        direction *
        random(minInterval, intervalChunk * pow(intervalDiminish, progress));
  }

  if (nextTone == tones[previousIndex]) {
    return getNextTone(previousIndex, tones, progress);
  }

  if (isBeyondMinMax(nextTone)) {
    return getNextTone(previousIndex, tones, progress);
  }

  return nextTone;
}

void randomize(uint8_t roundsWon, int16_t *tones, uint8_t progress) {
  tones[0] = roundsWon == 0 || isBeyondMinMax(tones[tonesPerRound - 1])
                 ? NOTE_C5
                 : tones[tonesPerRound - 1];

  for (uint8_t i = 1; i < tonesPerRound; i++) {
    tones[i] = roundsWon == 0 ? getNextToneInFirstRound(i - 1)
                              : getNextTone(i - 1, tones, progress);
  }
}

void playNextInterval(uint8_t index, int16_t *tones, uint8_t progress) {
  printIntervalToSerial(index, tones);
  playInterval(tones[index - 1], tones[index], progress);
  updateDisplay();
}

void handleGameWon(uint8_t &consecutiveGamesWon, uint8_t &difficulty) {
  consecutiveGamesWon += 1;
  difficulty += 1;

  playWinnerSong(difficulty);
  _delay(resetPause);

  printGameToSerial(consecutiveGamesWon, difficulty);
}

void handleGameOver(uint8_t roundsWon) {
  playGameOverSound(roundsWon);
  _delay(resetPause);
}

void resetWithoutIntro(uint8_t &index, uint8_t &roundsWon, int16_t *tones,
                       uint8_t difficulty, uint8_t consecutiveGamesWon);

void setRoundsWon(uint8_t &index, uint8_t r, uint8_t &roundsWon, int16_t *tones,
                  uint8_t difficulty, uint8_t consecutiveGamesWon) {
  roundsWon = r;

  if (roundsWon >= roundsPerGame) {
    handleGameWon(consecutiveGamesWon, difficulty);
    resetWithoutIntro(index, roundsWon, tones, difficulty, consecutiveGamesWon);
    return;
  }

  if (consecutiveGamesWon == 0 && roundsWon == 1) {
    initRandomSeed();
  }

  randomize(roundsWon, tones, getProgress(roundsWon, difficulty));
  index = startingIndex;

  printRoundToSerial(r, tones);

  playNextInterval(index, tones, getProgress(roundsWon, difficulty));
}

void resetWithoutIntro(uint8_t &index, uint8_t &roundsWon, int16_t *tones,
                       uint8_t difficulty, uint8_t consecutiveGamesWon) {
  setRoundsWon(index, 0, roundsWon, tones, difficulty, consecutiveGamesWon);
}

void reset();

void handleGuess(uint8_t &index, uint8_t &roundsWon, int16_t *tones,
                 uint8_t difficulty, uint8_t consecutiveGamesWon, Intent intent,
                 bool guessSuccess, bool roundSuccess) {
  _delay(postButtonPressPause, intent);

  if (guessSuccess) {
    if (roundSuccess) {
      playSuccessSound(roundsWon + 1);
      _delay(newRoundPause);
      setRoundsWon(index, roundsWon + 1, roundsWon, tones, difficulty,
                   consecutiveGamesWon);

      return;
    }

    index = index + 1;

    playNextInterval(index, tones, getProgress(roundsWon, difficulty));

    return;
  }

  handleGameOver(roundsWon);
  reset();
}
