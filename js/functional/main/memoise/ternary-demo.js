import {ternaryMemoise} from './lib/memoise';

const ternary = x =>  {
    console.log(`Calculating raw with ${x}`);
    return y => {
        console.log(`Calculating raw with ${y}`);
        return z => {
            console.log(`Calculating raw with ${z}`);
            const result =  x * y * z;
            console.log(`Result inside function ${result}`);
            return result;
        };
    };
};

console.log('Calculating raw with 10, 20, 30');
const res1 = ternary(10)(20)(30);
console.log(`Result: ${res1}\n`);

console.log('Creating memoised version\n');
const memoised = ternaryMemoise(ternary);

console.log('Calculating memoised with 10, 20, 30 (should log)');
const res2 = memoised(10)(20)(30);
console.log(`Result: ${res2}\n`);

console.log('Calculating memoised with 10, 20, 30 (again - should not log)');
const res3 = memoised(10)(20)(30);
console.log(`Result: ${res3}\n`);

console.log('Calculating memoised with 20, 30, 40 (should log)');
const res4 = memoised(20)(30)(40);
console.log(`Result: ${res4}\n`);

console.log('Calculating memoised with 20, 30, 40 (again - should not log)');
const res5 = memoised(20)(30)(40);
console.log(`Result: ${res5}\n`);
