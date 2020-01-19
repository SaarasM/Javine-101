import openfoodfacts as foodie
import json
import pprint
import os
import csv
import numpy as np
from sklearn import preprocessing
import bio_lcs

path = str(os.getcwd())
ingredients_name_arr = []
ingredients_arr = []

file = open(path + "/datarev.csv", "r")
reader = csv.reader(file)

for row in reader:
    ingredients_name_arr.append(row[0])
    ingredients_arr.append(row[1])

ingredients_arr = [int(x) for x in ingredients_arr]
ingredients_arr = np.array(ingredients_arr)
# print(ingredients_arr)
normalized_ingredients_arr = preprocessing.normalize([ingredients_arr])
# print(normalized_ingredients_arr)

plastic_co2_per_kg = 6000
recycled_paper_co2_per_kg = 470
cardboard_co2_per_kg = 538
glass_co2_per_kg = 770
aluminium_co2_per_kg = 8900

packaging_per_kg={"plastic": 0.2136,"paper": 0.0470,"cardboard": 0.0538,"glass": 0.154,"aluminium": 0.45,"": 0}
packaging_list=["plastic","paper","cardboard","glass","aluminium", ""]
packaging_arr = np.array(
    [plastic_co2_per_kg, recycled_paper_co2_per_kg, cardboard_co2_per_kg, glass_co2_per_kg])
# print(packaging_arr)
normalized_packaging_arr = preprocessing.normalize([packaging_arr])
# print(normalized_packaging_arr)


# pprint.pprint(oreo)
# or get by facets
# pprint.pprint(packaging)
# 0.0 0.2
# 0.2 0.4
# 0.4 0.6
# 0.6 0.8
# 0.8 1.0

# product_score = i1 * 0.5 + i2 * 0.3 + i3 * 0.2
# delivery_score = ??
# product_score =
# score = packaging_score * 0.2 + product_score * 0.7 + delivery_score * 0.1

# wire frontend with backend


# `packaging_score =
# product_score - percentage packaging_score - percentage
# find emission of oil
# product_score 0.7 packaging_score  0.3
# nutrition grade
# packaging

def GetScore(product):
    N=len(product["product"]["ingredients_ids_debug"])
    if (N>0):
        primary_ingredient = product["product"]["ingredients_ids_debug"][0]
    else:
        primary_ingredient=""
    if(N>1):
        secondary_ingredient = product["product"]["ingredients_ids_debug"][1]
    else:
        secondary_ingredient=""
    if(N>2):
        tertiary_ingredient = product["product"]["ingredients_ids_debug"][2]
    else:
        tertiary_ingredient=""

    primary = bio_lcs.LCS_all(ingredients_name_arr, primary_ingredient)
    secondary = bio_lcs.LCS_all(ingredients_name_arr, secondary_ingredient)
    tertiary = bio_lcs.LCS_all(ingredients_name_arr, tertiary_ingredient)

    per_kg_primary=ingredients_arr[ingredients_name_arr.index(primary)]
    per_kg_secondary=ingredients_arr[ingredients_name_arr.index(secondary)]
    per_kg_tertiary=ingredients_arr[ingredients_name_arr.index(tertiary)]
    quantity=product["product"]["quantity"]
    weight=0
    for c in quantity:
        if(not str.isdigit(c)):
            if(c=='k' or c=='l'):
                weight=weight*1000
            if(c=='m'):
                break
        else:
            weight*=10
            weight+=int(c)
    print(weight)
    result=float(0.5)*weight*per_kg_primary+0.3*per_kg_secondary*weight+0.1*per_kg_tertiary*weight
    result=result/1000
    packaging=bio_lcs.LCS_all(packaging_list,product["product"]["packaging"])
    result=result+float(packaging_per_kg[packaging])*weight

    return result