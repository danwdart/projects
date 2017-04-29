const c = document.querySelector('canvas'),
    ctx = c.getContext('2d'),
    draw = ([x,y]) => {
        ctx.fillRect(x,y,1,1);
    },
    between = (a, b) => Math.floor((b - a) * Math.random() + a),
    pick = arr => arr[Math.floor(arr.length * Math.random())],
    randpoint = () => [between(0, 800), between(0, 800)],
    avg = (p1, p2) => [
        Math.round(
            (p1[0] + p2[0]) / 2
        ),
        Math.round(
            (p1[1] + p2[1]) / 2
        )
    ],
    points = [];

let state = randpoint();

ctx.fillStyle = 'black';

draw(state);

for (let i = 0; i < 5; i++) {
    points[i] = randpoint();
    draw(points[i]);
}

for (let n = 0; n <= 1000000; n++) {
    const towhich = pick(points);
    state = avg(state, towhich);
    draw(state);
}
