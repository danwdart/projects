// Let's create some kind of pipeline
// Henceforth we can describe what we want outside of how we're going to get it.

// A complex example in the classical way
/* eslint-disable cleanjs/no-new */
/* eslint-disable cleanjs/no-let */
/* eslint-disable cleanjs/must-return */
/* eslint-disable cleanjs/no-mutation */
import fs from 'fs';
import https from 'https';
import {JSDOM} from 'jsdom';

import {promisify} from 'util';

const writeFile = promisify(fs.writeFile),
    readFile = promisify(fs.readFile),
    unlink = promisify(fs.unlink);

// Let's tidy that up a bit, shall we?
// First, plain promises, which are slightly more declarative...

const FILE = 'a2';
const firstJSON = '{"I have no idea": "How this is happening"}';

writeFile(FILE, firstJSON).then(() => {
    console.debug('hi, just some kind of debug in between');
    const rnd = Math.random(); // oooh, non-determinism...
    console.log(`We are in the ${0.5 > rnd ? 'bottom' : 'top'}`);
    return Promise.all([rnd, FILE, readFile(FILE)]);
}).then(([rnd, FILE, fileBuffer]) => {
    console.log('The output is %o, the rand was %d and I are gewd', JSON.parse(fileBuffer.toString()), rnd);
    return unlink(FILE);
}).then(() => new Promise((res, rej) =>
    https.get('https://dandart.co.uk', response => 200 === response.statusCode ?
        res(response) :
        rej(new Error('Not 200'))
    )
)).then(response => {
    let responseString = '';
    response.on('data', dataChunk => {
        responseString += dataChunk.toString();
    });
    response.on('end', () => {
        const {document} = new JSDOM(responseString).window;
        const awesomeMeta = document.querySelector('meta[http-equiv="Who-is-awesome"]');
        const awesomePerson = awesomeMeta.getAttribute('content');
        console.log(awesomePerson, 'is awesome.');
    });
}).catch(console.error);