# This file contains my answer to the Huffman's coding question
# Given an input, which is my last name, this algorithm is going to
# output a sequence of bits which is shorter than the input.
import bitarray
from node import node

input = 'Eliotttt'
bitarr = bitarray.bitarray()

bitarr.frombytes(input.encode('utf-8'))
print(bitarr)
print('length bit', len(bitarr))

# Now we have to use probabilities. We know that Eliotttt contains
# 7 different symbols. See it as Eliotttt = 0 1 2 3 4 5 5 5 5, which we can now transform to bits.

shorter_input = [0, 1, 2, 3, 4, 5, 5 , 5, 5]
bitarray = ""
for i in shorter_input:
    bits_val = bin(i)
    short_bit = bits_val[2:]
    bitarray += short_bit
print('Eliotttt: new reformatted string', bitarray)
print('Eliotttt: length bit after reduction', len(bitarray))

# Now all the characters besides 't' have a weight of 1 and t has a weight of 4


# TREE APPROACH
# Starts with the minimal nodes (the characters which we only encounter once (e,l,i,o,s))

root_sm = node(2, 'e', 'l')

#    2
#   / \
# 'e' 'l'

root_no = node(2, 'i', 'o')

#    2
#   / \
# 'i' 'o'
root_nosm = node(root_sm.getdata() + root_no.getdata(), root_no, root_sm)

#          4
#       /     \
#      2       2
#     / \     / \
#   'e' 'l' 'i' 'o'

# Since t has weight 4 then we get a weight of  8 for the parent
huffman_tree = node(root_nosm.getdata() + 4, 't', root_nosm)
# final tree

#                   8
#              /        \
#             't'        4
#                        /  \
#                      2      2
#                    / \     / \
#                  'e' 'l' 'i' 'o'

# IMPORTANT: (WHEN TRAVERSING) each left child edge is assigned a value of 0
#            and each right child edge is assigned a value of 1

# Then we have a compression tree
# Where , t = 0 , e = 100, l = 101, i = 110, o = 111
# And Eliotttt would be encoded as follows:
# 100 101 110 111 0 0 0 0
# And this contains less bits than the initial eliotttt
result = '1001011101110000'
print('Eliotttt : length bit after Huffmans ', len(result))