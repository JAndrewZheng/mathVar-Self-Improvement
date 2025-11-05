from aime_results_processor import process_results
import argparse
import os
import pandas as pd
from typing import List, Union
from collections import Counter
from math import log2
import matplotlib.pyplot as plt
import numpy as np

def setup_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser()
    parser.add_argument("--samples" , help="Path to the sample responses. If not given, assumes that the data exists in the output path", type=str, required=True)
    parser.add_argument("--output_path", help="Where to return the evaluated responses", type=str)
    return parser

def entropy(answers: List[Union[int, str]]) -> float:
    total = len(answers)
    counts = Counter(answers)
    entropy = 0
    for val, count in counts.items():
        if val != "N/A":
            entropy += (count/total) * log2(count/total)
        # else:
        #     entropy += count * (1/total) * log2(1/total)

    if entropy != 0:
        entropy = -entropy
    
    return entropy

def get_color(freq: int) -> str:
    colors = ["darkblue"]

    return "not implemented yet"

def main():

    parser: argparse.ArgumentParser = setup_parser()
    args = parser.parse_args()

    if not args.output_path:
        args.output_path = os.path.dirname(args.samples)

    # Read in responses
    df = pd.read_json(args.samples, lines=True)

    res = {}
    for i, responses in enumerate(df["resps"]): # Didn't want to change existing code necessary for other inferences
        res[i+1] = process_results(responses[0])

    print(res)
    print(list(df["target"]))

    # Input the response data
    out_df = {}
    for i in range(10):
        out_df[f"Model Answer #{str(i+1)}"] = [val[i] for val in res.values()]

    targets = list(df["target"])
    out_df["Target Answer"] = targets
    
    # Calculate num of correct answers
    num_correct = []
    for i, answers in enumerate(res.values()):
        correct = 0
        for answer in answers:
            if str(answer) == str(targets[i]):
                correct += 1
        num_correct.append(correct)

    out_df["Num Correct"] = num_correct
    out_df["Entropy"] = [entropy(answers) for answers in res.values()]

    out_df = pd.DataFrame(out_df)
    out_df.to_csv("outputs.csv")

    # Plot Number of Answers Correct vs. Entropy
    fig, ax = plt.subplots(figsize=(8, 6))
    ax.set_xlabel("Answers Correct", fontsize=15)
    ax.set_ylabel("Entropy", fontsize=15)

    pairs = list(zip(out_df["Num Correct"], out_df["Entropy"] ))
    counts = Counter(pairs)
    freqs = np.array([counts[(xi, yi)] for xi, yi in pairs])

    colors = ["blue", "green", "red"]
    for i, freq in enumerate(set(counts.values())):
        print("i freq", i, freq)
        pairs = [item for (item, value) in counts.items() if value == freq]
        x_vals, y_vals = zip(*pairs)
        ax.scatter(x_vals, y_vals, color=colors[i], label=str(freq))

    ax.legend(title="Frequency")
    fig.savefig("correct_answers_vs_entropy.png")

if __name__ == "__main__":
    main()