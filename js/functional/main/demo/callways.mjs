/*eslint-disable cleanjs/no-unused-expression*/
/*eslint-disable cleanjs/no-new*/

// Original (impure)
console.log(new Date);

// Pass in

((log, date) => log(date))(console.log, new Date);

// Curried
(x => y => x(y))(console.log)(new Date);

// Call later
(console.log)((() => new Date())());

// Re-jigged
(x => y => x(y()))(console.log)(() => new Date);