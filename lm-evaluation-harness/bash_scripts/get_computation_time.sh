#!/usr/bin/bash

# Determine how long a program takes to run, and save it to the output file

# INPUT: Bash script of computations you want to run

start_time=$(date +%s)

# Run the command passed in
$(sh $1) &> $2

end_time=$(date +%s)
total_seconds=$((end_time-start_time))
minutes=$((total_seconds/60))
hours=$((minutes/60))
days=$((hours/24))

echo "Elapsed time: $days days, $((hours % 24)) hours, $((minutes % 60)) minutes, $((total_seconds % 60)) seconds"
