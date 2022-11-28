import assert from 'assert';
import {isprime, getprimes, getprimefactors} from '../../lib/primes.mjs';

describe(`isprime`, () => {
    it(`should say 1 isn't prime`, () =>
        assert.strict.equal(false, isprime(1))
    );
    it(`should say 2 is prime`, () =>
        assert.strict.equal(true, isprime(2))
    );
    it(`should say 3 is prime`, () =>
        assert.strict.equal(true, isprime(3))
    );
    it(`should say 4 isn't prime`, () =>
        assert.strict.equal(false, isprime(4))
    );
});

describe(`getprimes`, () => {
    it(`should return nothing for 1`, () =>
        assert.strict.deepEqual([], Array.from(getprimes(1)))
    );

    it(`should return single for single`, () =>
        assert.strict.deepEqual([2], Array.from(getprimes(2)))
    );

    it(`should return three items for 5`, () =>
        assert.strict.deepEqual([2,3,5], Array.from(getprimes(5)))
    );

    it(`should return three items for 6`, () =>
        assert.strict.deepEqual([2,3,5], Array.from(getprimes(6)))
    );

    it(`should return four items for 8`, () =>
        assert.strict.deepEqual([2,3,5,7], Array.from(getprimes(8)))
    );
});

describe(`getprimefactors`, () => {
    it(`should return nothing for 1`, () =>
        assert.strict.deepEqual([], Array.from(getprimefactors(1)))
    );

    it(`should return single for 2`, () =>
        assert.strict.deepEqual([2], Array.from(getprimefactors(2)))
    );

    it(`should return single for 3`, () =>
        assert.strict.deepEqual([3], Array.from(getprimefactors(3)))
    );

    it(`should return double for 4`, () =>
        assert.strict.deepEqual([2,2], Array.from(getprimefactors(4)))
    );

    it(`should return double for 6`, () =>
        assert.strict.deepEqual([2,3], Array.from(getprimefactors(6)))
    );

    it(`should return triple for 8`, () =>
        assert.strict.deepEqual([2,2,2], Array.from(getprimefactors(8)))
    );

    it(`should return triple for 12`, () =>
        assert.strict.deepEqual([2,2,3], Array.from(getprimefactors(12)))
    );

    it(`should return quadruple for 60`, () =>
        assert.strict.deepEqual([2,2,3,5], Array.from(getprimefactors(60)))
    );
});