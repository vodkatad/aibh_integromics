#!/usr/bin/env python3
class LinkedList:
    def __init__(self):
        self.first_element = None

    def add_element(self, value):
        if self.first_element is None: # base case
            self.first_element = Element(value) 
        else:  # recursion
            self.first_element.add(value)

    def print(self):
        if self.first_element is not None:
            self.first_element.print()
        print()
                
    def find_element(self, value):
        if self.first_element is not None:
            return self.first_element.find(value, 0)
        else:
            return -1

class Element:
    def __init__(self, value):
        self.value = value
        self.next = None
   
    def add(self, value):
        if self.next is None:
            self.next = Element(value)
        else:
            self.next.add(value)

    def print(self):
        print(self.value, end='')
        if self.next is not None:
            print(', ', end='')
            self.next.print()

    def find(self, value, pos):
        if self.value == value:
            return pos
        elif self.next is not None:
            return self.next.find(value, pos+1)
        else:
            return -1

if __name__ == '__main__':
    ex = LinkedList()
    ex.add_element('A')
    ex.add_element('B')
    ex.add_element('C')
    ex.print()
    print(ex.find_element('B'))
    print(ex.find_element('D'))
    ex.add_element('B')
    print(ex.find_element('B'))
    ex.add_element('D')
    print(ex.find_element('D'))
    print(ex.find_element('A'))