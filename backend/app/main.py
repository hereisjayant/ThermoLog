from flask import Flask, request
from flask_cors import CORS
import urllib 
from flask import jsonify
from bson import json_util
import json
from bson.objectid import ObjectId
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


@app.route('/user/<userId>', methods=['GET', 'PUT', 'DELETE'])
def delete_user(userId):
    # delete stores first
    if request.method == 'GET':
        try:
            user = userDb.find_one({"_id": ObjectId(userId) })
            if user:
                return (jsonify(json.loads(json_util.dumps(user))), 200)
            return ('user not found', 400)
        except Exception as e:
            return ("There was an error querying the user" + str(e), 417)
    elif request.method == 'PUT':
        try:
            user = userDb.find_one({"_id": ObjectId(userId)})
            for key in request.get_json():
                user[key] = request.json[key]
            result = userDb.replace_one({"_id": ObjectId(userId)}, user)
            if result:
                return (jsonify(json.loads(json_util.dumps(user))), 200)
            return ("there was an error updating the user", 417)
        except Exception as e:
            return ("There was an error updating the user" + str(e), 417)
    elif request.method == 'DELETE':
        try:
            user_stores = userDb.find({'_id': ObjectId(userId)})["storeIds"]
            for storeId in user_stores:
                result = storeDb.delete_one({"_id": ObjectId(storeId)})
                if not result:
                    return ('user not deleted', 417)

            result = userDb.delete_one({"_id": ObjectId(userId)})
            return (result, 200)
        except Exception as e:
            return ("There was an error deleting the user" + str(e), 417)

@app.route('/user/byEmailOrId', methods=['GET'])
def find_user_by_email_or_id():
    try:
        email = request.args.get('email')
        userId = request.args.get('userId')

        if email:
            user = userDb.find_one({"email": email })
            if user:
                return (jsonify(json.loads(json_util.dumps(user))), 200)
            return ('user not found', 400)
        elif userId:
            user = userDb.find_one({"_id": ObjectId(userId) })
            if user:
                return (jsonify(json.loads(json_util.dumps(user))), 200)
            return ('user not found', 400)
        else:
            return ("invalid query", 400)
    except Exception as e:
        return ("There was an error querying the user" + str(e), 417)    

@app.route('/user', methods=['GET', 'POST'])
def create_user():
    from datetime import datetime
    if request.method == 'GET':
        try:
            userList = [doc for doc in userDb.find()]
            print(type(userList))
            return (jsonify(json.loads(json_util.dumps(userList))), 200)
        except Exception as e:
            return ("There was an error pulling all the users" + str(e), 417)
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

############## store endpoints ################

@app.route('/store/<storeId>', methods=['PUT', 'GET', 'DELETE'])
def store(storeId):
    if request.method == 'GET':
        try:
            if storeId:
                store = storeDb.find_one({"_id": ObjectId(storeId)})
                if store:
                    return (jsonify(json.loads(json_util.dumps(store))), 200)
                return ('store not found', 400)
            else:
                return ("invalid query", 400)
        except Exception as e:
            return ("There was an error querying the store" + str(e), 417)
    if request.method == 'PUT':
        try:
            store = storeDb.find_one({"_id": ObjectId(storeId)})
            for key in request.get_json():
                store[key] = request.json[key]
            result = storeDb.replace_one({"_id": ObjectId(storeId)}, store)
            if result:
                return (jsonify(json.loads(json_util.dumps(store))), 200)
            return ("there was an error updating the store", 417)
        except Exception as e:
            return ("There was an error updating the store" + str(e), 417)
    if request.method == 'DELETE':
        try:
            result = storeDb.delete_one({"_id": ObjectId(storeId)})
            return (result, 200)
        except Exception as e:
            return ("There was an error deleting the store" + str(e), 417)


@app.route('/store', methods=['GET', 'POST'])
def create_store():
    if request.method == 'GET':
        try:
            storeList = [doc for doc in storeDb.find()]
            print("GET logger")
            return (jsonify(json.loads(json_util.dumps(storeList))), 200)
        except Exception as e:
            return ("There was an error pulling all the stores" + str(e), 417)
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
############## store endpoints ################

# TODO: fetch livestream endpoint

@app.route('/', methods=['GET'])
def testing():
    print("Hey logger")
    if request.method == 'GET':
        print("GET logger")
        return ('Hello Guy Lemieux x2', 200)


if __name__ == '__main__':
    app.run(debug=True)


# TODO
# 2. integrate with the video api
# 4. change the static data to connect to MongoDB
