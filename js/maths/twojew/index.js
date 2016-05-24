let canvas = document.querySelector('canvas'),
    h = window.innerHeight,
    w = window.innerWidth;

canvas.height = h;
canvas.width = w;
canvas.style.height = h+'px';
canvas.style.width = w + 'px';

let ctx = canvas.getContext('2d'),
    clear = () => ctx.clearRect(0, 0, w, h),
    paint = (x,y,col) => {
        ctx.fillStyle = col;
        ctx.fillRect(x, y, 1, 1);
    },
    xytoni = (x, y) => {
        return [
            (x - w/2) / (h/4),
            (h/2 - y) / (h/4)
        ];
    },
    mag = (n, i) => Math.sqrt(Math.pow(n, 2) + Math.pow(i, 2)),
    arg = (n, i) => Math.atan2(n, i),
    recpol = (n, i) => [mag(n, i), arg(n, i)],
    mulpol = (arg1, mag1, arg2, mag2) => [arg1 + arg2, mag1 * mag2],
    polrec = (arg, mag) => [mag * Math.cos(arg), mag * Math.sin(arg)],
    mulcmp = (n1, i1, n2, i2) => polrec(...mulpol(...recpol(n1, i1), ...recpol(n2, i2))),
    squared = (n, i) => mulcmp(n, i, n, i),
    itmax = 2,
    willgocrazy = (n, i) => {
        let resn = 0,
            resi = 0;
        for (let it = 0; it < itmax; it++) {
            [resn, resi] = squared(resn, resi);
            resn += n;
            resi += i;
            if (n == -1 && i == 0) {
                console.log(resn, resi)
            }
            if (2 > mag(resn, resi)) return true;
        }
        return false;
    },
    truth = (n, i) => {
        return 2 > mag(n, i) && !willgocrazy(n, i);
    },
    sweep = () => {
        for (let y = 0; y < h; y++) {
            for (let x = 0; x < w; x++) {
                if (truth(...xytoni(x,y)))
                    paint(x,y,'black');
            }
        }
    },
    render = () => {
        sweep();
    };

render();
