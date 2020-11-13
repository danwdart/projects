import {HEIGHT} from './constants.js';

function drawLine(ctx,x1,y1,x2,y2) {
    ctx.beginPath();
    ctx.moveTo(x1, HEIGHT - y1);
    ctx.lineTo(x2, HEIGHT - y2);
    ctx.stroke();
}

export const drawLines = (ctx, lines) => lines.forEach(line => drawLine(ctx, ...line));