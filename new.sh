#!/bin/bash

filename="posts/$(date +%Y/%m)/$1.mdx"

[[ -f $filename ]] && echo "File [$filename] exists" && exit 1

mkdir -p "$(dirname "$filename")"

echo "---
title: $1
date: $(date -Iseconds)
tags:
-   
---



<Excerpt />

" > "$filename"

$EDITOR "$filename"
