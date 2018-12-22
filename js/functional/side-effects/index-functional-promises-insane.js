// Let's create some kind of pipeline
// Henceforth we can describe what we want outside of how we're going to get it.

// A complex example in the classical way
import fs from 'fs';
import https from 'https';
import {promisify} from 'util';

import {JSDOM} from 'jsdom';

import {
    constant,
    compose,
    flip,
    on,
    ap
} from './lib/combinators';

import {
    FILE,
    firstJSON,
    FIRST_DEBUG,
    IN_THE,
    THE_OPTS,
    OUT_IS,
    SITE_URL,
    IS_AWESOME,
    QS,
    ATTR,
    STATUS_CODE
} from './lib/constants';

import {iff} from './lib/logic';

import {
    eq,
    lte,
    add
} from './lib/maths';

import {
    callRest,
    callNew,
    doAndReturn,
    passAndDo 
} from './lib/my-combinators';

import {prop} from './lib/objects';


const writeFile = promisify(fs.writeFile),
    readFile = promisify(fs.readFile),
    unlink = promisify(fs.unlink);

// Well, to an extent it's less pyramidey, but at least it shows the actual order of operations here.
// Let's try a little more.

// We're going to have an expectation to make as much stuff as possible functional
// and describe what we want first, then afterwards not so much.

// Let's strip constants and simplify & pull out separate actions!

const streamToString = response =>
    new Promise((res, rej) => {
        let responseString = '';
        response.on('error', rej);
        response.on('data', dataChunk => {
            responseString += dataChunk.toString();
        });
        response.on('end', () => res(responseString));
    });

const findWhoIsAwesome = responseString => new JSDOM(responseString)
    .window
    .document
    .querySelector(QS)
    .getAttribute(ATTR);

const outPhrase = ([rnd, fileBuffer]) => [OUT_IS, JSON.parse(fileBuffer.toString()), rnd];
const rndAndStatus = rnd => [rnd, upOrDown(rnd)];
const theOpts = ([rnd, option]) => [rnd, IN_THE, prop(option)(THE_OPTS)];
const doWhen = check => whenTrue => whenFalse => pred => 
    check(pred)(ap(whenTrue)(whenFalse)(pred));
const getUrl = https => url => (res, rej) => https.get(url, on(doWhen(ifIsOK))(callWith)(res)(rej));

// Point-free
const ifIsOK = compose(iff)(compose(eq(200))(prop(STATUS_CODE)));
const callWith = compose(constant);
const makePromiseWith = compose(compose(callNew(Promise)));
const awesomePhrase = flip(add)(IS_AWESOME);
const upOrDown = compose(Number)(lte(0.5)); 
const promiseAll = Promise.all.bind(Promise);

// insert into the pipeline to view
//const debug = r => (void console.log(r)) || r;

// The actual sequence of events is defined here...
writeFile(FILE, firstJSON)
    .then(constant(FIRST_DEBUG))
    .then(console.log)
    .then(Math.random)
    .then(rndAndStatus)
    .then(theOpts)
    .then(doAndReturn(callRest(console.log)))
    .then(passAndDo(callWith(readFile)(FILE)))
    .then(promiseAll)
    .then(outPhrase)
    .then(callRest(console.log))
    .then(constant(FILE))
    .then(unlink)
    .then(constant(SITE_URL))
    .then(makePromiseWith(getUrl)(https))
    .then(streamToString)
    .then(findWhoIsAwesome)
    .then(awesomePhrase)
    .then(console.log)
    .catch(console.error);