import argparse
import os.path as path
import subprocess

import requests

parser = argparse.ArgumentParser(
    description="Downloads a file from the internet to a temporary folder and runs the given program"
)
parser.add_argument(
    "program",
    help="The program you want to run, with `{}` where you want the file in the arguments",
    type=str,
)
parser.add_argument("file_url", help="The file to pass to the program")

args = parser.parse_args()

local_path = path.join("/tmp", args.file_url.split("/")[-1].split("?")[0])

with requests.get(args.file_url) as res:
    res.raise_for_status()
    with open(local_path, "wb") as f:
        for chunk in res.iter_content(chunk_size=8192):
            f.write(chunk)

subprocess.run(args.program.format(local_path).split(" "))
