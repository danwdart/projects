let canvas = document.querySelector(`canvas`),
    debug = document.getElementById(`debug`),
    width = window.innerWidth,
    height = window.innerHeight,
    squareWidth = 10,
    squareHeight = 10,
    paddingHeight = 50,
    paddingWidth = 50,
    state = Math.floor(Math.random() * 255),
    rule = Math.floor(Math.random() * 255);

canvas.width = width;
canvas.style.width = width + `px`;
canvas.height = height;
canvas.style.height = height + `px`;
let ctx = canvas.getContext(`2d`);

function padZeroes(n, digits) {
    return (`00000000000000000000000000000000000000000000000000000000000000` + n).slice(-digits);
}

function drawSquare(x, y, colour) {
    let topLeftX = paddingWidth + (x * squareWidth),
        topLeftY = paddingHeight + (y * squareHeight);
    ctx.fillStyle = colour;
    ctx.fillRect(topLeftX, topLeftY, squareWidth, squareHeight);
}

function drawLine(state, lineno) {
    let binary = state.toString(2);

    for (let character = 0; character < binary.length; character++) {
        let num = binary.charAt(character);
        drawSquare(character, lineno, ((`1` == num)?`black`:`white`));
    }
}

function iterateState(state, rule) {
    let binary = padZeroes(state.toString(2), 50);
    console.log(binary);
    let newString = ``;
    for (let character = 0; character < binary.length; character++) {
        let currentChars = ((0 == character)?0:binary.charAt(character - 1)) +
            binary.charAt(character) +
            ((binary.length == character)?0:binary.charAt(binary.character + 1)),
            current = parseInt(currentChars, 2),
            binRule = padZeroes(rule.toString(2), 8),
            lookedup = binRule.charAt(current);
        /*console.log('State is', state,
            'character is', character,
            'current chars is', currentChars,
            'current lookup should be', current,
            'upon binary rule', binRule,
            'bit is', lookedup
        );*/
        newString += lookedup;
    }
    return parseInt(newString, 2);
}

function clear()
{
    ctx.fillStyle = `white`;
    ctx.fillRect(0, 0, width, height);
}

function go() {
    clear();
    state = Math.floor(Math.random() * 255);
    rule = Math.floor(Math.random() * 255);
    debug.innerHTML = `Initial State: `+state+` Rule: `+rule;
    for (let i = 0; i < 50; i++) {
        drawLine(state, i);
        state = iterateState(state, rule);
    }
}
go();
setInterval(go, 250);
