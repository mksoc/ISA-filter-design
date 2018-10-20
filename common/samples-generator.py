import sys
import random

# read parameters and check correctness
usageMsg = "Usage: samples-generator.py random|special [number_of_samples]"
mode = []

if len(sys.argv) < 2:
    print("Error. Not enough input arguments")
    print(usageMsg)
    sys.exit(1)
elif 2 <= len(sys.argv) <= 3:
    if sys.argv[1] == "random":
        mode = "random"
    elif sys.argv[1] == "special":
        mode = "special"
    else:
        print("Error. Invalid option.")
        print(usageMsg)
        sys.exit(1)

    if len(sys.argv) == 3:
        try:
            samples = int(sys.argv[2])
        except ValueError:
            print("Error. Invalid option.")
            print(usageMsg)
            sys.exit(1)
    else:
        samples = 201 # same number as Matlab samples
else:
    print("Error. Invalid options.")
    print(usageMsg)
    sys.exit(1)

# generate samples
NB = 12
print("Generating samples...")

with open('py-samples.txt', 'w') as outFile:
    for i in range(samples):
        if mode == "random":
            outFile.write('{}\n'.format(random.randint(-2**(NB-1) + 1, 2**(NB-1) - 1)))
        elif mode == "special":
            outFile.write('{}\n'.format(random.choice([0, -2**(NB-1) + 1, 2**(NB-1) - 1])))
        else:
            print("Error. Unknown error. Exiting.")
            sys.exit(1)
print("Done.")