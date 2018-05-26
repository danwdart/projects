import {sumfact} from './lib/sumfact';
import {startsound} from './lib/startsound';
import {line} from './lib/line';

const ctx = document.getElementById(`canvas`).getContext(`2d`),
    context = new (window.AudioContext || window.webkitAudioContext)();

let buffer = context.createBuffer(2, 100000, 22050),
    oldx = 0,
    oldy = 0,
    ch0 = buffer.getChannelData(0),
    ch1 = buffer.getChannelData(1);

for (var i = 0; i <= 100000; i++) {
    var sf = sumfact(i);
    var newx = i;
    var newy = Math.log(sf) / 2;
    //if (newy == newx) continue;
    //if (newy > Math.sqrt(newx)) continue;
    line(
        ctx,
        oldx, oldy*100,
        newx, newy*100
    );
    //	playTone(context, 440+10000*((newy-5)/newx), 1, 1*i);
    oldx = newx;
    oldy = newy;
    ch0[i] = newy;
    ch1[i] = newy;
}

startsound(context, buffer);