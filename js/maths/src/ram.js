let cache = {},
    p = 4;

for (let i = 1; i < 200000; i++) {
    for (let j = 1; j < 200000; j++) {
        let key = i**p + j**p,
            value = cache[key];
            
        if (`undefined` !== typeof value && j !== value[0] && i !== value[1]) {
            console.log(`${i}^${p} + ${j}^${p} is ${value[0]}^${p} + ${value[1]}^${p}`);
            break;
        }

        cache[key] = [i,j];
    }
}
