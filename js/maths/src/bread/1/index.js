/* eslint-disable */
let canvas = document.querySelector(`canvas`),
    h = window.innerHeight,
    w = window.innerWidth;

canvas.height = h;
canvas.width = w;
canvas.style.height = h+`px`;
canvas.style.width = w + `px`;

let ctx = canvas.getContext(`2d`),
    clear = () => ctx.clearRect(0, 0, w, h),
    res = 1,
    paint = (x,y,col) => {
        ctx.fillStyle = col;
        ctx.fillRect(x, y, res, res);
    },
    zoom = 0.5,
    xytoni = (x, y) => [
        2*(x - w/2) / (h * zoom),
        2*(h/2 - y) / (h * zoom)
    ],
    nitoxy = (n, i) => [
        (n * (h * zoom) / 2) + w/2,
        h/2 - (i * (h * zoom) / 2)
    ],
    mag = (n, i) => Math.sqrt(Math.pow(n, 2) + Math.pow(i, 2)),
    arg = (n, i) => Math.atan2(n, i),
    recpol = (n, i) => [arg(n, i), mag(n, i)],
    mulpol = (arg1, mag1, arg2, mag2) => [arg1 + arg2, mag1 * mag2],
    polrec = (arg, mag) => [-mag * Math.cos(arg), mag * Math.sin(arg)], // that - is random
    mulcmp = (n1, i1, n2, i2) => polrec(...mulpol(...recpol(n1, i1), ...recpol(n2, i2)));
squared = (n, i) => mulcmp(n, i, n, i),
itmax = 20,
extrapoints = {};
willgocrazy = (n, i) => {
    let resn = 0,
        resi = 0;
    for (let it = 0; it < itmax; it++) {
        [resn, resi] = squared(resn, resi);
        resn += n;
        resi += i;
        if (2 < mag(resn, resi)) return `rgb(`+it*20+`,`+it*20+`,`+it*20+`)`;
    }
    // not gone crazy
    let [x,y] = nitoxy(n, i);
    if (`undefined` == typeof extrapoints[y])
        extrapoints[y] = {};
    if (`undefined` == typeof extrapoints[y][x])
        extrapoints[y][x] = 0;
    extrapoints[y][x]++;
    return `white`;
},
sweep = () => {
    for (let y = 0; y < h; y+=res) {
        for (let x = 0; x < w; x+=res) {
            let [n, i] = xytoni(x, y);
            if (2 < mag(n, i)) continue;
            paint(x,y,willgocrazy(n, i));
        }
    }

    for (let y in extrapoints) {
        for (let x in extrapoints[y]) {
            let popu = extrapoints[y][x];
            paint(x,y, `rgb(`+20*popu+`,`+20*popu+`,`+20*popu+`)`);
        }
    }
},
render = () => {
    sweep();
};

render();
