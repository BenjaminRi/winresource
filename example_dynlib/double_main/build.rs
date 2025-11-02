
fn main() {
    println!("cargo:rerun-if-changed=build.rs");
    winresource::WindowsResource::new().compile().unwrap();
}
