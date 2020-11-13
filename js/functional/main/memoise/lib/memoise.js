export const memoise = f => {
    const map = new Map();
    return x => {
        if (map.has(x)) {
            return map.get(x);
        }
        const result = f(x);
        map.set(x, result);
        return result;
    };
};

// these are much bigger point-free
export const binaryMemoise = f => memoise(g => memoise(f(g)));
export const ternaryMemoise = f => memoise(g => memoise(h => memoise(f(g)(h))));