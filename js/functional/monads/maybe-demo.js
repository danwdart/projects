const Maybe = x => ({
    // this would be a type in a typed language tbh like Maybe<Nothing>
    map: fn => undefined === x ? Maybe(undefined) : Maybe(fn(x)),
    value: x
});
Maybe.Nothing = Maybe(undefined);
Maybe.Just = m => m.value;

const addThree = x => x + 3;
const dieIfNine = x => x === 9 ? undefined : x;

console.log(
    Maybe(3)
        .map(addThree)
        .map(addThree)
        .map(dieIfNine)
        .map(addThree)
        .map(addThree)
        .value
);