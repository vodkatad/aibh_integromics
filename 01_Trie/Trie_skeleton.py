#!/usr/bin/env python3
class Trie:
    def __init__(self):
        self.root = None

    def print_adjacency(self):
        pass

    def print_brutal(self):
        pass

    # returns the matching patterns if there is a match, None otherwise
    def match(self, genome):
        pass

    def add_node(self, base):
        pass

    def add_pattern(self, pattern):
        pass

class TrieNode:
    def __init__(self, base, n_id):
        self.base = base
        self.n_id = n_id

    def print_brutal(self):
        print(self.base)

if __name__ == '__main__':
    # 01 read the patterns from a file, each pattern on a row, precondition of no prefixes does not need to be checked [could be a bonus exercise]
    
    # 02 build the trie

    # 03 print the adjacency list in the format required by Rosalind