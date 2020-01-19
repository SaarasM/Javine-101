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

file = open(path + "/data.csv", "r")
reader = csv.reader(file)

for row in reader:
    ingredients_name_arr.append(row[0])
    ingredients_arr.append(row[1])

ingredients_arr.pop(0)
ingredients_arr = [int(x) for x in ingredients_arr]
ingredients_arr = np.array(ingredients_arr)
print(ingredients_arr)
normalized_ingredients_arr = preprocessing.normalize([ingredients_arr])
print(normalized_ingredients_arr)

plastic_co2_per_kg = 6000
recycled_paper_co2_per_kg = 470
cardboard_co2_per_kg = 538
glass_co2_per_kg = 1

packaging_arr = np.array(
    [plastic_co2_per_kg, recycled_paper_co2_per_kg, cardboard_co2_per_kg, glass_co2_per_kg])
print(packaging_arr)
normalized_packaging_arr = preprocessing.normalize([packaging_arr])
print(normalized_packaging_arr)


oreo = foodie.get_product("51000009")
pprint.pprint(oreo)
# or get by facets
primary_ingridient = oreo["product"]["ingredients_ids_debug"][0]
secondary_ingredient = oreo["product"]["ingredients_ids_debug"][1]
tertiary_ingredient = oreo["product"]["ingredients_ids_debug"][2]
oreo_ingredients = [primary_ingridient,
                    secondary_ingredient, tertiary_ingredient]
print(oreo["product"]["product_name"])
grade = oreo["product"]["nutrition_grades"]
packaging = oreo["product"]["packaging"]
product_score = (primary_ingridient * 5 +
                 secondary_ingredient * 3 + tertiary_ingredient * 2)
pprint.pprint(packaging)
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
    primary_ingredient = product["product"]["ingredients_ids_debug"][0]
    secondary_ingredient = product["product"]["ingredients_ids_debug"][1]
    tertiary_ingredient = product["product"]["ingredients_ids_debug"][2]

    primary = bio_lcs.LCS_all(ingredients_name_arr, primary_ingredient)
    secondary = bio_lcs.LCS_all(ingredients_name_arr, secondary_ingredient)
    tertiary = bio_lcs.LCS_all(ingredients_name_arr, tertiary_ingredient)
