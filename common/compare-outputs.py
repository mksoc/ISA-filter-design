import sys

# check if both files are given as arguments
if len(sys.argv) != 3:
    print('Error: not enough input arguments.')
    print('Usage: python compare-ouputs.py <file1> <file2>')
    sys.exit(1)

# read both files
fileData = []
for inFile in sys.argv[1:]: # iterate through argv excluding argv[0] (the name of this script)
    with open(inFile, 'r') as readFile:
        data = [int(line) for line in readFile] # read all lines as integers and save them in a list
    fileData.append(data) # save all files in another list

# check if every file has at least the same length
if len(fileData[0]) != len(fileData[1]):
    print('The files have different lengths. There is something wrong.')
    sys.exit(1)
else:
    length = len(fileData[0])

# 

"""
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
                i += 1 """