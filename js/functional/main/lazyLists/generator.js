function *range(from, to, skip) {
    for (let i = from; i < to; i++) {
        yield i;
    }
}

function *take(n, gen) {
    let c = 1;
    for (let i of gen) {
        yield i;
        c++;
        if (c > n) {
            break;
        }
    }
}

function *map(fn, gen) {
    for (let i of gen) {
        yield fn(i);
    }
}

function *filter(fn, gen) {
    for (let i of gen) {
        if (fn(i)) {
            yield i;
        }
    }
}

function *takeWhile(fn, gen) {
    for (let i of gen) {
        if (!fn(i)) {
            break;
        }
        yield i;
    }
}

const ints = range(1, Infinity, 1);
const doubleInts = map((x => x * 2), ints);
const fin = take(10, doubleInts);
const output = [...fin];
console.log(output);