#!/usr/bin/env python

import psutil

usage = round(psutil.cpu_percent(interval=1))
print(usage)
