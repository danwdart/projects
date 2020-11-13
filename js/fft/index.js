window.AudioContext = window.AudioContext || window.webkitAudioContext;

let h = null,
    w = null,
    canvas = document.querySelector(`canvas`),
    ctx = canvas.getContext(`2d`);
resize = () => {
    h = window.innerHeight;
    w = window.innerWidth;
    canvas.height = h;
    canvas.width = w;
    canvas.style.height = h + `px`;
    canvas.style.width = w + `px`;
},
clear = () => {
    ctx.fillStyle = `black`;
    ctx.fillRect(0, 0, w, h);
},
draw = (x, y, c) => {
    ctx.fillStyle = c;
    ctx.fillRect(x, y, 1, 1);
},
line = (x1, y1, x2, y2, c) => {
    ctx.strokeStyle = c;
    ctx.lineStyle = c;
    ctx.fillStyle = c;
    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();
},
getUM = () => navigator.mediaDevices.getUserMedia({audio: true}),
run = () => {
    resize();
    window.addEventListener(`resize`, resize);

    var audioCtx = new AudioContext();

    getUM().then((stream) => {
        // Fx hack
        window.source = audioCtx.createMediaStreamSource(stream);

        let analyser = audioCtx.createAnalyser();
        analyser.fftSize = 4096;
        window.source.connect(analyser);

        let bufferLength = analyser.frequencyBinCount,
            rawData = new Uint8Array(bufferLength),
            freqData = new Uint8Array(bufferLength),
            oldfx = 0,
            oldfy = 0,
            newfx = 0,
            newfy = 0,
            oldrx = 0,
            oldry = 0,
            newrx = 0,
            newry = 0,
            loop = () => {
                analyser.getByteTimeDomainData(rawData);
                analyser.getByteFrequencyData(freqData);
                let sampleNum = 1;
                clear();
                oldfx = 0;
                oldfy = 0;
                newfx = 0;
                newfy = 0;
                oldrx = 0;
                oldry = 0;
                newrx = 0;
                newry = 0;
                for (let i = 0; i < bufferLength; i++) {
                    if (0 == i % sampleNum) {
                        newfx = i * w / bufferLength;
                        newfy = h - (h * (freqData[i] / 512));
                        line(oldfx, oldfy, newfx, newfy, `green`);

                        newrx = i * w / bufferLength;
                        newry = h/2 - (h * (rawData[i] / 512));
                        line(oldrx, oldry, newrx, newry, `green`);
                    }
                    oldfy = newfy;
                    oldfx = newfx;
                    oldry = newry;
                    oldrx = newrx;
                }

                requestAnimationFrame(loop);
            };

        loop();
    }).catch((err) => console.log(err));
};
run();
