#!/usr/bin/env python3
from treelib import Node, Tree

class Trie:
    def __init__(self):
        self.root = TrieNode('', 1)
        self.last_id = 1

    def print_adjacency(self):
        self.root.print_adjacency()

    def print_brutal(self):
        self.root.print_brutal()

    def print_ascii(self):
        tree = Tree()
        self.root.print_ascii(tree, None)
        tree.show()

    def add_pattern(self, pattern):
        self.root.add_node(pattern, self)

    def next_id(self):
        self.last_id = self.last_id + 1
        return(self.last_id)

    # Returns ... TODO
    def match(self, genome):
        self.root.match(genome, '')

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

    def print_ascii(self, tree, parent):
        if parent is None:
            tree.create_node(self.base, self.n_id)
        else:
            tree.create_node(self.base, self.n_id, parent=parent.n_id)
        for c in self.children:
            c.print_ascii(tree, self)

    def print_adjacency(self):
        for c in self.children:
            print("{} {} {}".format(self.n_id, c.n_id, c.base))
            c.print_adjacency()

    def match(self, genome, matching_pattern):
        if len(self.children) == 0 and matching_pattern != '':
            print('Match with {}'.format(matching_pattern))
        if len(genome) != 0:
            for c in self.children:
                if c.base == genome[0]:
                    c.match(genome[1:], matching_pattern + c.base)



if __name__ == '__main__':
    # 01 read the patterns from a file, each pattern on a row, precondition of no prefixes does not need to be checked [could be a bonus exercise]
    # 02 build the trie
    trie = Trie()
    with open('patterns_FC.txt', 'r') as pattern_file:
        for line in pattern_file:
                line = line.rstrip('\n')
                trie.add_pattern(line)
    
    #trie.print_brutal()
    # 02 print the tree with treelib
    trie.print_ascii()
    # 03 print the adjacency list in the format required by Rosalind
    #trie.print_adjacency()

    # 04 read a genome (putting together multiple lines of a txt) and look for matching patterns
    genome = ''
    with open('genome_FC.txt', 'r') as pattern_file:
        for line in pattern_file:
                line = line.rstrip('\n')
                genome = genome + line
    
    for i in range(0, len(genome)):
        trie.match(genome[i:])
