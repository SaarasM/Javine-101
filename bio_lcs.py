from pprint import pprint
from typing import List
from enum import Enum
import sys
import math
import numpy as np

class Ptr(Enum):
    NULL = 0
    UP = 1
    LEFT = 2
    DIAG = 3


base = {'A': 0, 'T': 1, 'C': 2, 'G': 3}

class TreeNode(object):
    def __init__(self, age, label):
        self.age = age
        self.label = label
        self.left = None
        self.right = None


def pprint_tree(node, file=None, _prefix="", _last=True):
    print(_prefix, "`- " if _last else "|- ", node.label, " ", node.age, sep="", file=file)
    _prefix += "   " if _last else "|  "
    child_count = 2
    for i, child in enumerate([node.left, node.right]):
        if child is None:
            continue
        _last = i == (child_count - 1)
        pprint_tree(child, file, _prefix, _last)


def needleman_wunsch(score: List[List[int]], s1: str, s2: str, indel_penalty=-4):

    # Initialise
    len_s1 = len(s1)
    len_s2 = len(s2)
    edit_matrix = [[0 for i in range(len_s1+1)] for i in range(len_s2+1)]
    edit_matrix[0] = [i*indel_penalty for i in range(len_s1+1)]
    for i in range(len_s2+1):
        edit_matrix[i][0] = i*indel_penalty
    ptr_matrix = [[Ptr.NULL for i in range(len_s1+1)] for i in range(len_s2+1)]
    ptr_matrix[0] = [Ptr.LEFT for i in range(len_s1 + 1)]
    for i in range(len_s2 + 1):
        ptr_matrix[i][0] = Ptr.UP

    # Main Iteration
    for i in range(1, len_s2+1):
        for j in range(1, len_s1+1):

            up = edit_matrix[i-1][j] + indel_penalty
            left = edit_matrix[i][j-1] + indel_penalty
            diag = edit_matrix[i-1][j-1] + score[base[s1[j-1]]][base[s2[i-1]]]

            # Print for debugging
            # pprint(edit_matrix)
            # print(up, left, diag)
            # print(i, j)

            if up >= left:
                if up >= diag:
                    # max is up
                    edit_matrix[i][j] = up
                    ptr_matrix[i][j] = Ptr.UP
                else:
                    # max is diag
                    edit_matrix[i][j] = diag
                    ptr_matrix[i][j] = Ptr.DIAG
            else:
                if left >= diag:
                    # max is left
                    edit_matrix[i][j] = left
                    ptr_matrix[i][j] = Ptr.LEFT
                else:
                    # max is diag
                    edit_matrix[i][j] = diag
                    ptr_matrix[i][j] = Ptr.DIAG

    # Termination
    pprint(edit_matrix)
    print(edit_matrix[len_s2][len_s1])

    curr_pos = (len_s2, len_s1)
    subsequence = []
    subsequence2 = []
    while curr_pos != (0, 0):
        if ptr_matrix[curr_pos[0]][curr_pos[1]] == Ptr.UP:
            curr_pos = (curr_pos[0] - 1, curr_pos[1])
            subsequence.insert(0, "_")
            subsequence2.insert(0, s2[curr_pos[0]])
        elif ptr_matrix[curr_pos[0]][curr_pos[1]] == Ptr.LEFT:
            curr_pos = (curr_pos[0], curr_pos[1] - 1)
            subsequence.insert(0, s1[curr_pos[1]])
            subsequence2.insert(0, "_")
        elif ptr_matrix[curr_pos[0]][curr_pos[1]] == Ptr.DIAG:
            curr_pos = (curr_pos[0] - 1, curr_pos[1] - 1)
            subsequence.insert(0, s1[curr_pos[1]])
            subsequence2.insert(0, s2[curr_pos[0]])
        else:
            break
    r1 = "".join(subsequence)
    r2 = "".join(subsequence2)
    print(r1)
    print(r2)

    return r1, r2

def compute_prefix(score: List[List[int]], s1: str, s2: str, indel_penalty=-4, reversed=False):
    if reversed:
        s1 = s1[::-1]
        s2 = s2[::-1]


    # Initialise
    len_s1 = len(s1)
    len_s2 = len(s2)
    mid_row = (len_s1 // 2) + 1 - int(not (reversed or len_s1%2))
    edit_col_prev = [i*indel_penalty for i in range(len_s2 + 1)]
    edit_col_curr = [0 for _ in range(len_s2 + 1)]

    # Main Iteration
    for j in range(1, mid_row+1):
        for i in range(1, len_s2 + 1):

            up = edit_col_curr[i - 1] + indel_penalty
            left = edit_col_prev[i] + indel_penalty
            diag = edit_col_prev[i - 1] + score[base[s1[j - 1]]][base[s2[i - 1]]]

            # Print for debugging
            # pprint(edit_matrix)
            # print(up, left, diag)
            # print(i, j)

            if up >= left:
                if up >= diag:
                    # max is up
                    edit_col_curr[i] = up
                else:
                    # max is diag
                    edit_col_curr[i] = diag
            else:
                if left >= diag:
                    # max is left
                    edit_col_curr[i] = left
                else:
                    # max is diag
                    edit_col_curr[i] = diag
        print(s1[j - 1])
        edit_col_prev = edit_col_curr

    if reversed:
        return edit_col_curr[::-1]

    return edit_col_curr

def linear_space_global_align(score: List[List[int]], s1: str, s2: str, indel_penalty=-4):

    # TODO:
    #   Add base case
    #   Take account that second half of recursion values need to be moved up


    prefix = compute_prefix(score, s1, s2, reversed=False)
    suffix = compute_prefix(score, s1, s2, reversed=True)

    maxim = -sys.maxsize
    mid_col = -1
    for i in range(len(prefix)):
        cur_val = prefix[i] + suffix[i]
        if cur_val > maxim:
            mid_col = i
            maxim = cur_val

    mid_row = int(math.ceil(len(s1)/2))

    return linear_space_global_align(score, s1[:mid_row], s2[:mid_col]) + [mid_col] + linear_space_global_align(score, s1[mid_row-1:], s2[mid_col:])


def upgma(init_distance: List[List[int]], init_labels: List[str]):

    curr_distance = [row[:] for row in init_distance]
    curr_tree = [TreeNode(0, label) for label in init_labels]

    while len(curr_distance) > 1:

        min_val = sys.maxsize
        min_pos = (0, 0)
        for i in range(len(curr_distance)):
            for j in range(i+1, len(curr_distance[0])):
                curr_dist = curr_distance[i][j]
                if curr_dist < min_val:
                    min_val = curr_dist
                    min_pos = (i, j)

        curr_tree, curr_distance = merge_cols(init_distance, init_labels, curr_distance, curr_tree, min_pos[0], min_pos[1])

        #print(np.array(curr_distance))
        pprint_tree(curr_tree[0])


def merge_cols(init_Distance: List[List[int]], init_labels:List[str], distance: List[List[int]], trees: List[TreeNode], col1: int, col2: int):
    # Merge Col1 with Col2
    newTree = TreeNode(compute_avg_dist_for_clusters(init_Distance, init_labels, trees[col1].label, trees[col2].label)/2, trees[col1].label+trees[col2].label)
    newTree.left = trees[col1]
    newTree.right = trees[col2]
    trees[col1] = newTree

    # Compute new values for col1
    for i in range(len(distance)):
        dist_i_col1 = compute_avg_dist_for_clusters(init_Distance, init_labels, trees[col1].label, trees[i].label)
        distance[col1][i] = dist_i_col1
        distance[i][col1] = dist_i_col1

    # Remove col2 from trees
    trees = trees[:col2] + trees[col2+1:]

    # Remove col2 from distance
    distance = distance[:col2] + distance[col2+1:]
    for i in range(len(distance)):
        row = distance[i][:col2] + distance[i][col2+1:]
        distance[i] = row

    return trees, distance


def compute_avg_dist_for_clusters(init_Distance: List[List[int]], init_labels: List[str], clust_label_1: str, clust_label_2: str ):

    if clust_label_1 is clust_label_2:
        return 0


    clust_idx_1 = [i for i in range(len(init_labels)) if init_labels[i] in clust_label_1]
    clust_idx_2 = [i for i in range(len(init_labels)) if init_labels[i] in clust_label_2]

    distance = 0
    for idx1 in clust_idx_1:
        for idx2 in clust_idx_2:
            distance += init_Distance[idx1][idx2]

    return int(distance/(len(clust_idx_1)*len(clust_idx_2)))



s1: str = "CGTGAA"
s2: str = "GACTTAC"

score_matrix: List[List[int]] = [[5, -3, -3, -3],
                                 [-3, 5, -3, -3],
                                 [-3, -3, 5, -3],
                                 [-3, -3, -3, 5]]

# needleman_wunsch(score_matrix, s1, s2)

labs = ['A', 'B', 'C', 'D']

dist_matrix = [[0, 2, 4, 6],
               [2, 0, 4, 6],
               [4, 4, 0, 6],
               [6, 6, 6, 0]]

upgma(dist_matrix, labs)
