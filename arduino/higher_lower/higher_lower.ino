#include "consts.h"
#include "interface.h"
#include "noise.h"

#include "game.h"

int16_t tones[tonesPerRound];
uint8_t index = startingIndex;
uint8_t roundsWon = 0;

uint8_t difficulty = defaultDifficulty;
uint8_t consecutiveGamesWon = 0;

void reset() {
  consecutiveGamesWon = 0;
  difficulty = getStartingDifficulty();

  printGameToSerial(consecutiveGamesWon, difficulty);

  playIntro(difficulty);
  _delay(newRoundPause);

  resetWithoutIntro(index, roundsWon, tones, difficulty, consecutiveGamesWon);
}

void setup() {
  setupInterface();
  setupSerial();

  _delay(bootPause);

  reset();
}

void loop() {
  if (justPressed(Intent::DOWN)) {
    handleGuess(index, roundsWon, tones, difficulty, consecutiveGamesWon,
                Intent::DOWN, tones[index] < tones[index - 1],
                index == tonesPerRound - 1);
  }

  if (justPressed(Intent::UP)) {
    handleGuess(index, roundsWon, tones, difficulty, consecutiveGamesWon,
                Intent::UP, tones[index] > tones[index - 1],
                index == tonesPerRound - 1);
  }

  if (justPressed(Intent::SKIP)) {
    handleGuess(index, roundsWon, tones, difficulty, consecutiveGamesWon,
                Intent::NONE, true, true);
  }
}
