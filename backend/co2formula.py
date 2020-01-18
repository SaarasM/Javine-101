import pandas as ps
import pymongo

client = pymongo.MongoClient("mongodb://localhost:27017")
db = client["database"]
ingdb = db["ingredientsco2"]
tradb = db["travelco2"]
pacdb = db["packagingco2"]

ie = {"id": "chicken", "co2perkg": 19000}
te = {"id": "ship", "co2perkm": 10000}
pe = {"id": "plastic", "co2perkg": 19000}

x = ingdb.insert_one(ie)
y = tradb.insert_one(te)
z = pacdb.insert_one(pe)

testi = {"chicken": 500, "beef": 100}
testt = {"ship": 100}
testp = {"plastic": 10}

def CalculateCo2(ingredient,travel,packaging,params):
    for entry in ingredient:
        for i in ingdb.find({}, {"id": entry}):
            print(i)
