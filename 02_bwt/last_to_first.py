#!/usr/bin/env python

if __name__ == '__main__':
	with open('dataset_ltf.txt') as fhandle:
		seq = fhandle.readline().rstrip()
		k = int(fhandle.readline().rstrip())

	first = sorted(range(len(seq)), key=lambda i: seq[i])
	print(first.index(k))

