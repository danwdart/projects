let primecache = new Set();

function isprime(i) {
    if (1 == i) return false;
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

function *getprimefactors(i) {
    for (let v of getprimes(Math.sqrt(i))) {
        if (0 == i % v) {
            yield v;
            i /= v;
        }
        if (1 == i) return;
    }
}

const semiprime = process.argv[2];

console.log(`Finding factors of ${semiprime}`);


console.log(`Finding factors of ${semiprime - 1}`);

const a = new Set();

let tot = 0;
let prod = 1;

for (let n of getprimefactors(semiprime - 1)) {
    a.add(n);
    prod *= n;
    tot += n;
    console.log(`${semiprime-1} mod ${n} = 0`);
}

console.log(`Using ${semiprime - 1}, ${semiprime} required, Product: ${prod}, total: ${tot}`);
console.log((prod-1) * (tot-1), (prod-17) * (tot-1), (prod+1) * (tot+1), (prod) * (tot));
