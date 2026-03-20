#!/usr/bin/env python
from bwt_ros_arrows import inverseBWT_ftl

def last_to_first(idx, first):
	return(first.index(idx))

def find_symbol_first_last(seq, start, end, symbol):
	res = [-1, -1]
	occ = 0
	for i in range(start, end+1):
		if seq[i] == symbol:
			if occ == 0:
				occ = occ + 1
				res[0] = i
			res[1] = i
	return(res)

def bwmatching(fc, lc, pattern, ltf):
	top = 0
	bottom = len(lc) - 1
	while top <= bottom:
		if pattern != '':
			symbol = pattern[-1]
			pattern = pattern[:-1]
			new_pos = find_symbol_first_last(lc, top, bottom, symbol)
			if new_pos[0] != -1:
				top = new_pos[0]
				bottom = new_pos[1]
				top = last_to_first(top, ltf)
				bottom = last_to_first(bottom, ltf)
			else:
				return 0
		else:
			return bottom - top + 1


if __name__ == '__main__':
	with open('dataset_bwm.txt') as fhandle:
		seq = fhandle.readline().rstrip()
		pattern = fhandle.readline().rstrip().split(' ')

	#print(seq)
	#print(pattern)
	first = sorted(range(len(seq)), key=lambda i: seq[i])
	first_col = inverseBWT_ftl(seq)

	for p in pattern:
		print(bwmatching(first_col, seq, p, first), end = " ")		

