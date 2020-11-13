const compose = f => {
    console.log(`f: ${f}`);
    return g => {
        console.log(`f: ${f}, g: ${g}`);
        return x => {
            console.log(`f: ${f}, g: ${g}, x: ${x}`);
            return f(g(x));
        };
    };
};

const add = x => y => x + y;
const times = x => y => x * y;

const addOne = add(1);
const timesTwo = times(2);

console.log('Composing');
const composed = compose(addOne)(timesTwo);
console.log('Evaluating');
const value = composed(1);
console.log('Start');
console.log(value);
console.log('End');

console.log('Composing');
const composed1 = compose(compose(compose(addOne)(timesTwo))(timesTwo))(addOne);
console.log('Evaluating');
const value1 = composed1(1);
console.log('Start');
console.log(value1);
console.log('End');

// simplify

