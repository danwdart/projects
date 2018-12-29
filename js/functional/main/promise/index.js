import {constant} from './lib/combinators';
import {waitApply} from './lib/wait';
import {delay} from './lib/delay';

// Generally, instead of writing this...
setTimeout(() => console.log('foo'), 5000);

// we can avoid function definitions and write this
setTimeout(console.log.bind(console, 'foo'), 5000);

// or pre-prepare and write this
const log = console.log.bind(console);

// This won't work and we can't force a rebind without duplicate code, but...
// setTimeout(log(`foo`), 5000);

// we can do this
const waitLog = waitApply(log);
setTimeout(waitLog('foo'), 5000);

// So how about shortening promises?
// First, the ES2015 promise syntax
delay(5000)
    .then(constant('foo'))
    //.then(x => console.log(x)) // Wait a minute, we don't need that duplicate `x`...
    .then(console.log) // This is a function that can just be called with the result!
    .catch(console.error);

// Then, the async/await syntax
(async () => {
    await delay(5000);
    console.log(await 'foo');
})();