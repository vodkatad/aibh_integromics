#!/usr/bin/env python3

def BWT(string):
    # We prepend the special 'beginning' character
    string = "^"+string+"$"
    # Since we will need to sort alphabetically all the rotations we'll represent the matrix 
    # as list of all the possible rotation of our string.
    # Let's compute all the rotations
    rotations = []
    end = len(string)
    for i in range(0, end):
        rotations.append(string[i:end] + string[0:i])
    rotations.sort()
    res = ''
    for i in range(0, len(rotations)):
        res = res + rotations[i][-1]
    return(res)

def inverseBWT(string_bwt):
    res = []
    s = list(string_bwt)
    for i in range(0, len(s)-1):
        add = sorted(s)
        newcol = [x + y for x, y in zip(list(string_bwt), add)]
        newcol.sort()
        s = newcol
    for i in range(0, len(s)):
        if s[i][0] == "^":
            return(s[i][1:len(s[i])-1])

if __name__ == '__main__':
    # define string to be bwt transformed
    #string = 'BANANA'
    string = 'MISSISSIPI'
    print('Before BWT: ' + string)
    BWT_res = BWT(string)
    print('After BWT: ' + BWT_res)
    re_string = inverseBWT(BWT_res)
    print('After inverseBWT: ' + re_string)
