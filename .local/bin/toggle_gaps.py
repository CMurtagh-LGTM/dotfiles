#!/usr/bin/env python3
import os.path
import subprocess

import fasteners

MODE_FILE = "/tmp/leftwm_modes.txt"
LOCK_FILE = MODE_FILE + ".lock"

TAG_COUNT = 20
WORKSPACE_COUNT = 3

tag_workspace = subprocess.check_output(["leftwm-state", "-q", "-t", ".config/leftwm/focused_tag.liquid"]).decode("utf-8").split(",")

tag = int(tag_workspace[0])
workspace = int(tag_workspace[1])

lock = fasteners.InterProcessLock(LOCK_FILE)

with lock:
    if not os.path.exists(MODE_FILE):
        with open(MODE_FILE, "x") as f:
            for _ in range(TAG_COUNT * WORKSPACE_COUNT):
                f.write("1\n")

    with open(MODE_FILE, "r") as f:
        data = f.readlines()

    if data[tag + TAG_COUNT*workspace] == "1\n":
        subprocess.run('leftwm-command "SetMarginMultiplier 0"', shell=True)
        data[tag + TAG_COUNT*workspace] = "0\n"
    elif data[tag + TAG_COUNT*workspace] == "0\n":
        subprocess.run('leftwm-command "SetMarginMultiplier 1"', shell=True)
        data[tag + TAG_COUNT*workspace] = "1\n"

    with open(MODE_FILE, "w") as f:
        f.writelines(data)
