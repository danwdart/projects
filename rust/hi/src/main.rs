fn bug(x: V2) -> V2 {
    x
}

#[derive(Debug)]
struct V2 {
    x: f32,
    y: f32
}

fn main() {
    let borb = V2{x:3.,y:9.};
    let l = |x| {
        x
    };

    let bob = 25.;
    //bug(borb);
    println!("borb {}", l(bob));
    println!("borb {:?}", borb);
}
