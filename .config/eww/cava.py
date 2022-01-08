#!/usr/bin/env python3
import atexit
import os
import random
import signal
import string
import subprocess
import sys

id = "".join(random.choice(string.ascii_lowercase) for i in range(3))

PATH = "/tmp/eww/cava"
PATH = PATH + id
CONFIG = os.path.expanduser("~/.config/eww/cava/")
CONFIG = CONFIG + id
BARS = 20
SKIP = 9
os.makedirs("/tmp/eww", exist_ok=True)

config = f"""[general]
bars = {BARS}
[output]
method = raw
channels = mono
raw_target = {PATH}
data_format = binary
bit_format = 8bit
"""

c = open(CONFIG, "wt")
c.write(config)
c.close()

p = subprocess.Popen(
    ["stdbuf", "-o0", "/usr/bin/cava", "-p", CONFIG], stdout=subprocess.PIPE
)


def cleanup():
    p.terminate()
    os.remove(CONFIG)
    os.remove(PATH)


atexit.register(cleanup)
signal.signal(signal.SIGTERM, cleanup)
signal.signal(signal.SIGINT, cleanup)

str = ""
stdout = p.stdout
if stdout is not None and p.poll() is None:
    str += stdout.read(90).decode("utf-8")
else:
    sys.exit()

fifo = open(PATH, "rb")

while True:
    print([int.from_bytes(fifo.read(1), sys.byteorder)*100//255 for _ in range(BARS)], flush=True)
    [fifo.read(1) for _ in range(BARS * SKIP)]
