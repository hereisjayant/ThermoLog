from flask import Flask, request
from flask_cors import CORS
import urllib 
from flask import jsonify
from bson import json_util
import json

from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi

client = MongoClient("mongodb+srv://Team-35:" + urllib.parse.quote_plus("asd()32q441%D") + "@themallog0.hekpn.mongodb.net/ThermalLogDB?retryWrites=true&w=majority", server_api=ServerApi('1'))
### stores are not strictly associated with users 
### so the invariant needs to be upheld by the api
userDb = client.prod.users
storeDb = client.prod.stores

app = Flask(__name__)
CORS(app)

############## user endpoints ################


@app.route('/user/<userId>/deleteUser', methods=['DELETE'])
async def delete_user(userId):
    # delete stores first
    try:
        user_stores = userDb.find({'_id': userId})["storeIds"]
        for storeId in user_stores:
            result = storeDb.delete_one({"_id": storeId})
            if not result:
                return ('user not deleted', 417)

        result = userDb.delete_one({"_id": userId})
        return (result, 200)
    except Exception as e:
        return ("There was an error deleting the user" + str(e), 417)



@app.route('/user/<userId>/update', methods=['PUT'])
async def update_user(userId):
    try:
        new_user = request.get_json()
        result = userDb.replace_one({"_id": userId}, new_user)
        if result:
            return (new_user, 200)
        return ("there was an error updating the user", 417)
    except Exception as e:
        return ("There was an error updating the user" + str(e), 417)
    

@app.route('/user/byEmailOrId', methods=['GET'])
def find_user():
    try:
        email = request.args.get('email')
        userId = request.args.get('userId')

        if email:
            user = userDb.find_one({"email": email })
            if user:
                return (user, 200)
            return ('user not found', 400)
        elif userId:
            user = userDb.find_one({"_id": userId })
            if user:
                return (user, 200)
            return ('user not found', 400)
        else:
            return ("invalid query", 400)
    except Exception as e:
        return ("There was an error querying the user" + str(e), 417)


@app.route('/user/create', methods=['GET', 'POST'])
def create_user():
    from datetime import datetime
    if request.method == 'POST':

        data = request.form.to_dict()
        print(type(data), data)

        epoch = datetime.utcfromtimestamp(0)
        time = (datetime.now() - epoch).total_seconds() * 1000.0

        data["lastTime"] = data["safeTime"] = time
        # userList['userId1'] = data
        try:
            userDb.insert_one(data)
            return ('user created', 200)
        except Exception as e:
            return ("There was an error creating the user" + str(e), 417)
        # dict(  # TODO: id should be from database
        #     phone=data["phone"] if data["phone"] is not None else "6048186637",
        #     photoUrl=data["photoUrl"] if data["photoUrl"] is not None else "https://www.google.com/url?sa=i&url=https%3A%2F%2Fallthings.how%2Fhow-to-change-your-profile-picture-on-google-meet%2F&psig=AOvVaw2VMU2VXIMub_LScgx7S8zb&ust=1645035637738000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCKCpvbupgvYCFQAAAAAdAAAAABAD",
        #     lastTime=data["lastTime"] if data["lastTime"] is not None else time,
        #     safeTime=data["safeTime"] if data["safeTime"] is not None else time,
        #     email=data["email"],
        #     name=data["name"],
        #     notificationToken=data["notificationToken"],
        #     storeIds=data["storeIds"] if data["storeIds"] is not None else [],
        # )

@app.route('/user/getAll', methods=['GET'])
def get_all_users():
    try:
        userList = [doc for doc in userDb.find()]
        print(type(userList))
        return (jsonify(json.loads(json_util.dumps(userList))), 200)
    except Exception as e:
        return ("There was an error pulling all the users" + str(e), 417)

############## store endpoints ################

# TODO: fetch livestream endpoint


@app.route('/store/<storeId>/deleteStore', methods=['DELETE'])
async def delete_store(storeId):
    try:
        result = storeDb.delete_one({"_id": storeId})
        return (result, 200)
    except Exception as e:
        return ("There was an error deleting the store" + str(e), 417)


@app.route('/store/<storeId>/update', methods=['PUT'])
async def update_store(storeId):
    try:
        new_store = request.get_json()
        result = storeDb.replace_one({"_id": storeId}, new_store)
        if result:
            return (new_store, 200)
        return ("there was an error updating the store", 417)
    except Exception as e:
        return ("There was an error updating the store" + str(e), 417)


@app.route('/store/<storeId>/byId', methods=['GET'])
def find_store(storeId):
    try:
        if storeId:
            store = storeDb.find_one({"_id": storeId})
            if store:
                return (store, 200)
            return ('store not found', 400)
        else:
            return ("invalid query", 400)
    except Exception as e:
        return ("There was an error querying the store" + str(e), 417)


@app.route('/store/create', methods=['GET', 'POST'])
def create_store():
    if request.method == 'POST':
        data = request.form.to_dict()
        data["isSafe"] = True
        # storeList['this is the test store'] = data
        try:
            storeDb.insert_one(data)
            return ('store created', 200)
        except Exception as e:
            return ("There was an error creating the store" + str(e), 417)
        # dict(  # TODO: id should be from database
        #     capacity=data["capacity"],
        #     customerCount=data["customerCount"],
        #     isSafe=data["isSafe"],
        #     temperatures=data["temperatures"],
        #     name=data["name"],
        #     liveStreamIds=data["liveStreamIds"],
        # )


@app.route('/store/getAll', methods=['GET'])
def get_all_stores():
    try:
        storeList = [doc for doc in storeDb.find()]
       
        print("GET logger")
        return (jsonify(json.loads(json_util.dumps(storeList))), 200)
    except Exception as e:
        return ("There was an error pulling all the stores" + str(e), 417)

############## store endpoints ################

# TODO: fetch livestream endpoint

@app.route('/', methods=['GET'])
def testing():
    print("Hey logger")
    if request.method == 'GET':
        print("GET logger")
        return ('Hello Guy Lemieux', 200)


if __name__ == '__main__':
    app.run(debug=True)


# TODO
# 2. integrate with the video api
# 4. change the static data to connect to MongoDB
