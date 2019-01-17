// Because B = λabc.a(bc), we can traverse and match to break down composes.

const B = f => g => x => f(g(x));
const B2 = B(B);
const B3 = B2(B);

const explainFunctions = fn => {
    const fnr = fn(() => {});
    console.log([fn, fnr]);
    try {
        return [
            fnr instanceof Function ?
                [
                    explainFunctions(fnr)
                ]:
                []
        ];
    } catch (err) {
        console.error(err.message);
        return [];
    }
};

console.log(JSON.stringify({B: explainFunctions(B)}));
console.log(JSON.stringify({B2: explainFunctions(B2)}));
console.log(JSON.stringify({B3: explainFunctions(B3)}));