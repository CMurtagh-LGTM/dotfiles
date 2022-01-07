import re
import subprocess


raw = subprocess.run(["pactl", "list", "short", "sinks"], check=True, capture_output=True).stdout.decode("utf-8")
default = subprocess.run(["pactl", "get-default-sink"], check=True, capture_output=True).stdout.decode("utf-8")

long = raw.split("\n")[:-1]
names = [n.split("\t")[1].split(".")[-1] for n in long]
indices = [i.split("\t")[0] for i in long]
default = default.split(".")[-1][:-1]

sinks_yuck = "(box :class 'sinks' :orientation 'v'"
for name, index in zip(names, indices):
    if name == default:
        sinks_yuck += f"(button :class 'sinks_button' :halign 'start' '⦿ {name}')"
    else:
        sinks_yuck += f"(button :class 'sinks_button' :onclick 'pactl set-default-sink {index}' :halign 'start' '⦾ {name}')"
sinks_yuck += ")"
print(sinks_yuck)
