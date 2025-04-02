#!/usr/bin/env python3
class Trie:
    def __init__(self):
        self.root = TrieNode('', 0)
        self.last_id = 0

    def print_adjacency(self):
        pass

    def print_brutal(self):
        self.root.print_brutal()

    # returns the matching patterns if there is a match, None otherwise
    def match(self, genome):
        pass

    def add_pattern(self, pattern):
        self.root.add_node(pattern, self)

    def next_id(self):
        self.last_id = self.last_id + 1
        return(self.last_id)

class TrieNode:
    def __init__(self, base, n_id):
        self.base = base
        self.n_id = n_id
        self.last_id = n_id
        self.children = []

    def has_children(self, base):
        for c in self.children:
            if c.base == base:
                return c
        return None   

    def add_node(self, pattern, my_trie):
        if len(pattern) != 0:
            matching_children = self.has_children(pattern[0])
            if matching_children is None:
                new_children = TrieNode(pattern[0], my_trie.next_id())
                self.children.append(new_children)
                new_children.add_node(pattern[1:], my_trie)
            else:
                matching_children.add_node(pattern[1:], my_trie)

    def print_brutal(self):
        print("{}:{}\n".format(self.n_id, self.base))
        for c in self.children:
            c.print_brutal()

if __name__ == '__main__':
    # 01 read the patterns from a file, each pattern on a row, precondition of no prefixes does not need to be checked [could be a bonus exercise]
    # 02 build the trie
    trie = Trie()
    with open('patterns.txt', 'r') as pattern_file:
        for line in pattern_file:
                line = line.rstrip('\n')
                trie.add_pattern(line)
    
    trie.print_brutal()

    # 03 print the adjacency list in the format required by Rosalind