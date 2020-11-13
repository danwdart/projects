import {isprime, getprimes, getprimefactors} from '../lib/primes.mjs';

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
