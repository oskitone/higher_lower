#include <Arduboy2.h>
#include <ArduboyTones.h>

#define MIN_TONE 20
#define MAX_TONE 10000

#define INTERVAL_CHUNK 100
#define MIN_INTERVAL (INTERVAL_CHUNK / 2)

#define LAST_TONE_DURATION 400
#define CURRENT_TONE_DURATION (LAST_TONE_DURATION / 2)

// TODO: increase
#define TONES_COUNT 10

// NOTE: Yes, we start at 1 instead of 0,
// because we want an interval between tones.
// Ya can't diff off nuthin, charlie!
#define STARTING_INDEX 1

uint16_t tones[TONES_COUNT];
uint8_t index = STARTING_INDEX;

Arduboy2 arduboy;
ArduboyTones arduboyTones(arduboy.audio.enabled);

inline int8_t getDirection()
{
  return random(0, 2) ? -1 : 1;
}

int16_t getNextTone(uint16_t fromTone, uint8_t nextIndex)
{
  // TODO: tidy / understand why clang formatter thinks this is okay
  uint16_t nextTone = fromTone + getDirection() * (random(MIN_INTERVAL, INTERVAL_CHUNK) * (TONES_COUNT - STARTING_INDEX - nextIndex));

  if (nextTone >= MIN_TONE && nextTone <= MAX_TONE)
  {
    return nextTone;
  }

  return getNextTone(fromTone, nextIndex);
}

void randomize()
{
  // TODO: later, only seed on first play
  arduboy.initRandomSeed();

  tones[0] = random(MIN_TONE, MAX_TONE + 1);

  for (uint8_t i = 1; i < TONES_COUNT; i++)
  {
    tones[i] = getNextTone(tones[i - 1], i - 1);
  }
}

void playIntervalTones()
{
  Serial.print(index);
  Serial.print(F(": "));
  Serial.print(tones[index - 1]);
  Serial.print(F(" -> "));
  Serial.print(tones[index]);
  Serial.println();

  arduboyTones.tone(
      tones[index - 1], LAST_TONE_DURATION,
      tones[index], CURRENT_TONE_DURATION);
}

void reset()
{
  index = STARTING_INDEX;
  randomize();
  playIntervalTones();
}

void setup()
{
  arduboy.beginDoFirst();
  arduboy.waitNoButtons();

  arduboy.setFrameRate(15);

  reset();

  Serial.begin(9600);
}

void increment()
{
  index = constrain(
      index + 1,
      0, TONES_COUNT - 1);

  playIntervalTones();
}

void loop()
{
  arduboy.pollButtons();

  if (arduboy.justPressed(B_BUTTON))
  {
    increment();
  }

  if (arduboy.justPressed(A_BUTTON))
  {
    reset();
  }
}
