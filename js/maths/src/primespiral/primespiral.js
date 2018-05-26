let canvas = document.querySelector(`canvas`),
    w = window.innerWidth,
    h = window.innerHeight;
canvas.width = w;
canvas.height = h;
canvas.style.width = w + `px`;
canvas.style.height = h + `px`;

let ctx = canvas.getContext(`2d`),
    centre = [Math.floor(w/2), Math.floor(h/2)],
    currentpoint = centre,
    plot = (point, colour) => {
        ctx.fillColor = colour;
        ctx.rect(...point,1,1);
        ctx.fill();
    },
    black = `rgb(0,0,0)`,
    red = `rgb(255,0,0)`,
    green = `rgb(0,255,0)`,
    blue = `rgb(0,0,255)`,
    d = 0, // quarters of tau
    n = 0,
    no = 1,
    not = 0;

for (let i = 0; i <= 10000; i++) {
    //console.log(i);

    let r = Math.pow(i,7) % 6,
        map = [
            black,
            red,
            green,
            blue
        ];

    if (2 == not) {
        //console.log('not reached 2, resetting, adding no');
        no++;
        not = 0;
    }

    if (no == n) {
        //console.log('n (',n,') reached no (',no,'), turning and resetting n, adding not');
        not++;
        d++;
        n = 0;
    }

    if (4 == d) {
        //console.log('d reached 4; resetting');
        d = 0;
    }

    n++;

    switch (d) {
    case 0: currentpoint[0]++; break;
    case 1: currentpoint[1]--; break;
    case 2: currentpoint[0]--; break;
    case 3: currentpoint[1]++; break;
    default: console.log(`broken`, d);
    }
    //console.log('currentpoint now', currentpoint)

    plot(currentpoint, map[r]);
}
