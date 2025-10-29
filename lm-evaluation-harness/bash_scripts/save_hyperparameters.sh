#!/usr/bin/bash

hyperparameters=$1
output_dir=$2
output_file="hyperparameters.txt"

output_path=$(sh bash_scripts/save-output.sh $output_file $output_dir)

echo "Im here now"
echo -e $hyperparameters
echo -e $output_dir
echo -e $hyperparameters &> $output_path