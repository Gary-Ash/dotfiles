#!/usr/bin/env zsh
#*****************************************************************************************
# blog-post.sh
#
# This script is used to create blog post.
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :  18-Aug-2023  8:10pm
# Modified :  17-Nov-2023  3:13pm
#
# Copyright © 2023 By Gee Dbl A All rights reserved.
#*****************************************************************************************

if [[ $# -ne 3 ]]; then
	echo 'Command error - expected  <blog or product> base filename "Blog entry title"' 1>&2
	exit 2
fi
if [[ $1 != "blog" && $1 != "products" ]]; then
	echo "unknown website entry type." 1>&2
	echo 'Command error - expected  <blog or product> base filename "Blog entry title"' 1>&2
	exit 2
fi

mkdir -p "$HOME/Sites/geedbla/blog" &>/dev/null
mkdir -p "$HOME/Sites/geedbla/product" &>/dev/null

dateStamp=$(date +"%Y-%m-%d-%H%M%S%z")
timestamp=$(date +"%Y-%m-%d %H:%M:%S %z")
cat <<EOF >"$HOME/Sites/geedbla/$1/$dateStamp-$2.markdown"
---
layout: $1-post
title:  "$3"
date:   $timestamp
collection: $1
permalink: /$1
---
EOF
