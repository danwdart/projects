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
    render = () => {
        let worker = new Worker('worker3.js');
        worker.addEventListener('message', (msg) => paint(msg.data.x, msg.data.y, msg.data.col));
        worker.addEventListener('error', (err) => console.log(err));
        worker.postMessage({w, h});
    };

render();
