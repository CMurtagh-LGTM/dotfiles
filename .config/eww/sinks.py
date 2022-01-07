import re
import subprocess


raw = subprocess.run(["pactl", "list", "short", "sinks"], check=True, capture_output=True).stdout.decode("utf-8")

long = raw.split("\n")[:-1]
names = [n.split("\t")[1].split(".")[-1] for n in long]
statuses = [s.split("\t")[-1] for s in long]
indices = [i.split("\t")[0] for i in long]

sinks_yuck = "(box :class 'sinks' :orientation 'v'"
for status, name, index in zip(statuses, names, indices):
    if status == "RUNNING":
        sinks_yuck += f"(button :class 'sinks_button' :halign 'start' '⦿ {name}')"
    else:
        sinks_yuck += f"(button :class 'sinks_button' :onclick 'pactl set-default-sink {index}' :halign 'start' '⦾ {name}')"
sinks_yuck += ")"
print(sinks_yuck)
