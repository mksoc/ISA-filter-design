#! /usr/bin/python3
import sys

# check if both files are given as arguments
if len(sys.argv) != 3:
    print('Error: not enough input arguments.')
    print('Usage: python compare-outputs.py <file1> <file2>')
    sys.exit(1)

# read both files
fileData = []
# iterate through argv excluding argv[0] (the name of this script)
for inFile in sys.argv[1:]:
    with open(inFile, 'r') as readFile:
        # read all lines as integers and save them in a list
        data = [int(line) for line in readFile]
    fileData.append(data)  # save all files in another list

# check if every file has at least the same length
if len(fileData[0]) != len(fileData[1]):
    print('The files have different lengths. There is something wrong.')
    sys.exit(1)
else:
    length = len(fileData[0])

# compare files
matchCounter = 0
offByOneCounter = 0
with open('error-lines.txt', 'w') as outFile:
    for i in range(length):
        data1 = fileData[0][i]
        data2 = fileData[1][i]
        if data1 == data2:
            matchCounter += 1
        elif abs(data1 - data2) == 1:
            offByOneCounter += 1
            outFile.write('{:>5} {:>5}\n'.format(data1, data2))
            if data1 >= 0:
                if data1 > data2:
                    print('Off-by-one at line {} - Positive number, {} > {}'.format(i+1, sys.argv[1], sys.argv[2]))
                else:
                    print('Off-by-one at line {} - Positive number, {} < {}'.format(i+1, sys.argv[1], sys.argv[2]))
            else:
                if data1 > data2:
                    print('Off-by-one at line {} - Negative number, {} > {}'.format(i+1, sys.argv[1], sys.argv[2]))
                else:
                    print('Off-by-one at line {} - Negative number, {} < {}'.format(i+1, sys.argv[1], sys.argv[2]))
        else:
            outFile.write('{:>5} {:>5}\n'.format(data1, data2))
            print('Error at line {}'.format(i+1))

# print stats
print('=============================================')
print('Comparison completed.')
print('Total matches: {:.0f}/{:.0f} ({:.3f}%)'.format(matchCounter,
                                                                        length, 100*matchCounter/length))
if matchCounter == length:
    print('Yeeeeee!!!')
else:
    print('Off-by-one errors: {:.0f}/{:.0f} ({:.3f}% of errors)'.format(offByOneCounter,
                                                                        length, 100*offByOneCounter/(length - matchCounter)))
