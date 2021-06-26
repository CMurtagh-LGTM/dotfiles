#!/usr/bin/env python

import psutil
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("source", help="The source of the temperature")
args = parser.parse_args()

usage = round(psutil.sensors_temperatures()[args.source][0][1])

print(usage)
