#ifdef __AVR_ATtiny85__
const int outputPin = 4;
const int ledPin = 1;
const int upPin = 0;
const int downPin = 3;
const int ctrlPin = A1;
const int skipPin;
#else
const int outputPin = 5;
const int ledPin = 9;
const int upPin = A0;
const int downPin = A3;
const int ctrlPin = 8;
const int skipPin = A1;
#endif

const int themeNoteLength = 180;

// NOTES: max human-audible frequency is ~20k and max for int16_t is ~32k,
// but this max is the max that doesn't hurt my ears.
const int minTone = 60;
const int maxTone = 1000;

const int guessesPerRound = 4;
const int roundsPerGame = 10;

const int tonesPerRound = (guessesPerRound + 1);

// NOTE: Yes, we start at 1 instead of 0,
// because we want an interval between tones.
// Ya can't diff off nuthin, charlie!
const int startingIndex = 1;

const int lastToneDuration = themeNoteLength * 4;
const int currentToneDuration = (lastToneDuration / 2);
const int minToneOrIntervalPauseDuration = 8;

const int bootPause = 250;
const int resetPause = 1000;
const int postButtonPressPause = 250;
const int newRoundPause = 500;
const int preIntervalPause = themeNoteLength / 2;
const int midIntervalPause = preIntervalPause / 2;

const int intervalChunk = ((maxTone - minTone) / tonesPerRound);
const int minInterval = 5;

const float intervalDiminish = .65;
const float durationDiminish = .9;
const float themeMotifSpeedup = 1.125;

const int minStartingDifficulty = 0;
const int maxStartingDifficulty = 4;

// NOTE: For emulation, in lieu of analog input
const int defaultDifficulty = 0;

enum Button { NONE, UP, DOWN };

bool isPlayingSound = false;
