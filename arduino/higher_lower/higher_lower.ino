#include <Arduboy2.h>
#include <ArduboyTones.h>

#define MIN_TONE 20
#define MAX_TONE 10000

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

int16_t getInterval(uint16_t fromTone, uint8_t nextIndex)
{
  int8_t direction = random(0, 1) ? -1 : 1;

  uint16_t desiredChange = 1000; // TODO: decrease over time

  if (
      direction == -1 &&
      desiredChange <= fromTone - MIN_TONE)
  {
    return fromTone - desiredChange;
  }
  else if (
      direction == 1 &&
      desiredChange <= MAX_TONE - fromTone)
  {
    return fromTone + desiredChange;
  }

  // TODO: fix infinite loop
  return getInterval(fromTone, nextIndex);
}

void randomize()
{
  // TODO: later, only seed on first play
  arduboy.initRandomSeed();

  tones[0] = random(MIN_TONE, MAX_TONE + 1);

  for (uint8_t i = 1; i < TONES_COUNT; i++)
  {
    tones[i] = tones[i - 1] + getInterval(tones[i - 1], i - 1);
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
