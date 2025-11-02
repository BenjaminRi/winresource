fn main() {
    println!("Hello, world!");
    let x = dbg!(double_driver::add(1,2));
    println!("The result is: {}", x);
}
