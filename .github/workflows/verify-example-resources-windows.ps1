param(
    [Parameter(Mandatory = $true)]
    [string] $Exe
)

$ErrorActionPreference = "Stop"

function Assert-Equal {
    param(
        [string] $Name,
        [string] $Expected,
        [string] $Actual
    )

    if ($Actual -ne $Expected) {
        throw "$($Name): expected '$($Expected)', got '$($Actual)'"
    }
}

$exePath = (Resolve-Path $Exe).Path
$versionInfo = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($exePath)

$fileVersionNumber = "$($versionInfo.FileMajorPart).$($versionInfo.FileMinorPart).$($versionInfo.FileBuildPart).$($versionInfo.FilePrivatePart)"
$productVersionNumber = "$($versionInfo.ProductMajorPart).$($versionInfo.ProductMinorPart).$($versionInfo.ProductBuildPart).$($versionInfo.ProductPrivatePart)"

Assert-Equal "FileVersionNumber" "0.1.4.0" $fileVersionNumber
Assert-Equal "ProductVersionNumber" "0.1.4.0" $productVersionNumber
Assert-Equal "FileDescription" "Winresource Example" $versionInfo.FileDescription
Assert-Equal "FileVersion" "0.1.4" $versionInfo.FileVersion
Assert-Equal "LegalCopyright" "Copyright © 2016-2024" $versionInfo.LegalCopyright
Assert-Equal "ProductName" "winresource-example" $versionInfo.ProductName
Assert-Equal "ProductVersion" "0.1.4" $versionInfo.ProductVersion

Add-Type -Namespace Win32 -Name NativeMethods -MemberDefinition @"
[System.Runtime.InteropServices.DllImport("kernel32.dll", SetLastError=true, CharSet=System.Runtime.InteropServices.CharSet.Unicode)]
public static extern System.IntPtr LoadLibraryEx(string lpFileName, System.IntPtr hFile, uint dwFlags);

[System.Runtime.InteropServices.DllImport("kernel32.dll", SetLastError=true)]
public static extern System.IntPtr FindResource(System.IntPtr hModule, System.IntPtr lpName, System.IntPtr lpType);

[System.Runtime.InteropServices.DllImport("kernel32.dll", SetLastError=true)]
public static extern bool FreeLibrary(System.IntPtr hModule);
"@

$LOAD_LIBRARY_AS_DATAFILE = 0x00000002
$module = [Win32.NativeMethods]::LoadLibraryEx($exePath, [IntPtr]::Zero, $LOAD_LIBRARY_AS_DATAFILE)
if ($module -eq [IntPtr]::Zero) {
    throw "failed to load EXE resources from $exePath"
}

try {
    $groupIcon = [Win32.NativeMethods]::FindResource($module, [IntPtr] 1, [IntPtr] 14)
    $icon = [Win32.NativeMethods]::FindResource($module, [IntPtr] 1, [IntPtr] 3)

    if ($groupIcon -eq [IntPtr]::Zero) {
        throw "missing RT_GROUP_ICON resource"
    }
    if ($icon -eq [IntPtr]::Zero) {
        throw "missing RT_ICON resource"
    }
} finally {
    [void] [Win32.NativeMethods]::FreeLibrary($module)
}

Write-Host "$($Exe): Windows version info and icon resources are present"
