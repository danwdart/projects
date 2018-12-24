const video = document.querySelector(`video`),
    canvas = document.querySelector(`canvas`),
    ctx = canvas.getContext(`2d`),
    WIDTH = 640,
    HEIGHT = 480,
    PIXELS_PER_FRAME = 2,
    drawTo = ctx => sourceImage => ({
        src: {
            x: sourceX,
            y: sourceY,
            width: sourceWidth,
            height: sourceHeight
        },
        dest: {
            x: destX,
            y: destY,
            width: destWidth,
            height: destHeight
        }
    }) => ctx.drawImage(
        sourceImage,
        sourceX,
        sourceY,
        sourceWidth,
        sourceHeight,
        destX,
        destY,
        destWidth,
        destHeight
    ),
    copyFrom = ctx => sourceImage => params => drawTo(ctx)(sourceImage)({
        src: params,
        dest: params
    }),
    copy = copyFrom(ctx)(video),
    animate = () => {
        copy({
            x: 0,
            y: row,
            width: WIDTH,
            height: PIXELS_PER_FRAME
        });

        copy({
            x: 0,
            y: HEIGHT - row,
            width: WIDTH,
            height: PIXELS_PER_FRAME
        });

        copy({
            x: col,
            y: 0,
            width: PIXELS_PER_FRAME,
            height: HEIGHT
        });

        copy({
            x: WIDTH - col,
            y: 0,
            width: PIXELS_PER_FRAME,
            height: HEIGHT
        });

        row += PIXELS_PER_FRAME;
        row %= HEIGHT;

        col += PIXELS_PER_FRAME;
        col %= WIDTH;
        requestAnimationFrame(animate);
    };

let row = 0,
    col = 0;

(async () => {
    try {
        const mediaStream = await navigator.mediaDevices.getUserMedia({
            video: true,
            audio: false
        });
        
        video.srcObject = mediaStream;

        video.addEventListener(`loadedmetadata`, (ev) => {
            video.play();
            requestAnimationFrame(animate);
        });
    } catch (err) {
        console.error(err);
    }
})();


