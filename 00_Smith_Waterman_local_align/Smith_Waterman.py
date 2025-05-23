#!/usr/bin/env python3

# function to assign scores
def assign_scores(scores_matrix, arrows_matrix, cols_string, rows_string, match_score, mismatch_score, gap_score):
    for i in range(1, len(rows_string)+1):
        for j in range(1, len(cols_string)+1):
            scores = []; # will be ordered match, gap on rows string, gap on cols string [probably opposite row/col]
            if rows_string[i-1] == cols_string[j-1]:
                scores.append(scores_matrix[i-1][j-1] + match_score)
            else:
                scores.append(scores_matrix[i-1][j-1] + mismatch_score)
            scores.append(scores_matrix[i][j-1] + gap_score)
            scores.append(scores_matrix[i-1][j] + gap_score)
            scores = [0 if x < 0 else x for x in scores]
            maxi = scores.index(max(scores)) # With ties we report the first occurrence: we prefer alignment to gaps, then gap on the rows string
            scores_matrix[i][j] = max(scores)
            if maxi == 0:
                arrows_matrix[i][j] = 0
            elif maxi == 1:
                arrows_matrix[i][j] = -1
            else:
                arrows_matrix[i][j] = 1

def find_max_index(matrix):
    maxv = 0
    res = [-1,-1]
    for i in range(0, len(matrix)):
        for j in range(0, len(matrix[1])): # corner case empty string not managed
            if matrix[i][j] > maxv:
                maxv = matrix[i][j]
                res[0] = i
                res[1] = j
    return res
            
    
           
# function to traceback and print global alignment
def traceback_print_align(scores_matrix, arrows_matrix, cols_string, rows_string):
    align_rows = ''
    align_cols = ''
    # could we start from the beginning? probably yes
    max_index = find_max_index(scores_matrix)
    i = max_index[0]
    j = max_index[1]
    while scores_matrix[i][j] != 0:
        if arrows_matrix[i][j] == 0:
            align_rows = align_rows + rows_string[i-1]
            align_cols = align_cols + cols_string[j-1]
            i = i - 1
            j = j - 1
        elif arrows_matrix[i][j] == -1:
            align_rows = align_rows + '-'
            align_cols = align_cols + cols_string[j-1]
            j = j - 1
        else: # elif arrows_matrix[i][j] == 1:
            align_rows = align_rows + rows_string[i-1]
            align_cols = align_cols + '-'
            i = i - 1
    print(''.join(reversed(align_rows)))
    print(''.join(reversed(align_cols)))

if __name__ == '__main__':
    # define string to be aligned
    string_n_columns = 'TGTTACGG'
    string_m_rows = 'GGTTGACTA'
    #string_n_columns = 'CAT'
    #string_m_rows = 'CAT'
    #string_n_columns = 'GATTAAAAACA'
    #string_m_rows = 'GATTACAGATTACAGATTACA'
    #string_n_columns = 'GTCAAAAACCCCCCCCCCCCCCCCCC'
    #string_m_rows = 'AAAAAGTCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC'
    n = len(string_n_columns)
    m = len(string_m_rows)

    # define useful constants
    match_score = 3
    mismatch_score = -3
    gap_score = -2

    # build initial matrixes for scores and arrows
    scores_matrix = [[0 for i in range(n+1)] for j in range(m+1)]
    arrows_matrix = [[float('nan') for i in range(n+1)] for j in range(m+1)]
    # the second [] indexes the columns
    # the first [] the rows
    
    assign_scores(scores_matrix, arrows_matrix, string_n_columns, string_m_rows, match_score, mismatch_score, gap_score)
    print(scores_matrix)
    print(arrows_matrix)
    maxi = find_max_index(scores_matrix)
    max_score = scores_matrix[maxi[0]][maxi[1]]
    print('The best local alignment score between ' + string_n_columns + ' and ' + string_m_rows + ' is ' + str(max_score))

    traceback_print_align(scores_matrix, arrows_matrix, string_n_columns, string_m_rows)
