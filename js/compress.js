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

function prifact(num){
  var root = Math.sqrt(num),
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
console.log('Trying factoring');
let facts = prifact(intBigNumber);
console.log('Prime Factors', facts);
let intTotalEnt = 0;
for (let num of facts) {
    intTotalEnt += Math.ceil(Math.log2(num));
}
console.log('Prime factors entropy is', intTotalEnt);
