# winresource

A simple library to facilitate adding [Resources](https://en.wikipedia.org/wiki/Resource_(Windows)) (metainformation and icons) to [Portable Executables](https://en.wikipedia.org/wiki/Portable_Executable) (Windows executables and dynamic libraries).

Note: `winresource` is a fork of [winres](https://github.com/mxre/winres) which no longer works on Rust 1.61 or higher and has been [left unmaintained](https://github.com/mxre/winres/issues/40).

[Documentation](https://docs.rs/winresource/*/winresource/)

## Toolkit

Before we begin you need to have the appropriate tools installed.
 - `rc.exe` from the [Windows SDK]
 - `windres.exe` and `ar.exe` from [minGW64]
 
[Windows SDK]: https://developer.microsoft.com/en-us/windows/downloads/windows-10-sdk
[minGW64]: http://mingw-w64.org

If you are using Rust with the MSVC ABI you will need the Windows SDK for the GNU ABI you'll need minGW64.

Windows SDK can be found in the registry, minGW64 has to be in the path.

## Using winresource

First, you will need to add a build script to your crate (`build.rs`) by adding it to your crate's `Cargo.toml` file:

```toml
[package]
#...
build = "build.rs"

[build-dependencies]
winresource = "0.1"
```

Next, you have to write a build script. A short example is shown below.

```rust
// build.rs

extern crate winresource;

fn main() {
    if std::env::var("CARGO_CFG_TARGET_OS").unwrap() == "windows" {
        let mut res = winresource::WindowsResource::new();
        res.set_icon("test.ico");
        res.compile().unwrap();
    }
}
```

That's it. The file `test.ico` should be located in the same directory as `build.rs`. Metainformation (like program version and description) is taken from `Cargo.toml`'s `[package]` section.

Please note: Using `#[cfg(target_os = "windows")]` in `build.rs` may not work as expected because `build.rs` is executed on the host. This means that `target_os` is always equal to `host_os` when compiling `build.rs`. E.g. if we use `rustc` on Linux and want to cross-compile binaries that run on Windows, `target_os` in `build.rs` is `"linux"`. However, `CARGO_CFG_TARGET_OS` should always be defined and contains the actual target operating system, though it can only be checked at runtime of the build script.

## Additional Options

For added convenience, `winresource` parses `Cargo.toml` for a `package.metadata.winresource` section:

```toml
[package.metadata.winresource]
OriginalFilename = "PROGRAM.EXE"
LegalCopyright = "Copyright © 2016"
#...
```

This section may contain arbitrary string key-value pairs, to be included in the version info section of the executable/library file.

The following keys have special meanings and will be shown in the file properties of the Windows Explorer:

`FileDescription`, `ProductName`, `ProductVersion`, `OriginalFilename` and `LegalCopyright`

See [MSDN] for more details on the version info section of executables/libraries.

[MSDN]: https://msdn.microsoft.com/en-us/library/windows/desktop/aa381058.aspx

## About this project

The [original author](https://github.com/mxre) and maintainers use this crate for their personal projects and although is has been tested in that context, we have no idea if the behaviour is the same everywhere.

To be brief, we are very much reliant on your bug reports and feature suggestions to make this crate better.
