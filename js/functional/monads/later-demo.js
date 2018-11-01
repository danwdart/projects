import {
    later,
    laterMapFromLater,
    lazyLaterMapFromLater,
    laterMapFromValue,
    lazyLaterMapFromValue
} from './lib/later';

// Intentional side effect for tracing
const addTwo = x => { console.log(`Adding two`); return x + 2;};

const l = later(5);
console.log(`l = ${l()}\n`);

console.log(`Later Map From Later\n`)

const lMFL = laterMapFromLater(l)(addTwo);
console.log(`lMFL = ${lMFL}`);
const lMFLVal = lMFL();
console.log(`lMFL Value = ${lMFLVal}`);

console.log(`\nLazy Later Map From Later\n`)

const llMFL = lazyLaterMapFromLater(l)(addTwo);
console.log(`llMFL = ${llMFL}`);
const llMFLVal = llMFL();
console.log(`llMFL Value = ${llMFLVal}`);

console.log(`\nLater Map From Value\n`);

const lMFV = laterMapFromValue(5)(addTwo);
console.log(`lMFV = ${lMFV}`);
const lMFVVal = lMFV();
console.log(`lMFV Value = ${lMFVVal}`);

console.log(`\nLazy Later Map From Value\n`);

const lLMFV = lazyLaterMapFromValue(5)(addTwo);
console.log(`lLMFV = ${lLMFV}`);
const lLMFVVal = lLMFV();
console.log(`lLMFV Value = ${lLMFVVal}`);