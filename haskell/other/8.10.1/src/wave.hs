type SampleRate = Int
type Sample = Float
type NumSamples = Int
type Wave = [Sample]
type Duration = Float
type Frequency = Float
type WaveType = Float -> Float
type Amplitude = Float

data SpectrumPoint = SpectrumPoint {
    spectrumPointFrequency :: Frequency,
    spectrumPointAmplitude :: Amplitude
} deriving (Show)

type Spectrum = [SpectrumPoint]

data Intonation = JustIntonation | EqualTemperament deriving (Show)

data Scale = TwelveTone | Pentatonic deriving (Show)

data KeyModifier = Flat | Natural | Sharp | Cent Int deriving (Show)

data KeyName = A | B | C | D | E | F | G deriving (Show)

data ModulationType = AM | FM

data Modulation = Modulation {
    modulationType :: ModulationType,
    modulationFn :: Float -> Float
}

type AmplitudeEnvelope = Float -> Float

type Modulations = [Modulation]

data NoteDuration = Dotted NoteDuration |
    Hemidemisemiquaver |
    Demisemiquaver |
    Semiquaver |
    Quaver |
    Minim |
    Semibreve |
    Breve deriving (Show)

type Octave = Int

type BPM = Int

data Key = Key {
    keyName :: KeyName,
    keyModifier :: KeyModifier,
    keyOctave :: Octave,
    keyScale :: Scale,
    keyIntonation :: Intonation
} deriving (Show)

data Articulation = Legato | Normal | Staccato deriving (Show)

data Tempo = Tempo {
    tempoNoteDuration :: NoteDuration,
    tempoBPM :: BPM
} deriving (Show)

data Voice = Sine |
    Square |
    Sawtooth |
    Triangle deriving (Show)

data Note = Note {
    noteKey :: Key,
    noteDuration :: NoteDuration,
    noteArticulation :: Articulation,
    noteTempo :: Tempo,
    noteAmplitude :: Amplitude,
    noteModulations :: Modulations,
    noteEnvelope :: AmplitudeEnvelope
}

data Chord = Chord {
    chordNotes :: [Note],
    chordVoice :: Voice
}

type Tune = [Chord]

sampleRate :: SampleRate
sampleRate = 44100

noteToFrequency :: Note -> Frequency
noteToFrequency = undefined

tuneToWave :: Tune -> SampleRate -> Wave
tuneToWave = undefined

fft :: Wave -> Spectrum
fft = undefined

rollingFFT :: Wave -> NumSamples -> Spectrum
rollingFFT = undefined 

wave :: WaveType -> Frequency -> Amplitude -> Duration -> Wave
wave = undefined

sine :: Frequency -> Amplitude -> Duration -> Wave
sine = wave sin

save :: FilePath -> Wave -> IO ()
save = undefined

play :: FilePath -> IO ()
play = undefined

note :: Key -> Frequency
note = undefined

pitchBend :: ()
pitchBend = ()

adsr :: AmplitudeEnvelope
adsr = undefined

sampleTune :: Tune
sampleTune = [
    Chord {
        chordNotes = [
            Note {
                noteKey = Key {
                    keyName = C,
                    keyModifier = Natural,
                    keyOctave = 4,
                    keyScale = TwelveTone,
                    keyIntonation = JustIntonation
                },
                noteDuration = Semiquaver,
                noteArticulation = Normal,
                noteTempo = Tempo {
                    tempoNoteDuration = Semiquaver,
                    tempoBPM = 120
                },
                noteAmplitude = 0.5,
                noteModulations = [],
                noteEnvelope = adsr
            },
            Note {
                noteKey = Key {
                    keyName = E,
                    keyModifier = Natural,
                    keyOctave = 4,
                    keyScale = TwelveTone,
                    keyIntonation = JustIntonation
                },
                noteDuration = Semiquaver,
                noteArticulation = Normal,
                noteTempo = Tempo {
                    tempoNoteDuration = Semiquaver,
                    tempoBPM = 120
                },
                noteAmplitude = 0.5,
                noteModulations = [],
                noteEnvelope = adsr
            },
            Note {
                noteKey = Key {
                    keyName = G,
                    keyModifier = Natural,
                    keyOctave = 4,
                    keyScale = TwelveTone,
                    keyIntonation = JustIntonation
                },
                noteDuration = Semiquaver,
                noteArticulation = Normal,
                noteTempo = Tempo {
                    tempoNoteDuration = Semiquaver,
                    tempoBPM = 120
                },
                noteAmplitude = 0.5,
                noteModulations = [],
                noteEnvelope = adsr
            }
        ],
        chordVoice = Sine
    }
    ]

main :: IO ()
main = do
    let myWave = tuneToWave sampleTune sampleRate
    save "sample.bin" myWave
    play "sample.bin"
    return ()