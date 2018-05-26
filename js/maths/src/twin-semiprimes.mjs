import {getprimefactors} from '../lib/primes';

const numf = n => Array.from(getprimefactors(n)).length;

for (let n = 1; n < 100; n++) {
    if (2 == numf(n)) {
        console.log(`${n}: ${n-2}: ${numf(n-2)}${2 === numf(n-2)?` (also semi)`:``} and ${n+2}: ${numf(n+2)}${2 === numf(n+2)?` (also semi)`:``}`);
    }
}