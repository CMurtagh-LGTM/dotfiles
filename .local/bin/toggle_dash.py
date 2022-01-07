#!/usr/bin/env python

import os
import subprocess

windows = (
    subprocess.check_output(["eww", "windows"])
    .decode("utf-8")
    .split("\n")
)[:-1]

subprocess.run(["leftwm-command", "'ToggleScratchPad notes'"])

for window in windows:
    if "dash" in window:
        if window.startswith("*"):
            subprocess.run(["eww", "close", window[1:]])
        else:
            subprocess.run(["eww", "open", window])
