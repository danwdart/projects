// Inspired by https://github.com/wasiher/bare_words_js
const bare = new Proxy(
    {},
    {
        has: (t, n) => !(n in global),
        get: (t, n) => n,
        set: (t, n, v) => global[n] = v
    }
);

with(bare) {
    console.log(have, you, ever, come, across, this, bare, thing);
    redefine = words
    console.log(now, we, have, made, redefine);
};

const barefunc = new Proxy(
    {},
    {
        has: (t, n) => !(n in global),
        get: (t, n) => () => n,
        set: (t, n, v) => global[n] = v
    }
);

with(barefunc) {
    console.log(these(), functions(), exist(), now());
    a = f
    console.log(a());
}

const tracer = what => new Proxy(
    what,
    {
        has: (t, n) => { console.log(`has`, n); return n in what;},
        get: (t, n) => { console.log(`get`, n); return ('object' == typeof what[n]) ? tracer(what[n]) : what[n];},
        set: (t, n, v) => { console.log(`set`, n, v); return what[n] = v;}
    }
);

with(tracer(global)) {
    console.log("Tracing this stuff is good.");
}
