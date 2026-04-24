#!/usr/bin/env python3

def BWT(string):
    string = string
    # Since we will need to sort alphabetically all the rotations we'll represent the matrix 
    # as list of all the possible rotation of our string.
    # Let's compute all the rotations
    rotations = []
    end = len(string)
    for i in range(0, end):
        rotations.append(string[i:end] + string[0:i])
    rotations.sort()
    res = ''
    print(rotations)
    for i in range(0, len(rotations)):
        res = res + rotations[i][-1]
    return(res)

# return a vector with ranks of letters in a list
def ranks(my_list):
    pos = [0] * len(my_list)
    occ = {}
    res = []
    for l in my_list:
        if l in occ:
            occ[l] = occ[l] + 1
        else:
            occ[l] = 1
        res.append(occ[l])
    return(res)

# find the letter with required rank in list, return its index
def find_matched(my_list, letter, rank):
    occ = 0
    for i in range(0, len(my_list)):
        if my_list[i] == letter:
            occ = occ + 1
            if occ == rank:
                return i
        
def inverseBWT(string_bwt):
    res = []
    last_col = list(string_bwt)
    first_col = sorted(last_col)
    rank_first = ranks(first_col)
    search_letter = '$'
    search_rank = 1
    for i in range(1, len(string_bwt)):
        in_first = find_matched(last_col, search_letter, search_rank)
        search_letter = first_col[in_first]
        search_rank = rank_first[in_first]
        res.append(search_letter)
    return(''.join(res))
    
def last_to_first(i, first_to_last):
    return first_to_last.index(i)

def inverseBWT_ftl(string_bwt):
    res = []
    last_col = list(string_bwt)
    first_to_last = sorted(range(len(string_bwt)), key=lambda i: string_bwt[i])
    print(first_to_last)
    idx = last_col.index('$') # da dove parto?
    # qui mi son segnata l'indice del marker di fine stringa in lc.
    # questa posizione in fc è la prima lettera, se la cerco in last ottengo l'indice (uso first_to_last)
    # della riga con lei in lc e la prossima in fc, quindi:
    # ad ogni giro del loop in index metto dove trovo in sc la lettera in posizione idx in fc
    for i in range(1, len(string_bwt)):
        print(idx)
        idx = first_to_last[idx]
        res.append(string_bwt[idx])
    return(''.join(res))

if __name__ == '__main__':
    # define string to be bwt transformed
    string = 'ELDEN$' # 'BANANA$'
    #string = 'GACCTGGGCAATCAAGTTCATCGGGGTGACGGCGTCTATCATTGCTGATAATATGCAAGATCGTTTTCCCACGTAGCGGACGTACACCTCTGAGAAGATCAGTGCCAAGCCAGATAGCTTGGATGGTGTCTGCGTATTATGTGGCATACGGCAATATGGCATTCGATCAACGTTACAAGGCAACACCTTTTCTGCCCATAACTAGTGCAAGTCCCGCTTTAACGACCCAATTAAATCTAATGTGCACCTCGAGCGCCCCAATAGGGGAGTTTGCGTCCATGTAGACCGTGCCACTGATGCTTATGGGCCCCCGGAAAGGATTTGGTTGGCTACAAAAACGACTCCTTGTCTTGCCGTTAGCGCCAAGCTTTTTCACGCTGGAATTATGACAACGTGTTCAGTTTCACAGGTTCCCATCCTCGTTCCTTCCATGCACGCGACATGTACGAATACACGCCGCTTGTATTGCACAATACTTTACTTTGATATACCTACGTCCCATGCTTAGGCTGAGGACTTCCCCTATGAGCCAACGGCCCAATACAACGTTAGCACGTTCTTTGCCTGGATCCAGATAGCGAAATAGAAGGTGCGTCAGGGCCTTCATCAGAGGACCGCATACTCCTTTCTAGCGGAGCCTTGCGATTTCTATAAGTATAAACTTGGCACGGGTTCCTGTCCGCGGTTGACCCAGAAGTCCTGCCTATCGGCTGGGTACTTAGACGGAACTTCCAATAGCCTTGCAACTTTCTTAGATACTGGAGTGCGCAACGAGGCAAAAGACTTTAGCAAAACCCCGCCCTGCGGTAGTTCTATCGGCTATGGAGAGACAAA$'
    print('Before BWT: ' + string)
    BWT_res = BWT(string)
    print('After BWT: ' + BWT_res)
    re_string = inverseBWT_ftl(BWT_res)
    print('After inverseBWT: ' + re_string + '$')
    #string = 'ATGCGTTACGTATCCGCTTATCAGGAGTTCCTGCCGAGGTCTCAGAGCGATGAATCG$TCTACGCTTGAGCTTGCCGTGGTTACTCGATATCGGTTAACACATCGCTCAGGTGGCATGAGAAGAACGCTGCAGAGCCGCACCCGCCTGAAGCCAGAAGCGGCTCCCACCAGCGTCTATATAAATCTTCATGAATTGAAACTACACCCCAGTGGAATAGATGGAAAAGACATCTTGTCGAAAAGCAGCTGCCCAGACAAAAACTCTTTAACATCAAGTGAGCGATGGTACCCGCCAGTTGCATAGCCATTGCTAGGGGGTATTTGGGACTTCAGTGTCGGGACACCATGATGGTACAGCCTATAGTACCATCCAGTTCCGTGTGATTACCGGAGTTACGTTATCCACTCTTAACCAAATTAACCTTTGAAAACAGCGATATTTCGCTATGATGAGGATGAAGCGTAGCGCCTTACCCTGTCTAGGGAGTAGATGTCCTAGGTTTTCACGACTACGTAAAACTAAGATGCTTGTCTACTCACATAGTATTACTAAATGCCAGCGTTTCCTTAGCGGCCTTACGCATGCGAGTTAGACACCGACCGTGGTGGTATGGCGGAGGGGATGCTGACCCCTTGCAAGTAGTGCTGAGATAATCGATAGGTTTGCCGATCCACCGATGTCGCCCCGGGACATACGGTGTCCTGAAGAAGAATCTTCAACTCCGGCTTACCCCCAAGAGCAGAAAGCATGCGACGTCTCACATTTAATTCCGATTAGTTAGCCGCAGCAAATGTCTGGCCGGAGCTGCGTTACCGTATAGGCGCACCTGATTTGAGGCA'
    #re_string_2 = inverseBWT_ftl(string)
    #print('After inverseBWT: ' + re_string_2 + '$')