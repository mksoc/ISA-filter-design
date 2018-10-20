from sys import argv
from random import randint

# check if the number of samples is passed, otherwise use default
if len(argv) == 2:
    samples = int(argv[1])
else:
    samples = 201 # same number as Matlab samples

NB = 12
with open('py-samples.txt', 'w') as outFile:
    for i in range(samples):
        outFile.write('{}\n'.format(randint(-2**(NB-1) - 1, 2**(NB-1) - 1)))