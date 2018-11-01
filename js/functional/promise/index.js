// In order to avoid duplication like x => x[y](z), we will introduce a new function.

const key = y => x => x[y];
const combine = f => g => x => f(g(x));
const apply = f => x => f(x);
const applyTo = x => f => f(x);
const identity = x => x;
const constant = x => () => x;
// Note that this is the same as apply() but with fewer arguments
const wait = x => () => x();
// and these are similar wait()y functions as above.
// These could be rewritten as swaps but really what's the need...
const waitApply = x => y => () => x(y);
const waitApplyTo = y => x => () => x(y);

// Generally, instead of writing this...
setTimeout(() => console.log(`foo`), 5000);

// we can avoid function definitions and write this
setTimeout(console.log.bind(console, `foo`), 5000);

// or pre-prepare and write this
const log = console.log.bind(console);

// This won't work and we can't force a rebind without duplicate code, but...
// setTimeout(log(`foo`), 5000);

// we can do this
const waitLog = waitApply(log);
setTimeout(waitLog(`foo`), 5000);

// So how about shortening promises?
// First, the ES2015 promise syntax
const delay = msecs => new Promise(res => setTimeout(res, msecs));

// Hey, that could avoid so much repetition (TODO)

delay(5000)
    .then(constant(`foo`))
    //.then(x => console.log(x)) // Wait a minute, we don't need that duplicate `x`...
    .then(console.log) // This is a function that can just be called with the result!
    .catch(console.error);

// Then, the async/await syntax
(async () => {
    await delay(5000);
    console.log(await `foo`);
})();