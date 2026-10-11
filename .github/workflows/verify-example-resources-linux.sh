#!/usr/bin/env bash
set -euo pipefail

exe=${1:?usage: verify-example-resources-linux.sh <path-to-exe>}

expect_exif() {
    local tag=$1
    local expected=$2
    local actual

    actual=$(exiftool -s3 "-${tag}" "$exe")
    if [[ "$actual" != "$expected" ]]; then
        echo "${tag}: expected '${expected}', got '${actual}'" >&2
        exit 1
    fi
}

expect_exif FileVersionNumber "0.1.4.0"
expect_exif ProductVersionNumber "0.1.4.0"
expect_exif FileDescription "Winresource Example"
expect_exif FileVersion "0.1.4"
expect_exif LegalCopyright "Copyright © 2016-2024"
expect_exif ProductName "winresource-example"
expect_exif ProductVersion "0.1.4"

if [[ -z $(wrestool --list --type=14 "$exe") ]]; then
    echo "missing RT_GROUP_ICON resource" >&2
    exit 1
fi

if [[ -z $(wrestool --list --type=3 "$exe") ]]; then
    echo "missing RT_ICON resource" >&2
    exit 1
fi

echo "$exe: Windows version info and icon resources are present"
