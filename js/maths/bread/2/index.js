let canvas = document.querySelector('canvas'),
    h = window.innerHeight,
    w = window.innerWidth;

canvas.height = h;
canvas.width = w;
canvas.style.height = h+'px';
canvas.style.width = w + 'px';

let ctx = canvas.getContext('2d'),
    clear = () => ctx.clearRect(0, 0, w, h),
    res = 1,
    paint = (x,y,col) => {
        ctx.fillStyle = col;
        ctx.fillRect(x, y, res, res);
    },
    xytoni = (x, y) => {
        return [
            (x - w/2) / (h/2) * 2,
            (h/2 - y) / (h/2) * 2
        ];
    },
    mag = (n, i) => Math.sqrt(Math.pow(n, 2) + Math.pow(i, 2)),
    arg = (n, i) => Math.atan2(n, i),
    recpol = (n, i) => [arg(n, i), mag(n, i)],
    mulpol = (arg1, mag1, arg2, mag2) => [arg1 + arg2, mag1 * mag2],
    polrec = (arg, mag) => [-mag * Math.cos(arg), mag * Math.sin(arg)], // that - is random
    mulcmp = (n1, i1, n2, i2) => polrec(...mulpol(...recpol(n1, i1), ...recpol(n2, i2)))
    squared = (n, i) => mulcmp(n, i, n, i),
    itmax = 20,
    willgocrazy = (n, i) => {
        let resn = 0,
            resi = 0;
        for (let it = 0; it < itmax; it++) {
            // it is res^2 + n
            if (n == 1 && i == 0) {
                console.log(resn, resi, ...squared(resn, resi), mag(resn, resi))
            }
            [resn, resi] = squared(resn, resi);
            resn += n;
            resi += i;
            if (2 < mag(resn, resi)) return 'rgb('+it*20+','+it*20+','+it*20+')';
        }
        // not gone crazy
        return 'rgb('+(resi+1)*100+'%,'+(resn+1)*100+'%,'+100*mag(resi,resn)+'%)';
    },
    sweep = () => {
        for (let y = 0; y < h; y+=res) {
            for (let x = 0; x < w; x+=res) {
                let [n, i] = xytoni(x, y);
                if (2 < mag(n, i)) continue;
                paint(x,y,willgocrazy(n, i));
            }
        }
    },
    render = () => {
        sweep();
    };

render();
