// Let's create some kind of pipeline
// Henceforth we can describe what we want outside of how we're going to get it.

// A complex example in the classical way
import fs from 'fs';
import https from 'https';
import {JSDOM} from 'jsdom';

import {promisify} from 'util';

const writeFile = promisify(fs.writeFile),
    readFile = promisify(fs.readFile),
    unlink = promisify(fs.unlink);

// What a mess!
(async () => {
    const FILE = 'a';
    await writeFile(FILE, '{"I have no idea": "How this is happening"}');
    console.debug('hi, just some kind of debug in between');
    const buf = await readFile(FILE);
    const output = buf.toString();
    const decoded = JSON.parse(output);
    const rnd = Math.random(); // oooh, non-determinism...
    console.log(`We are in the ${0.5 > rnd ? 'bottom' : 'top'}`);
    console.log('The output is %o, the rand was %d and I are gewd', decoded, rnd);
    await unlink(FILE);
    // hmmmmm network
    try {
        const response = await new Promise((res, rej) => 
            https.get('https://dandart.co.uk', response => 200 === response.statusCode ?
                res(response) :
                rej(new Error('Not 200'))
            )
        );
        let responseString = '';
        for await (let dataChunk of response) {
            responseString += dataChunk.toString();
        }

        const {document} = new JSDOM(responseString).window;
        const awesomeMeta = document.querySelector('meta[http-equiv="Who-is-awesome"]');
        const awesomePerson = awesomeMeta.getAttribute('content');
        console.log(awesomePerson, 'is awesome.');
    } catch (err) {
        console.error('oh no', err.message);
    }
})();