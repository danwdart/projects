const Case = conditions =>
    input => {
        const out = Object.entries(conditions).filter(x => x[0] === input);
        return out[0] ? out[0][1] : null;
    };

const cased = Case({a:1, b:2});

console.log(cased('b'), cased('c'));