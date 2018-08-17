import {constant, compose, applyTo, flip} from './lib/combinators';
import {foo, exec} from './lib/my-combinators';
import {add, mul, recip} from './lib/maths';

// Laters, but not quite laters
// These execute upon combination !!
const log = console.log;
const laterLog = () => log;

const neg = mul(constant(-1));
const backwardsComposer = foo(flip)(compose)
const sub = backwardsComposer(add)(neg)
const div = backwardsComposer(mul)(recip);

const zero = constant(0);
const one = constant(1);
const two = constant(2);
const forty = constant(40);

const addOne = add(one);
const onZero = applyTo(zero);
const addOneAndThen = compose(addOne);
const addTwo = addOneAndThen(addOne);
const withForty = applyTo(forty);
const addToForty = withForty(add);
const divideFromForty = withForty(div);

const oneAgain = addOne(zero);
const oneAgainAgain = onZero(addOne);
const anotherTwo = addTwo(zero);
const fortyTwo = addToForty(two);
const twenty = divideFromForty(two);

const output = [
    oneAgain,
    oneAgainAgain,
    anotherTwo,
    fortyTwo,
    twenty
].map(exec)

console.log(output);