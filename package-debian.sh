#!/bin/bash

Arch="$1"
OutputPath="$2"
Version="$3"

FileName="v2rayN-${Arch}.zip"
wget -nv -O $FileName "https://github.com/2dust/v2rayN-core-bin/raw/refs/heads/master/v2rayN-${Arch}.zip"
7z x $FileName
cp -rf v2rayN-${Arch}/* $OutputPath

PackagePath="KiNG-Package-${Arch}"
mkdir -p "${PackagePath}/DEBIAN"
mkdir -p "${PackagePath}/opt"
cp -rf $OutputPath "${PackagePath}/opt/KiNG"
echo "When this file exists, app will not store configs under this folder" > "${PackagePath}/opt/KiNG/NotStoreConfigHere.txt"

if [ $Arch = "linux-64" ]; then
    Arch2="amd64" 
else
    Arch2="arm64"
fi
echo $Arch2

# basic
cat >"${PackagePath}/DEBIAN/control" <<-EOF
Package: KiNG
Version: $Version
Architecture: $Arch2
Maintainer: https://github.com/2dust/v2rayN
Depends: desktop-file-utils, xdg-utils
Description: A GUI client for Windows and Linux, support Xray core and sing-box-core and others
EOF

cat >"${PackagePath}/DEBIAN/postinst" <<-EOF
cat >/usr/share/applications/KiNG.desktop<<-END
[Desktop Entry]
Name=KiNG
Comment=A GUI client for Windows and Linux, support Xray core and sing-box-core and others
Exec=/opt/KiNG/KiNG
Icon=/opt/KiNG/KiNG.png
Terminal=false
Type=Application
Categories=Network;Application;
END

update-desktop-database
EOF

sudo chmod 0755 "${PackagePath}/DEBIAN/postinst"
sudo chmod 0755 "${PackagePath}/opt/KiNG/KiNG"
sudo chmod 0755 "${PackagePath}/opt/KiNG/AmazTool"

# Patch
# set owner to root:root
sudo chown -R root:root "${PackagePath}"
# set all directories to 755 (readable & traversable by all users)
sudo find "${PackagePath}/opt/KiNG" -type d -exec chmod 755 {} +
# set all regular files to 644 (readable by all users)
sudo find "${PackagePath}/opt/KiNG" -type f -exec chmod 644 {} +
# ensure main binaries are 755 (executable by all users)
sudo chmod 755 "${PackagePath}/opt/KiNG/KiNG" 2>/dev/null || true
sudo chmod 755 "${PackagePath}/opt/KiNG/AmazTool" 2>/dev/null || true

# build deb package
sudo dpkg-deb -Zxz --build $PackagePath
sudo mv "${PackagePath}.deb" "KiNG-${Arch}.deb"
