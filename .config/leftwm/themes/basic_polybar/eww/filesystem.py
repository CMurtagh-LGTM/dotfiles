#!/usr/bin/env python

import psutil

usage = int(psutil.disk_usage("/")[3])

print(usage)
