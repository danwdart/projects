const trier = (fn, fail, final) => () => {
    try {
        fn();
    } catch (err) {
        if (fail) {
            fail(err);
        } else {
            throw err;
        }
    } finally {
        if (final) {
            final();
        }
    }
};

const fn1 = () => {
    console.log('Hi!');
    do_something_destructive();
    console.log('I will never be shown.');
};

const fn2 = err => {
    console.log('Caught error', err.message);
};

const fn3 = () => {
    console.log('Cleaning up');
}

const try1 = trier(fn1);

const try1catch1 = trier(fn1, fn2);

const try1catch1finally1 = trier(fn1, fn2, fn3);

try1catch1();

try1catch1finally1();

// throws
try1();
