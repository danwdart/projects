import {compose} from './functional';

export const chain = x => ({
    map: f => chain(f(x)),
    value: x
});

export const lazyChain = (x, f = null) => ({
    map: g => lazyChain(x, f ? compose(g)(f) : g),
    value: () => f ? f(x) : x
});