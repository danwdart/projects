export const callRest = f => x => f(...x);

//eslint-disable-next-line cleanjs/no-new
export const callNew = cnst => fn => new cnst(fn);

// These two are kind of opposites
//eslint-disable-next-line cleanjs/no-rest-parameters
export const doAndReturn = fn => ([ret, ...stuff]) => void fn(stuff) || ret;
export const passAndDo = fn => something => [something, fn()];