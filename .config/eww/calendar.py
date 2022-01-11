import itertools
import subprocess


def grouper(iterable, n, fillvalue=None):
    """Collect data into non-overlapping fixed-length chunks or blocks."""
    # grouper('ABCDEFG', 3, 'x') --> ABC DEF Gxx
    args = [iter(iterable)] * n
    return itertools.zip_longest(*args, fillvalue=fillvalue)


# Obtain the calendar events
calendar_str = subprocess.run(
    [
        "calcurse",
        "-r30",
        "--format-apt=%S\n%m\n",
        "--format-event=*\n%m\n",
        "--format-todo=TODO %p\n%m\n",
        "--output-datefmt=%d/%m/%Y",
    ],
    check=True,
    capture_output=True,
).stdout.decode("utf-8")

calendar = [event.rstrip().split("\n", 1) for event in calendar_str.split("\n\n")]

calendar_yuck = "(box :orientation 'v' :class 'calendar'"

for events in grouper(calendar[:8], 2, ["", ""]):
    calendar_yuck += "(box :orientation 'h'"
    for event in events:
        calendar_yuck += f"(box :orientation 'v' :class 'calendar_entry' (box :class 'calendar_date' '{event[0]}') (box :class 'calendar_text' '{event[1]}'))"
    calendar_yuck += ")"

calendar_yuck += ")"

print(calendar_yuck, flush=True)
