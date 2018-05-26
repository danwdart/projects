const ctx = document.getElementById(`canvas`).getContext(`2d`),
    context = new (window.AudioContext || window.webkitAudioContext)();

let buffer = context.createBuffer(2, 100000, 22050);


//function playSound(buffer) {
//  var source = context.createBufferSource(); // creates a sound source
//  source.buffer = buffer;                    // tell the source which sound to play
//  source.connect(context.destination);       // connect the source to the context's destination (the speakers)
//  source.start(0);                           // play the source now
//                                             // note: on older systems, may have to use deprecated noteOn(time);
//}

var playTone = function(freq, time, delay) {
    var oscillator = context.createOscillator();
    oscillator.type = 0; // sine wave

    setTimeout(function() {
        oscillator.frequency.value = freq;
        oscillator.connect(context.destination);
        oscillator.start();
    }, delay);

    setTimeout(function() {
        oscillator.stop();
    }, delay + time);
};


var HEIGHT = 300;
function line(x1,y1,x2,y2) {
    ctx.beginPath();
    ctx.moveTo(x1, HEIGHT - y1);
    ctx.lineTo(x2, HEIGHT - y2);
    ctx.stroke();
}
var oldx = 0;
var oldy = 0;

function* sternbrocot() {
    let i = 0,
        nums = [1,1];
    yield 1;
    yield 1;
    while(true) {
        nums.push(nums[i] + nums[i+1]);
        yield nums[i] + nums[i+1];
        nums.push(nums[i]);
        yield nums[i];
        i++;
    }
}

let sb = sternbrocot();

for (var i = 0; i <= 1000; i++) {
    var sf = (sb.next().value);
    var newx = i;
    var newy = sf;
    //if (newy == newx) continue;
    //if (newy > Math.sqrt(newx)) continue;
    line(
        oldx*5, oldy*5,
        newx*5, newy*5
    );
    playTone(440*Math.pow(2,(newy/12)), 50, 50*i);

    oldx = newx;
    //if (1 != newy) {
    oldy = newy;
    //}
}

setTimeout(function() {

    var source = context.createBufferSource();
    source.buffer = buffer;
    source.connect(context.destination);
    source.start(0);
}, 5000);