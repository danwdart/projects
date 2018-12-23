const printf = s => process.stdout.write(s);
const BAUDRATE = 110;
const TIMEOUT = 1000 / BAUDRATE;
const PROGRESS_FULL = `#`;
const PROGRESS_EMPTY = `=`;
const BACKSPACE = `\x08`;
const SIZE = 40;
const first = PROGRESS_EMPTY.repeat(SIZE)
const manyOf = many => of => of.repeat(many);
const TEXT = manyOf(10)(`I am a really cool hacker. `)

// Impure
const onNextTick = fn => setTimeout(fn, TIMEOUT);

const draw = num => done => {
    if (num > SIZE) {
        printf(`\n`);
        done();
        return;
    }
    printf(
        manyOf(SIZE)(BACKSPACE) +
        manyOf(num)(PROGRESS_FULL)
    );
    onNextTick(() => draw(num + 1)(done));
}

const write = index => what => done => {
    if (index >= what.length) {
        printf(`\n`);
        done();
        return;
    }
    printf(what[index]);
    onNextTick(() => write(index + 1)(what)(done))
}

printf(first);
draw(1)(
    () => write(0)(TEXT)(
        () => console.log('Done')
    )
);