extern crate rand;

use std::io;
use rand::Rng;
use std::cmp::Ordering;

fn main() {
    loop {
        println!("Hello");
        let mut input = String::new();
    
        io::stdin().read_line(&mut input)
            .expect("Wat");
        
        let input: u32 = match input.trim().parse() {
            Ok(input) => input,
            Err(_) => {
                println!("{} was not a number, you plank.", input.trim());
                continue;
            },
        };
        
        let ran = rand::thread_rng().gen_range(1, 1001);
        
        println!("Twas {}, with rng = {}", input, ran);
        
       
        match input.cmp(&ran) {
            Ordering::Less => println!("Less"),
            Ordering::Greater => println!("Greater"),
            Ordering::Equal => {
                println!("Equal");
                break;
            }
        }
    }
}
