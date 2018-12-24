const video = document.querySelector(`video`),
    canvas = document.querySelector(`canvas`),
    ctx = canvas.getContext(`2d`),
    animate = () => {
        ctx.drawImage(video, 0, row, 640, 10, 0, row, 640, 10);
        row++;
        row %= 480;
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
