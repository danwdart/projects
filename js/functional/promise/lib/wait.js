// Note that this is the same as apply() but with fewer arguments
export const wait = x => () => x();
// and these are similar wait()y functions as above.
// These could be rewritten as swaps but really what's the need...
export const waitApply = x => y => () => x(y);
export const waitApplyTo = y => x => () => x(y);