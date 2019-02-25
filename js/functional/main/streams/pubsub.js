const thrush = x => f => f(x);
const not = x => y => x !== y;
const compose = f => g => x => f(g(x));
const swap = f => x => y => f(y)(x);
const filter = f => a => a.filter(f);

const emit = channel => msg => channel.map(thrush(msg));
const on = channel => sub => [...channel, sub];
const off = swap(compose(compose)(swap(filter)))(not);

const f = console.debug;

const channel1 = [];

emit(channel1)('Bob!');

const channel2 = on(channel1)(f);
emit(channel2)('Bob!!');

const channel3 = off(channel2)(f);
emit(channel3)('Bob!!!');

