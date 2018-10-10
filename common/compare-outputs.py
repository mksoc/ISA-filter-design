# read MATLAB output
with open('outputFromMatlab.txt', 'r') as matlabFile:
    matlabData = []
    for line in matlabFile:
        line = line.split()
        line = [int(i) for i in line]
        matlabData += line

# read Butterlfy output
with open('outputFromButterfly.txt', 'r') as butterflyFile:
    butterflyData = []
    for line in butterflyFile:
        line = line.split()
        line = [int(i) for i in line]
        butterflyData += line

# compare number by number the two outputs
matchCounter = 0
errorLines = []
for i, j in zip(matlabData, butterflyData):
    if i == j:
        matchCounter += 1
    else:
        errStr = "Errore al dato {} (riga {})".format(
            butterflyData.index(j), (butterflyData.index(j)//4) + 1)
        # save lines that generated an error
        errorLines.append((butterflyData.index(j)//4))
        print(errStr)

# print results
outStr = "Numero di match: {}/{} ({}%)".format(matchCounter,
                                               len(butterflyData), 100*matchCounter/len(butterflyData))
print(outStr)
if matchCounter == len(butterflyData):
    print("Yeeeeee!!!")

# if there are error lines, save them in a file
if errorLines:
    i = 0
    with open('inputVectors.txt', 'r') as inputs:
        with open('error_inputVectors.txt', 'a') as errFile:
            for line in inputs:
                if i in errorLines:
                    errFile.write(line)
                i += 1
    i = 0
    with open('outputFromMatlab.txt', 'r') as inputs:
        with open('error_outputFromMatlab.txt', 'a') as errFile:
            for line in inputs:
                if i in errorLines:
                    errFile.write(line)
                i += 1
