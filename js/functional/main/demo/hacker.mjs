const BAUDRATE = 110;
const TIMEOUT = 1000 / BAUDRATE;
const PROGRESS_FULL = '#';
const PROGRESS_EMPTY = '=';
const BACKSPACE = '\x08';
const SIZE = 40;
const first = PROGRESS_EMPTY.repeat(SIZE);
const manyOf = many => of => of.repeat(many);
const TEXT = manyOf(10)('I am a really cool hacker. ');

const whatToDrawFor = num => (num > SIZE) ?
    '\n' :
    manyOf(SIZE)(BACKSPACE) +
    manyOf(num)(PROGRESS_FULL);

const whatToWriteFor = index => what => (index >= what.length) ?
    '\n':
    what[index];

const instructDraw = num => done => ({
    toPrint: whatToDrawFor(num),
    retDone: num > SIZE,
    next: () => draw(num + 1)(done)
});

const instructWrite = index => what => done => ({
    toPrint: whatToWriteFor(index)(what),
    retDone: index >= what.length,
    next: () => write(index + 1)(what)(done)
});

// Impure
const printf = s => process.stdout.write(s);
const onNextTick = fn => setTimeout(fn, TIMEOUT);

const draw = num => done => {
    const {toPrint, retDone, next} = instructDraw(num)(done);
    printf(toPrint);
    return (retDone) ? done() : onNextTick(next);
};

const write = index => what => done => {
    const {toPrint, retDone, next} = instructWrite(index)(what)(done);
    printf(toPrint);
    return (retDone) ? done() : onNextTick(next);
};

printf(first);
draw(1)(
    () => write(0)(TEXT)(
        () => console.log('Done')
    )
);