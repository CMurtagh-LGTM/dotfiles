#!/usr/bin/env python

import psutil
import json

print(json.dumps({k:round(v[0][1]) for k, v in psutil.sensors_temperatures().items()}))
