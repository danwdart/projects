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

const getAllOptions = () => {
    const OPTIONS = [];
    for (const id in TYPES) {
        OPTIONS.push(getOptions())
    }
    return OPTIONS;
}

const calcAll = (typefn, optionsOverrides = []) => {
    const options = getOptions(typefn);
    return calc({...options, ...optionsOverrides});
};

const draw = typefn => {
        const ctx = getCanvasContext(),
            [lines] = calcAll(typefn);

        clearCanvas(ctx);
        drawLines(ctx, lines);
    },
    tones = typefn => {
        const audioContext = getAudioContext(),
            [,tones] = calcAll(typefn);
        
        playTones(audioContext, tones);
    },
    audio = typefn => {
        const audioContext = getAudioContext(),
            [,,channels] = calcAll(typefn, {
                numbers: 100000
            });

        playSound(audioContext, channels);
    };

dom(draw, audio, tones);

