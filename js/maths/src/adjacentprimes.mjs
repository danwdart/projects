import {isprime, getprimes, getprimefactors} from '../lib/primes.mjs';

const numf = n => Array.from(getprimefactors(n)).length + 1;

for (let n = 1; n < 100; n++) {
    console.log(n, numf(n), numf(n - 1) + numf(n + 1));
}