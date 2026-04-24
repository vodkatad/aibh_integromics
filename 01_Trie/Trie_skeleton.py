#!/usr/bin/env python3
# https://rosalind.info/classes/enroll/50f3beb237/
class Trie:
    def __init__(self):
        self.root = TrieNode('', 0)
        self.last_id = 0

    def print_adjacency(self):
        pass

    def print_brutal(self):
        self.root.print_brutal()

    def add_pattern(self, pattern):
        pass

    def next_id(self):
        pass

    def match(self, genome, pos):
        pass

class TrieNode:
    def __init__(self, base, n_id):
        self.base = base
        self.n_id = n_id
        self.children = []

    def has_children(self, base):
        pass

    def add_node(self, pattern, my_trie):
        pass

    def print_brutal(self):
        print("{}:{}\n".format(self.n_id, self.base))
        for c in self.children:
            c.print_brutal()

    def print_adjacency(self):
        pass

    def match(self, genome, matching_pattern, pos):
        pass

if __name__ == '__main__':
    # 01 read the patterns from a file, each pattern on a row, precondition of no prefixes does not need to be checked
    # 02 meanwhile build the trie
    trie = Trie()
    with open('patterns_00.txt', 'r') as pattern_file:
        for line in pattern_file:
                line = line.rstrip('\n')
                trie.add_pattern(line)
    
    # Brutal print of our tree:
    trie.print_brutal()
    
    # 03 print the adjacency list in the format required by Rosalind

    # 04 implement the matching algorithm vs a genome.txt file
