const video = document.querySelector(`video`),
    canvas = document.querySelector(`canvas`),
    ctx = canvas.getContext(`2d`),
    HEIGHT = 480,
    PIXELS_PER_FRAME = 1,
    animate = () => {
        const sourceImage = video,
            sourceX = 0,
            sourceY = row,
            sourceWidth = 640,
            sourceHeight = 1,
            destX = 0,
            destY = row,
            destWidth = 640,
            destHeight = 1;

        ctx.drawImage(
            sourceImage,
            sourceX,
            sourceY,
            sourceWidth,
            sourceHeight,
            destX,
            destY,
            destWidth,
            destHeight
        );
        row += PIXELS_PER_FRAME;
        row %= HEIGHT;
        requestAnimationFrame(animate);
    };

let row = 0;

navigator.mediaDevices.getUserMedia({
    video: true,
    audio: false
}).then((mediaStream) => {
    video.srcObject = mediaStream;
    video.addEventListener(`loadedmetadata`, (ev) => {
        video.play();
        requestAnimationFrame(animate);
    });
}).catch((err) => console.log(err));
