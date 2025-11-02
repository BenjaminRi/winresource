
const VFT_DLL : u64 = 0x02;

fn main() {
    println!("cargo:rerun-if-changed=build.rs");
    winresource::WindowsResource::new()
    .set_version_info(winresource::VersionInfo::FILETYPE, VFT_DLL)
    .compile().unwrap();
}
