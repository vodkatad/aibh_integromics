#!/usr/bin/env python3

# function to assign scores
def assign_scores(scores_matrix, arrows_matrix, cols_string, rows_string, match_score, mismatch_score, gap_score):
    for i in range(1, len(rows_string)+1):
        for j in range(1, len(cols_string)+1):
            scores = [] # will be ordered match, gap on row string, gap on col string
            if rows_string[i-1] == cols_string[j-1]:
                scores.append(scores_matrix[i-1][j-1] + match_score)
            else:
                scores.append(scores_matrix[i-1][j-1] + mismatch_score)
            scores.append(scores_matrix[i][j-1] + gap_score)
            scores.append(scores_matrix[i-1][j] + gap_score)
            maxi = scores.index(max(scores)) # With ties we report the first occurrence: we prefer alignment to gaps, then gap on the rows string
            scores_matrix[i][j] = max(scores)
            if maxi == 0:
                arrows_matrix[i][j] = 0 # TODO Use a named struct (?) for clarity
            elif maxi == 1:
                arrows_matrix[i][j] = -1
            else:
                arrows_matrix[i][j] = 1


# function to traceback and print global alignment
def traceback_print_align(arrows_matrix, cols_string, rows_string):
    align_rows = ''
    align_cols = ''
    # could we start from the beginning?
    i = len(rows_string)
    j = len(cols_string)
    while i > 0 and j > 0:
        if arrows_matrix[i][j] == 0:
            align_rows = align_rows + rows_string[i-1]
            align_cols = align_cols + cols_string[j-1]
            i = i - 1
            j = j - 1
        elif arrows_matrix[i][j] == -1:
            align_cols = align_cols + cols_string[j-1]
            align_rows = align_rows + '-'
            j = j - 1
        else: # elif arrows_matrix[i][j] == 1:
            align_cols = align_cols + '-'
            align_rows = align_rows + rows_string[i-1]
            i = i - 1
    while i > 0:
        align_rows = align_rows + rows_string[i-1]
        align_cols = align_cols + '-'
        i = i - 1        
    while j > 0:
        align_cols = align_cols + cols_string[j-1]
        align_rows = align_rows + '-'
        j = j - 1        
    print(''.join(reversed(align_rows)))
    print(''.join(reversed(align_cols)))

if __name__ == '__main__':
    # define string to be aligned
    string_n_columns = 'CATGG'
    string_m_rows = 'CATCC'
    #string_n_columns = 'GTCAAAAACCCCCCCCCCCCCCCCCC'
    #string_m_rows = 'AAAAAGTCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC'
    #string_n_columns = 'CAT'
    #string_m_rows = 'CT'
    n = len(string_n_columns)
    m = len(string_m_rows)

    # define useful constants
    match_score = 1
    mismatch_score = -1
    gap_score = -1

    # build initial matrixes for scores and arrows
    scores_matrix = [[float('nan')for i in range(n+1)] for j in range(m+1)]
    arrows_matrix = [[float('nan')for i in range(n+1)] for j in range(m+1)]
    starting_score = 0
    score = starting_score
    # the second [] indexes the columns
    # the first [] the rows
    for i in range(0, n+1):
        scores_matrix[0][i] = score
        score = score + gap_score
    score = starting_score
    for j in range(0, m+1):
        scores_matrix[j][0] = score
        score = score + gap_score
    # we see some almost repeated code here, so we could refactor in a function
    #print(scores_matrix)
    # we'll keep nan in the arrows matrix and stop when we reach it
    
    assign_scores(scores_matrix, arrows_matrix, string_n_columns, string_m_rows, match_score, mismatch_score, gap_score)
    #print(scores_matrix)
    #print(arrows_matrix)
    print('The best global alignment score between ' + string_n_columns + ' and ' + string_m_rows + ' is ' + str(scores_matrix[m][n]))

    traceback_print_align(arrows_matrix, string_n_columns, string_m_rows)
