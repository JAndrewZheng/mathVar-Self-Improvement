#!/usr/bin/bash

# This file represents the entire pipeline of saving a fail into the system

# Given an output directory and output file, construct the output path.
if [ $# -ne 2 ]; then
    echo "File requires an output directory and output file but at least one not given!!!!"
    exit 125
fi

out_dir=$1
out_file=$2

# Cover all the cases where invalid inputs are given \
    # 1: Both are directories
    # 2: Both are not directories (Both are files)

if ([ -d $out_file ] && [ -d $out_dir ]); then
    echo "Im here 1"
elif ! ([ -d $out_file ] || [ -d $out_dir ]); then
    echo "Im here 2"
fi

if ([ -d $out_file ] && [ -d $out_dir ]) || ! ([ -d $out_file ] || [ -d $out_dir ]); then
    echo "Valid inputs were not given!!!!!"
    exit 125
elif [ -d $out_file ]; then
    temp=$out_dir
    out_dir=$out_file
    out_file=$temp
fi

output="${out_dir}${out_file}"
echo $output