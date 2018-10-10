import sys

# check if both files are given as arguments
if len(sys.argv) != 3:
    print('Error: not enough input arguments.')
    print('Usage: python compare-ouputs.py <file1> <file2>')
    sys.exit(1)

# read file1
with open(sys.argv[1], 'r') as file1:
    file1Data = []
    for line in file1:
        line = line.split()
        line = [int(i) for i in line]
        file1Data += line

# read file2
with open(sys.argv[2], 'r') as file2:
    file2Data = []
    for line in file2:
        line = line.split()
        line = [int(i) for i in line]
        file2Data += line

# compare number by number the two outputs
matchCounter = 0
errorLines = []
for i, j in zip(file1Data, file2Data):
    if i == j:
        matchCounter += 1
    else:
        errStr = "Error at line {}".format(file2Data.index(j))
        # save lines that generated an error
        errorLines.append(file2Data.index(j))
        print(errStr)

# print results
outStr = "Total matches: {}/{} ({}%)".format(matchCounter, len(file2Data), 100*matchCounter/len(file2Data))
print(outStr)
if matchCounter == len(file2Data):
    print("Yeeeeee!!!")

# save samples that generate errors
if errorLines:
    i = 0
    with open('samples.txt', 'r') as inputs:
        with open('error_samples.txt', 'w') as errFile:
            for line in inputs:
                if i in errorLines:
                    errFile.write(line)
                i += 1