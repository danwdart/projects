let primecache = new Set();

export function isprime(i) {
    if (1 === i) {
        return false;
    }
    if (primecache.has(i)) {
        return true;
    }
    for (let possible = 2; possible <= Math.sqrt(i); possible++) {
        if (0 == i % possible) {
            return false;
        }
    }
    primecache.add(i);
    return true;
}

export function* getprimes(upto) {
    if (1 === upto) {
        return;
    }
    for (let i = 2; i <= upto; i++) {
        if (isprime(i)) {
            yield i;
        }
    }
}

export function *getprimefactors(i) {
    for (let possibleDivisor of getprimes(i)) {
        while (0 == i % possibleDivisor) {
            yield possibleDivisor;
            i /= possibleDivisor;
        }
        if (1 == i) {
            return;
        }
    }
}