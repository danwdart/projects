import {calc} from './lib/calc.js';
import {countfact} from './lib/countfact.js';
import {sumfact} from './lib/sumfact.js';
import {generator as sternbrocot} from './lib/sternbrocot.js';
import {getContext as getCanvasContext, clear as clearCanvas} from './lib/canvas.js'; 
import {getContext as getAudioContext, getBuffer, getChannels as getBufferChannels} from './lib/audio.js';
import {drawLines} from './lib/line.js';
import {startsound} from './lib/audio.js';
import {playTone} from './lib/tone.js';
import {OPTIONS_DEFAULT, TYPES} from './lib/options.js';

const run = type => {
    const options = options = {
        ...OPTIONS_DEFAULT,
        ...TYPES[type]
    };

    const ctx = getCanvasContext();
    const audioContext = getAudioContext();
    const buffer = getBuffer(audioContext);
    const bufChannels = getBufferChannels(buffer);

    const [lines, tones, channels] = calc(options);

    drawLines(ctx, lines);
}

drawLines = lines => 
playTones = tones =>
playAudio = channels => 

// on click     playTone(audioContext, arrTones)
// on click    startsound(context, buffer)