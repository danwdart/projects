const thenMonad = x => ({
    then: fn => thenMonad(fn(x))
});

const foo = x => x + 1;

(async () => {
    const one = thenMonad(1).then(foo); // await says "get value"
    const two = foo(await one); // call self map to call monad's map! Same thing essentially.
    console.log(two);
})();