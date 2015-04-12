var video = document.querySelector('video'),
    canvas = document.querySelector('canvas'),
    textarea = document.querySelector('textarea'),
    context = canvas.getContext('2d'),
    backCanvas = document.createElement('canvas'),
    backContext = backCanvas.getContext('2d');

navigator.getUserMedia = navigator.getUserMedia ||
    navigator.webkitGetUserMedia ||
    navigator.mozGetUserMedia ||
    navigator.msGetUserMedia;

var AudioContext = window.AudioContext || window.webkitAudioContext,
    audioContext = new AudioContext(),
    oscillator = audioContext.createOscillator();

function playSound(buffer) {
    var source = audioContext.createBufferSource(); // creates a sound source
    source.buffer = buffer;                    // tell the source which sound to play
    source.connect(audioContext.destination);       // connect the source to the context's destination (the speakers)
    source.start(0);                           // play the source now
                                             // note: on older systems, may have to use deprecated noteOn(time);
}

var playTone = function(freq, time, delay) {

    oscillator.type = 0; // sine wave

    !function(oscillator, delay) {
    setTimeout(function() {
        oscillator.frequency.value = freq;
        oscillator.connect(audioContext.destination);
        //oscillator.start();
    }, delay);
    }(oscillator, delay);

    !function(oscillator, delay) {
    setTimeout(function() {
        //oscillator.stop();
    }, delay + time);
}(oscillator, delay);
}

navigator.getUserMedia(
    {
        video: true,
        audio: false
    },
    function(localMediaStream) {
        video.src = window.URL.createObjectURL(localMediaStream);
        video.onloadedmetadata = function(e) {
            readycam();
        };
    },
    function(e) {
        alert('no cam', e);
    }
);
function readycam()
{
    oscillator.start();
    var cw = canvas.clientWidth;
    var ch = canvas.clientHeight;
    canvas.width = cw;
    canvas.height = ch;
    backCanvas.width = cw;
    backCanvas.height = ch;
    draw(video,context,backContext,cw,ch);
}

function draw(v, c, bc, w, h)
{
    bc.drawImage(v,0,0,w,h);
    var idata = bc.getImageData(0,0,w,h);
    var data = idata.data;
    var brightpx = 0;
    var brightest = 0;
    for(var i = 0; i < data.length; i+=4) {
        var r = data[i];
        var g = data[i+1];
        var b = data[i+2];
        var brightness = (3*r+4*g+b)>>>3;
        data[i] = 0;
        data[i+1] = 0;
        data[i+2] = 0;
        if (brightness >= brightest) {
            brightest = brightness;
            brightpx = i;
        }
    }
    data[brightpx] = 255;
    data[brightpx+1] = 255;
    data[brightpx+2] = 255;
    idata.data = data;
    // Draw the pixels onto the visible canvas
    c.putImageData(idata,0,0);
    var realX = brightpx % w;
    var realY = Math.floor(brightpx / w);
    var tone = 440 + ((1000/h) * (h - realY));
    playTone(tone,20,0)
    setTimeout(draw,20,v,c,bc,w,h);
}