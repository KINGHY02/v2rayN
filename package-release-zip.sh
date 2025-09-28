#!/bin/bash

Arch="$1"
OutputPath="$2"

OutputArch="KiNG-${Arch}"
FileName="KiNG-${Arch}.zip"

wget -nv -O $FileName "https://github.com/2dust/v2rayN-core-bin/raw/refs/heads/master/v2rayN-${Arch}.zip"

ZipPath64="./$OutputArch"
mkdir $ZipPath64

cp -rf $OutputPath "$ZipPath64/$OutputArch"
7z a -tZip $FileName "$ZipPath64/$OutputArch" -mx1