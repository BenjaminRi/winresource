extern crate winresource;

fn main() {
    if std::env::var("CARGO_CFG_TARGET_OS").unwrap() == "windows" {
        let mut res = winresource::WindowsResource::new();
        res.set_icon("icon.ico")
            .set_language(0x0409)
            .set_manifest_file("manifest.xml");
        res.compile().unwrap();
    }
}
