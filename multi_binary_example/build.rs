use std::error::Error;

fn main() -> Result<(), Box<dyn Error>> {
    if std::env::var("CARGO_CFG_TARGET_OS").unwrap() == "windows" {
        // Do not do this
        // This will cause the binaries to fail building with the below error:
        // "fatal error CVT1100: duplicate resource"

        // let lib_res = tauri_winres::WindowsResource::new();
        // lib_res.compile()?;

        // Binary target with name "a"
        let mut a_res = winresource::WindowsResource::new();
        a_res.set("FileDescription", "multi_binary_example - example A");
        a_res.compile_for("a")?;

        // Binary target with name "example-b"
        let mut b_res = winresource::WindowsResource::new();
        b_res.set("FileDescription", "multi_binary_example - example B");
        b_res.compile_for("example-b")?;
    }
    Ok(())
}
