export const copy = a => [a, a];
export const consume = _ => null;
export const fst = ([a, _]) => a;
export const snd = ([_, b]) => b;