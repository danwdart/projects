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

Array.prototype.sum = function() {
    var ret = 0;
    for (var i = 0; i < this.length; i++) {
        ret += this[i];
    }
    return ret;
}

var sumfact = function(i) {
    var thistime = i, lasttime = null;
    while (thistime !== lasttime) {
        lasttime = thistime;
        thistime = prifact(lasttime).sum();
    }

    return thistime;
};
