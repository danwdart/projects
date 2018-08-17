const printf = process.stdout.write.bind(process.stdout);
const BAUDRATE = 110;
const TIMEOUT = 1000 / BAUDRATE;
const onNextTick = fn => setTimeout(fn, TIMEOUT);
// const writeToBuffer = () => 
// const flushBuffer = () => 

const progress = fn => {
    const PROGRESS_FULL = `#`;
    const PROGRESS_EMPTY = `=`;
    const BACKSPACE = `\x08`;
    const SIZE = 40;
    
    const first = PROGRESS_EMPTY.repeat(SIZE)

    printf(first);
    const draw = num => {
        if (num > SIZE) {
            printf(`\n`);
            fn();
            return;
        }
        printf(BACKSPACE.repeat(SIZE));
        printf(PROGRESS_FULL.repeat(num));
        onNextTick(draw.bind(null, num + 1));
    }
    draw(1);
}

const writeSlow = what => {
    const write = index => {
        if (index >= what.length) {
            printf(`\n`);
            return;
        }
        printf(what[index]);
        onNextTick(write.bind(null, index + 1))
    }
    write(0);
}

progress(
    () => writeSlow(`I am a really cool hacker. `.repeat(100))
);