#!/bin/bash

# Define parameters:
model="hf"
model_args="pretrained=deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B"
tasks="aime24" 
device="cuda"
batch_size=8
num_fewshot=0
gen_kwargs='{"max_gen_toks": 2048, "temperature": 0.6, "top_p": 0.95}'
num_gpus=1

currtime=$(date +%Y-%m-%d/%H:%M:%S)
# output_dir="/Users/andrewzheng/Documents/Product-Formula-Bounds/outputs/$currtime/"

# Specify where the output of the file should be returned
output_file="std_out.txt"

# Record the starting time
start_time=$(date +%s)

parameter_str="model=$model\n
    guard=$guard\n
    repeats=$repeats"

echo $parameter_str
# Save hyperparameters
sh bash_scripts/save_hyperparameters.sh "$parameter_str" "$output_dir"

output_dir="./logs/$currtime/"
mkdir -p $output_dir

# Produce the output file and create the path
output_path=$(sh bash_scripts/save-output.sh $output_file $output_dir)

# Run evaluation script
torchrun --nproc_per_node $num_gpus \
    lm_eval --model $model \
    --model_args $model_args \
    --tasks $tasks \
    --device $device \
    --batch_size $batch_size \
    --num_fewshot $num_fewshot \
    --apply_chat_template \
    --fewshot_as_multiturn \
    --output_path $output_dir \
    --gen_kwargs "$gen_kwargs" \
    --log_samples \
    &> $output_path

# lm_eval --model hf \
#     --model_args pretrained=deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B \
#     --tasks aime24 \
#     --device cuda:0 \
#     --batch_size 8 \
#     --num_fewshot 0 \
#     --apply_chat_template \
#     --fewshot_as_multiturn \
#     --gen_kwargs '{"max_gen_toks": 32768, "temperature": 0.6, "top_p": 0.95}'

# Record the ending time
end_time=$(date +%s)
total_seconds=$((end_time-start_time))
minutes=$((total_seconds/60))
hours=$((minutes/60))
days=$((hours/24))

currtime=$(date +%Y-%m-%d/%H:%M:%S)
echo "Elapsed time: $days days, $((hours % 24)) hours, $((minutes % 60)) minutes, $((total_seconds % 60)) seconds"