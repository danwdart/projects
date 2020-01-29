// Old way

with({a: 1})(console.log(a * a));

// New way

console.log((({a}) => a * a)({a:1}));
