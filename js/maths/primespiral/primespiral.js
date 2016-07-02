let canvas = document.querySelector('canvas'),
    w = window.innerWidth,
    h = window.innerHeight;
canvas.width = w;
canvas.height = h;
canvas.style.width = w + 'px';
canvas.style.height = h + 'px';

let ctx = canvas.getContext('2d'),
    centre = [Math.floor(w/2), Math.floor(h/2)],
    currentpoint = centre,
    isPrime = (n) => {
         if (isNaN(n) || !isFinite(n) || n%1 || n<2) return false;
         if (n==leastFactor(n)) return true;
         return false;
    },
    leastFactor = (n) => {
        if (isNaN(n) || !isFinite(n)) return NaN;
        if (n==0) return 0;
        if (n%1 || n*n<2) return 1;
        if (n%2==0) return 2;
        if (n%3==0) return 3;
        if (n%5==0) return 5;
        var m = Math.sqrt(n);
            for (var i=7;i<=m;i+=30) {
            if (n%i==0)      return i;
            if (n%(i+4)==0)  return i+4;
            if (n%(i+6)==0)  return i+6;
            if (n%(i+10)==0) return i+10;
            if (n%(i+12)==0) return i+12;
            if (n%(i+16)==0) return i+16;
            if (n%(i+22)==0) return i+22;
            if (n%(i+24)==0) return i+24;
        }
        return n;
    },
    plot = (point, colour) => {
        ctx.fillColor = colour;
        ctx.rect(...point,1,1);
        ctx.fill();
    },
    black = 'rgb(0,0,0)',
    minx = 0,
    maxx = 0,
    miny = 0,
    maxy = 0,
    d = 0, // quarters of tau
    n = 0,
    no = 1,
    not = 0;

for (let i = 0; i <= 100000; i++) {
    //console.log(i);

    if (isPrime(i)) {
        plot(currentpoint, black)
    }

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
        default: console.log('broken', d);
    }
    //console.log('currentpoint now', currentpoint)
}
