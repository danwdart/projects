fn transformers(x: u32) -> u32 {
    println!("x is {}, INCREMENTINGS", x);
    x + 1
}

/// # MD??
fn main() {
    println!("Hello, world!");
    
    let input = 12;

    let input = transformers(input);
        
    let f: fn(u32) -> u32 = transformers;
    
    let input = f(input);
    
    let magic = '⋄';
    
    let arr1 = [1,2,3, 4, 5, 6, 7];
    
    let arr1s = &arr1[3..6];
    
    let arr2 = [1; 29];
    
    println!("{}, {}, {:?}, {:?}, {:?}, {}", magic, input, arr1, arr2, arr1s, arr2.len());
    
    let mut x = (1, 2);
    
    println!("Old x {:?}", x);
    
    x = (2, 3);
    
    let (a, b) = x;
    
    println!("{}, {}, {}", a, b, x.1);
    
    
    
    if a == x.0 {
        println!("BOB11!");
    } else {
        println!("Yeah");
    }
    
    let y = if x.0 == 5 { 10 } else { 15 };

    println!("{}", y);
    
    for x in 1..10 {
        println!("{}", x);
    }
    
    for (k, v) in (1..10).enumerate() {
        println!("{} = {}", k, v);
    }
    
    let lines = "Text
        Here
    ".lines();
    
    for (ln, text) in lines.enumerate() {
        println!("{}, {}", ln, text);
    }
}
