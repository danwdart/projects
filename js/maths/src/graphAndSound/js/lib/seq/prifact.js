export function prifact(num, result = []){
    var root = Math.sqrt(num),
        x = 2; 

    if(num % x){//if not divisible by 2 
        x = 3;//assign first odd
        while((num % x) && ((x = x + 2) < root)){
            //nothing
        }//iterate odds
    }
    //if no factor found then num is prime
    x = (x <= root) ? x : num;
    result.push(x);//push latest prime factor

    //if num isn't prime factor make recursive call
    return (x === num) ? result : prifact(num/x, result) ;
}