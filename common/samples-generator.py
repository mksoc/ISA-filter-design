#! /usr/bin/python3
from sys import exit
import random

# define possible modes
modes = {1:"Random", 2:"Special (only 0 and extremes)"}
for key, value in modes.items():
    print("{} - {}".format(key, value))

# prompt user for mode selection
try:
    mode = int(input("Select the generator mode: "))
except ValueError:
    print("Error. Invalid option.")
    exit(1)
else:
    if not (1 <= mode <= 2):
        print("Error. Invalid option.")
        exit(1)

# prompt user for number of samples
samples = input("Type number of samples (default is 201): ")
if not samples:
    samples = 201
else:
    try:
        samples = int(samples)
    except ValueError:
        print("Error. Invalid option.")
        exit(1)
    else:
        if samples < 0:
            print("Error. Invalid option.")
            exit(1)

# generate samples
NB = 12
print("Generating samples...")

with open('py-samples.txt', 'w') as outFile:
    for i in range(samples):
        if mode == 1:
            outFile.write('{}\n'.format(random.randint(-2**(NB-1) + 1, 2**(NB-1) - 1)))
        elif mode == 2:
            outFile.write('{}\n'.format(random.choice([0, -2**(NB-1) + 1, 2**(NB-1) - 1])))
        else:
            print("Error. Unknown error. Exiting.")
            exit(1)
print("Done.")