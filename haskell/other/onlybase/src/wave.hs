import Wave

sampleTune ∷ Tune
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

main ∷ IO ()
main = do
    let myWave = tuneToWave sampleTune sampleRate
    save "sample.bin" myWave
    play "sample.bin"
    pure ()
