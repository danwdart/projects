import {countfact} from './seq/countfact.js';
import {sumfact} from './seq/sumfact.js';
import {generator as sternbrocot, generatorModded as sbmod} from './seq/sternbrocot.js';
import {logistic} from './seq/logistic.js';
import {identity} from './combinators.js';
import {generatorToFunction} from './utils.js';

export const OPTIONS_DEFAULT = {
    numbers: 1000,
    scale: {
        x: 5,
        y: 5
    }
};

export const TYPES = {
    countfact: {
        fn: countfact,
        scale: {
            y: 20
        },
        soundfn: newy => (Math.log(newy) / 10) - 0.5,
        tonefn: (i, newx, newy) => ([440 + 100 * newy, 100, 100 * i]),
        newyfn: identity,
    },
    sumfact: {
        fn: sumfact,
        scale: {
            y: 20
        },
        soundfn: newy => newy,
        tonefn: (i, newx, newy) => ([440 + 100 * newy, 100, 100 * i]),
        newyfn: sf => Math.log(sf) / 2
    },
    sternbrocot: {
        fn: generatorToFunction(sternbrocot),
        soundfn: newy => (Math.log(newy) / 10) - 0.5,
        tonefn: (i, newx, newy) => ([440 + 100 * newy, 100, 100 * i]),
        newyfn: identity
    },
    sbmod: {
        fn: generatorToFunction(sbmod),
        soundfn: newy => (Math.log(newy) / 10) - 0.5,
        tonefn: (i, newx, newy) => ([440 + 100 * newy, 100, 100 * i]),
        newyfn: identity
    },
    logistic: {
        fn: logistic,
        scale: {
            y: 300,
            x: 2
        },
        soundfn: newy => newy,
        tonefn: (i, newx, newy) => ([440 + 1000 * newy, 100, 100 * i]),
        newyfn: identity
    }
}