import {calc} from './lib/calc.js';
import {getContext as getCanvasContext, clear as clearCanvas} from './lib/canvas.js'; 
import {
    playSound,
    getContext as getAudioContext
} from './lib/audio.js';
import {drawLines} from './lib/line.js';
import {playTones} from './lib/tone.js';
import {OPTIONS_DEFAULT, TYPES} from './lib/options.js';
import { dom } from './lib/dom.js';

const getOptions = typefn => {
    const type = typefn();
    return {
        ...OPTIONS_DEFAULT,
        ...TYPES[type],
        scale: {
            ...OPTIONS_DEFAULT.scale,
            ...(TYPES[type].scale || {}),
        }
    };
}

const draw = typefn => {
        const options = getOptions(typefn),
            ctx = getCanvasContext(),
            [lines] = calc(options);

        clearCanvas(ctx);
        drawLines(ctx, lines);
    },
    tones = typefn => {
        const options = getOptions(typefn),
            audioContext = getAudioContext(),
            [,tones] = calc(options);
        
        playTones(audioContext, tones);
    },
    audio = typefn => {
        const options = {
                ...getOptions(typefn),
                numbers: 100000
            },
            audioContext = getAudioContext(),
            [,,channels] = calc(options);

        playSound(audioContext, channels);
    };

dom(draw, audio, tones);

