let primecache = new Set();

function isprime(i) {
    for (let v of getprimefactors(i)) {
        return false;
    }
    return true;
}

function* getprimes(upto) {
    var lv = 2;
    for (let i of primecache) {
        lv = i;
        if (upto <= i) return;
        yield i;
    }
    if (2 >= lv) {
        primecache.add(2);
        yield 2;
        lv = 3;
    }
    for (let i = lv; i <= upto; i += 2) {
        if (isprime(i)) {
            primecache.add(i);
            yield i;
        }
    }
}

for (let v of getprimes(200)) {
    console.log(v);
}

function *getprimefactors(i) {
    for (let v of getprimes(Math.sqrt(i))) {
        if (0 == i % v) {
            yield v;
            i /= v;
        }
        if (1 == i) return;
    }
}
