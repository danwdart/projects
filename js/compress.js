let tryfunc = (name, num, squashFn, stretchFn, shh) => {
    let nums = [];
    while (0 < num) {
        let squashN = squashFn(num),
            floorSquash = Math.floor(squashN);
            num -= Math.floor(stretchFn(floorSquash));
        nums.push(floorSquash);
    }
    let intFinalEntropy = 0;
    for (let number of nums) {
        intFinalEntropy += Math.ceil(1 >= number?1:Math.log2(number));
    }
    console.log('Naive', name, 'method:',nums.length, 'elements', ((shh)?'':nums), 'with entropy', intFinalEntropy);
};

let prifact = function(num) {
  let root = Math.sqrt(num),
  result = arguments[1] || [],  //get unnamed paremeter from recursive calls
  x = 2;

  if(num % x){//if not divisible by 2
   x = 3;//assign first odd
   while((num % x) && ((x = x + 2) < root)){}//iterate odds
  }
  //if no factor found then num is prime
  x = (x <= root) ? x : num;
  result.push(x);//push latest prime factor

  //if num isn't prime factor make recursive call
  return (x === num) ? result : prifact(num/x, result) ;
}

console.log('Generating big number');
let intBigNumber = Math.floor(Math.random() * (Number.MAX_SAFE_INTEGER));
console.log('Number is', intBigNumber, 'entropy is', Math.ceil(Math.log2(intBigNumber)), 'bits');
tryfunc('Square', intBigNumber, Math.sqrt, (n)=>n**2);
tryfunc('Cube', intBigNumber, (n)=>n**(1/3), (n)=>n**3);
tryfunc('Tesseract', intBigNumber, (n)=>n**(1/4), (n)=>n**4);
tryfunc('Quintic HyperCube', intBigNumber, (n)=>n**(1/5), (n)=>n**5, true);
tryfunc('Power6 HyperCube', intBigNumber, (n)=>n**(1/6), (n)=>n**6, true);
tryfunc('Power7 HyperCube', intBigNumber, (n)=>n**(1/7), (n)=>n**7, true);
tryfunc('Power8 HyperCube', intBigNumber, (n)=>n**(1/8), (n)=>n**8, true);
tryfunc('Power9 HyperCube', intBigNumber, (n)=>n**(1/9), (n)=>n**9, true);
tryfunc('Power10 HyperCube', intBigNumber, (n)=>n**(1/10), (n)=>n**10, true);
tryfunc('Log', intBigNumber, Math.log, Math.exp);
let facts = prifact(intBigNumber);
let intTotalEnt = 0;
for (let num of facts) {
    intTotalEnt += Math.ceil(Math.log2(num));
}
console.log('Prime factors:', facts.length, 'elements:', facts, 'with entropy', intTotalEnt);
tryfunc('Triangle', intBigNumber, (n) => ((8*n+1)**(1/2)-1)/2, (n) => (n*(n+1)/2))
