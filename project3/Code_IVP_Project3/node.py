class node:

    def __init__(self, data, left, right):
        self.left = left
        self.right = right
        self.data = data

    def PrintTree(self):
        print(self.data)

    def getdata(self):
        return self.data
