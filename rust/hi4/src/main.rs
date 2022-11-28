fn main() {
    let v = vec![1, 2, 3, 4, 5];
    let w = vec![1; 3];

    let z: usize = 1;

    println!("{}, {}", v[z], w[z]);

    for i in &v {
        println!("{}", i);
    }
}
