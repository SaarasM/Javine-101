# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [START gae_python37_app]
from flask import Flask, request
import openfoodfacts as foodie
import json


# pkgs = ['flask', 'openfoodfacts']
# for package in pkgs:
#     try:
#         import package
#     except ImportError, e:
#     pip.main(['install'])


# If `entrypoint` is not defined in app.yaml, App Engine will look for an app
# called `app` in `main.py`.
app = Flask(__name__)

def get_score(product):
    return "0.5"

# def parse_receipt(receipt, confidence_value):
#     pscore = "0.5"
#     pname = "Oreo"
#     product = {}
#     product["product_name"] = pname
#     product["product_score"] = pscore
#     json_product = json.dumps(product)
#     return json_product

def get_receipt_item_score(name):
    p = foodie.get_product(name)
    pscore = "0.5"
    return pscore


def find_product_from_barcode(barcode):
    p = foodie.get_product(barcode)
    pname = str(p["product"]["product_name"])
    pscore = "0.5"
    product = {}
    product["product_name"] = pname
    product["product_score"] = pscore
    json_product = json.dumps(product)
    print(json_product)
    return json_product

# pprint.pprint(find_product_from_barcode("5000159461122"))

@app.route('/')
def hello():
    """Return a friendly HTTP greeting."""
    return find_product_from_barcode("5000159461122")


@app.route('/barcode/<int:id>', methods=['GET'])
def get_barcode(id):
    return find_product_from_barcode(str(id))

@app.route('/receipt', methods=['POST'])
def parse_receipt():
    items = request.get_json()
    item1 = items["id_1"]
    item2 = items["id_2"]
    item3 = items["id_3"]
    list = [item1, item2, item3]
    results = {}
    i = 1
    for x in list:
        result = {}
        result["product_name"] = x["receipt"]
        result["product_score"] = get_receipt_item_score(x["receipt"])
        json_result = json.dumps(result)
        results["id_" + str(i)] = json_result
        i = i + 1
    results = json.dumps(results)
    return results



if __name__ == '__main__':
    # This is used when running locally only. When deploying to Google App
    # Engine, a webserver process such as Gunicorn will serve the app. This
    # can be configured by adding an `entrypoint` to app.yaml.
    app.run(host='127.0.0.1', port=8080, debug=True)
# [END gae_python37_app]
