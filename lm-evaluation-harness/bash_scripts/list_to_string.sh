#!/bin/bash

# Take all arguments as a list of values
values=("$@")

# Join them into a string of integers inside brackets
output="["
for ((i=0; i<${#values[@]}; i++)); do
    output+="${values[i]}"
    if (( i < ${#values[@]} - 1 )); then
        output+=", "
    fi
done
output+="]"

echo "$output"