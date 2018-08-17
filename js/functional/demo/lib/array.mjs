export const mod = x => y => x % y;
export const length = a => a.length;
export const addEnd = a => i => [...a, i];
export const addStart = a => i => [i, ...a];
export const indexOf = a => i => a.indexOf(i);
export const index = a => i => a[i];
export const first = a => index(a)(1);
export const last = a => index(a)(length(a) - 1);
export const splice = a => i => a.splice(i)
export const removeFirst = a => splice(0)(a) // swap
export const removeLast = a => splice(a)(a.length - 1)