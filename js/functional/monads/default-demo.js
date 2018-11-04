// a.b.c.d.e.f.g

const prop = p => o => o[p]; // haha
const def = d => v => v || d;

// I use this combinator a lot, I wonder what it's called?
// Or is it perhaps combine with f, g(x) and y, or f, f, g and x(y)?
// I don't think that works tho
const foo = f => g => x => y => f(g(x)(y));

const defToObj = def({});

const a = {};
const b = prop("b")(a); // a.b
const defB = defToObj(b); // a.b || {}
const defBAlt = defToObj(prop("b")(a)); // a.b || {}
const propDefObj = foo(defToObj)(prop); // y.x || {}

const c = propDefObj("c")(defBAlt); // x = b; y = c; then use above

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

const h = fluentDefaultProp(a)("b")("c")("d")("e")("f")("g")("h")();
console.log(h);