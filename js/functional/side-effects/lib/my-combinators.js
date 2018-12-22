export const callRest = f => x => f(...x);

export const callNew = cnst => fn => new cnst(fn);

// These two are kind of opposites
export const doAndReturn = fn => ([ret, ...stuff]) => void fn(stuff) || ret;
export const passAndDo = fn => something => [something, fn()];