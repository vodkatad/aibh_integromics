#!/usr/bin/env python3

# function to assign scores

# function to traceback and print global alignment

if __name__ == '__main__':
    # define string to be aligned
    string_n_columns = 'CAT'
    string_m_rows = 'CAT'
    n = len(string_n_columns)
    m = len(string_m_rows)

    # define useful constants
    match_score = 1
    mismatch_score = -1
    gap_score = -1

    # build initial matrixes for scores and arrows
    # call the function to assign scores
    # print the global alignment score
    # call the function for the traceback