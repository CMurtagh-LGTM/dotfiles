import psutil

usage = round(psutil.virtual_memory()[2])
print(usage)
