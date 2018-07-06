export const eq = (a) => (b) => a === b;
export const multiplyTwo = (a) => (b) => a * b;
export const sumTwo = (a) => (b) => a + b;
export const div = (a) => (b) => a / b;
export const mod = (a) => (b) => a % b;
export const cmp = (a) => (b) => (c) => c ? a : b;
export const pred = sumTwo(-1);
export const succ = sumTwo(1);
