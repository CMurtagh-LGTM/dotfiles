#!/usr/bin/env python

import subprocess
import sys
import os
import json

DB_FILE = os.path.expanduser("~/.cache/ddgr-search.db")
open(DB_FILE, "a").close()  # make sure our db file exists

rofi_retv = int(os.environ["ROFI_RETV"])
if rofi_retv == 0:
    # 1st call
    history_raw = subprocess.run(
        ["/usr/bin/frece", "print", DB_FILE], capture_output=True
    ).stdout.decode("UTF-8")
    history = json.loads("[" + ",".join(f"{history_raw}".split("\n"))[1:-2] + "]")
    print("\0delim\x1f\x1e")
    print(
        "".join(
            [
                f"{result['title']}\n{result['url']}\n{result['abstract']}\0info\x1f{json.dumps(result,ensure_ascii=False)}\x1e"
                for result in history
            ]
        ),
        end="",
    )
else:
    try:
        # Selected a website
        info = os.environ["ROFI_INFO"]
        info_json = json.loads(info)
        try:
            subprocess.run(["/usr/bin/frece", "add", DB_FILE, f'"{info}"'])
        except Exception as e:
            sys.stderr.write(e.__str__())
        subprocess.run(["/usr/bin/frece", "increment", DB_FILE, f'"{info}"'])
        subprocess.Popen(["/usr/bin/librewolf", info_json["url"]])
    except:
        # Searched a term
        results = json.loads(
            subprocess.run(
                ["/usr/bin/ddgr", "--json", sys.argv[1]], capture_output=True
            ).stdout
        )
        print(
            "".join(
                [
                    f"{result['title']}\n{result['url']}\n{result['abstract']}\0info\x1f{json.dumps(result, ensure_ascii=False)}\x1e"
                    for result in results
                ]
            ),
            end="",
        )
