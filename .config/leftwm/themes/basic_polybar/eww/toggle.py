#!/usr/bin/env python

import os
import subprocess

config = os.path.join(os.path.dirname(os.path.realpath(__file__)), "eww.xml")

windows = (
    subprocess.check_output(["eww", "-c", config, "windows"])
    .decode("utf-8")
    .split("\n")
)[:-1]

for window in windows:
    if window.startswith("*"):
        subprocess.run(["eww", "-c", config, "close", window[1:]])
    else:
        subprocess.run(["eww", "-c", config, "open", window])
