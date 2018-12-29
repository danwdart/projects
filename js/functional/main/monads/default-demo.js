import {compose, dup} from './lib/functional';
import {prop} from './lib/object';
import {def} from './lib/value';

// a.b.c.d.e.f.g

// I use this combinator a lot, I wonder what it's called?
//const foo = f => g => x => y => f(g(x)(y));

// foo can be shortened and made more confusing...
//const fooComposed1 = f => g => x => compose(f)(g(x));
//const fooComposed2 = f => compose(compose(f));
//const fooComposed3 = f => compose(compose)(compose)(f);
// we're finally pointless :p
//const fooComposed4 = compose(compose)(compose);
//const fooComposed5 = dup(compose)(compose);
const fooComposed6 = dup(dup)(compose);
// still at 3 fns, not going to get better than that.

// if we reverse and get pointy this gets way more confusing...
// const fooComposed7 = (f => x => f(x)(x))(f => x => f(x)(x))(f => g => x => f(g)(x))
// console.log(fooComposed6(s => s.toUpperCase())(x => y => x + y)("hello ")("world"))

const defToObj = def({});

const a = {};
//const b = prop('b')(a); // a.b
//const defB = defToObj(b); // a.b || {}
//const defBAlt = defToObj(prop('b')(a)); // a.b || {}
const propDefObj = fooComposed6(defToObj)(prop); // y.x || {}

//const c = propDefObj('c')(defBAlt); // x = b; y = c; then use above

// it's nicer and fluenter if we can do a...
// const h = something(a)("b")("c")("d")("e")("f")("g")("h")();
// so what is something?
const fluentDefaultProp = obj => {
    const fOut = prop => {
        // Not allowed to do that! TODO work it out
        obj = propDefObj(prop)(obj);
        return prop ? fOut : obj;
    };
    return fOut;
};

const h = fluentDefaultProp(a)('b')('c')('d')('e')('f')('g')('h')();
console.log(h);