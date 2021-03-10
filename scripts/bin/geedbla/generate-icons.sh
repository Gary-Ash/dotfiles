#!/usr/bin/env zsh
#*****************************************************************************************
# generate-icons.sh
#
# Generate app icons images
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  11-Jan-2020  2:23pm
# Modified :   1-Feb-2021 12:55pm
#
# Copyright © 2020-2021 By Gee Dbl A All rights reserved.
#*****************************************************************************************

while IFS= read -r line; do
  icons+=( "$line" )
done <<ICON_SIZES
Icon-16         16
Icon-16@2x      32
Icon-32         32
Icon-32@2x      64
Icon-128        128
Icon-128@2x     256
Icon-256        256
Icon-256@2x     256
Icon-512        512
Icon-512@2x     1024
Icon-20         20
Icon-20@2x      40
Icon-20@3x      60
Icon-29         29
Icon-29@2x      58
Icon-29@3x      87
Icon-40         40
Icon-40@2x      80
Icon-40@3x      120
Icon-60@2x      120
Icon-60@3x      180
Icon-76         76
Icon-76@2x      152
Icon-83.5@2x    167
Icon-1024       1024
Icon-24@2x      48
Icon-27.5@2x    55
Icon-86@2x      172
Icon-98@2x      196
Icon-108@2x     216
Icon-44@2x      88
Icon-50@2x      100
ICON_SIZES


if [[ $# -eq 2 ]]; then
	icon-source="$1"
	directory="$2"
else
	program=$(basename "$0")
	echo "Command syntax error:"
	echo "         $program icon-image-source output-directory"
	exit 1
fi

mkdir -p "$directory"
for e in "${icons[@]}"; do
    file-name=$(echo "$e"|awk '{print $1}')
    size=$(echo "$e"|awk '{print $2}')
    sips -s format png --matchTo '/System/Library/ColorSync/Profiles/sRGB Profile.icc' -z "$size" "$size" "$icon-source" --out "$directory/$file-name.png" &>/dev/null
done
