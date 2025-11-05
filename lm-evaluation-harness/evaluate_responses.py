from lm_eval.tasks.aime.utils import process_results
import argparse
import os
import pandas as pd

def setup_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser()
    parser.add_argument("--samples" , help="Path to the sample responses. If not given, assumes that the data exists in the output path", type=str, required=True)
    parser.add_argument("--output_path", help="Where to return the evaluated responses", type=str)
    return parser

def main():

    parser: argparse.ArgumentParser = setup_parser()
    args = parser.parse_args()

    if not args.output_path:
        args.output_path = os.path.dirname(args.samples)

    # Read in responses
    df = pd.read_json(args.samples, lines=True)

    res = {}
    for responses in df["resps"]: # Didn't want to change existing code necessary for other inferences
        curr = []
        for response in responses: 
            curr.append(process_results()


    
if __name__ == "__main__":
    main()