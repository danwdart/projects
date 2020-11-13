import {HEIGHT, WIDTH} from './constants.js';

export const getContext = () => document.getElementById(`canvas`).getContext(`2d`)
export const clear = ctx => ctx.clearRect(0, 0, WIDTH, HEIGHT);