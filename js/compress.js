let tryfunc = (name, num, squashFn, stretchFn) => {
    let nums = [];
    while (0 < num) {
        let squashN = squashFn(num),
            floorSquash = Math.floor(squashN);
            num -= Math.floor(stretchFn(floorSquash));
        nums.push(floorSquash);
    }
    console.log(name+' method had', nums.length, 'elements');
    let intFinalEntropy = 0;
    for (let number of nums) {
        intFinalEntropy += Math.ceil(0 == number?1:Math.log2(number));
    }
    console.log(name+' method:', nums, 'with entropy', intFinalEntropy);
};

console.log('Generating big number');
let intBigNumber = Math.floor(Math.random() * (1<<30));
console.log('Number is', intBigNumber, 'entropy is', Math.ceil(Math.log2(intBigNumber)), 'bits');
console.log('Calculating most efficient packing structure');
console.log('Determining sum of squares method, naive way');
tryfunc('Square', intBigNumber, Math.sqrt, (n)=>n**2);
console.log('Trying cubes');
tryfunc('Cube', intBigNumber, (n)=>n**(1/3), (n)=>n**3);
console.log('Trying tesseract');
tryfunc('Tesseract', intBigNumber, (n)=>n**(1/4), (n)=>n**4);
console.log('Trying log');
tryfunc('Log', intBigNumber, Math.log, Math.exp);
