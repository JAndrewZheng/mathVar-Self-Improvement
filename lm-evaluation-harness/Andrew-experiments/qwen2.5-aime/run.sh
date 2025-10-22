#!/bin/bash

lm_eval --model hf \
    --model_args pretrained=Qwen/Qwen2.5-Math-7B \
    --tasks aime \
    --device cuda:0 \
    --batch_size 8 \
    --num_fewshot 0 \
    --apply_chat_template \
    --fewshot_as_multiturn \
    --gen_kwargs '{"max_gen_toks": 2048}'
