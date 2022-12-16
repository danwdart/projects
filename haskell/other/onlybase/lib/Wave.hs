{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module Wave where

type SampleRate = Int
type Sample = Float
type NumSamples = Int
type Wave = [Sample]
type Duration = Float
type Frequency = Float
type WaveType = Float → Float
type Amplitude = Float

data SpectrumPoint = SpectrumPoint {
    spectrumPointFrequency :: Frequency,
    spectrumPointAmplitude :: Amplitude
} deriving stock (Show)

type Spectrum = [SpectrumPoint]

data Intonation = JustIntonation | EqualTemperament deriving stock (Show)

data Scale = TwelveTone | Pentatonic deriving stock (Show)

data KeyModifier = Flat | Natural | Sharp | Cent Int deriving stock (Show)

data KeyName = A | B | C | D | E | F | G deriving stock (Show)

data ModulationType = AM | FM

data Modulation = Modulation {
    modulationType :: ModulationType,
    modulationFn   :: Float → Float
}

type AmplitudeEnvelope = Float → Float

type Modulations = [Modulation]

data NoteDuration = Dotted NoteDuration |
    Hemidemisemiquaver |
    Demisemiquaver |
    Semiquaver |
    Quaver |
    Minim |
    Semibreve |
    Breve deriving stock (Show)

type Octave = Int

type BPM = Int

data Key = Key {
    keyName       :: KeyName,
    keyModifier   :: KeyModifier,
    keyOctave     :: Octave,
    keyScale      :: Scale,
    keyIntonation :: Intonation
} deriving stock (Show)

data Articulation = Legato | Normal | Staccato deriving stock (Show)

data Tempo = Tempo {
    tempoNoteDuration :: NoteDuration,
    tempoBPM          :: BPM
} deriving stock (Show)

data Voice = Sine |
    Square |
    Sawtooth |
    Triangle deriving stock (Show)

data Note = Note {
    noteKey          :: Key,
    noteDuration     :: NoteDuration,
    noteArticulation :: Articulation,
    noteTempo        :: Tempo,
    noteAmplitude    :: Amplitude,
    noteModulations  :: Modulations,
    noteEnvelope     :: AmplitudeEnvelope
}

data Chord = Chord {
    chordNotes :: [Note],
    chordVoice :: Voice
}

type Tune = [Chord]

sampleRate ∷ SampleRate
sampleRate = 44100

noteToFrequency ∷ Note → Frequency
noteToFrequency = undefined

tuneToWave ∷ Tune → SampleRate → Wave
tuneToWave = undefined

fft ∷ Wave → Spectrum
fft = undefined

rollingFFT ∷ Wave → NumSamples → Spectrum
rollingFFT = undefined

wave ∷ WaveType → Frequency → Amplitude → Duration → Wave
wave = undefined

sine ∷ Frequency → Amplitude → Duration → Wave
sine = wave sin

save ∷ FilePath → Wave → IO ()
save = undefined

play ∷ FilePath → IO ()
play = undefined

note ∷ Key → Frequency
note = undefined

pitchBend ∷ ()
pitchBend = ()

adsr ∷ AmplitudeEnvelope
adsr = undefined
