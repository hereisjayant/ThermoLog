from flask import Flask, request
from flask_cors import CORS

from pymongo import MongoClient

client = MongoClient("mongodb+srv://Team-35:asd()32q441%D@themallog0.hekpn.mongodb.net/ThermalLogDB?retryWrites=true&w=majority", server_api=ServerApi('1'))
### stores are not strictly associated with users 
### so the invariant needs to be upheld by the api
userDb = client.user
storeDb = client.store

from app.stores import stores

app = Flask(__name__)
CORS(app)

############## user endpoints ################

@app.route('/user/<userId>/deleteUser', methods=['DELETE'])
async def delete_user(userId):
    # delete stores first
    user_stores = userDb.find({'_id': userId}).storeIds
    for storeId in user_stores:
        result = storeDb.delete_one({"_id": storeId})
        if not result:
            return ('user not deleted', 417)

    result = userDb.delete_one({"_id": userId})
    return (result, 200)

@app.route('/user/<userId>/update', methods=['PUT'])
async def update_user(userId):
    new_user = request.get_json()
    result = userDb.
    return (userList[userId], 200)
    

@app.route('/user/byEmailOrId', methods=['GET'])
def find_user():
    email = request.args.get('email')
    userId = request.args.get('userId')

    if email:
        for user in userList:
            if userList[user]['email'] == email:
                return (userList[user], 200)
    elif userId:
        return (userList[userId], 200)
    else:
        return ("invalid query", 400) #TODO add status code
    return ("DNE", 204)
    

@app.route('/user/create', methods=['GET', 'POST'])
def create_user():
    if request.method == 'POST':
        data = request.form.to_dict(flat=False)
        print(type(data),data)
        userList['this is the test account'] = dict( #TODO: id should be from database
            phone = data["phone"],
            photoUrl = data["photoUrl"],
            lastTime = data["lastTime"],
            safeTime = data["safeTime"],
            email = data["email"],
            name = data["name"],
            notificationToken = data["notificationToken"],
            storeIds = data["storeIds"],
        )
        return ('user created', 200) # TODO: return False for error when actually connected to MongoDB
    #TODO: actually put this into a database and then store the generated id from there


@app.route('/user/getAll', methods=['GET'])
def get_all_users():
    return (userList, 200)

############## store endpoints ################

storeList = stores 

# TODO: fetch livestream endpoint

@app.route('/store/<storeId>/deleteStore', methods=['DELETE'])
async def delete_store(storeId):
    delattr(storeList, storeId)
    return ("store deleted", 200)

@app.route('/store/<storeId>/update', methods=['PUT'])
async def update_store(storeId):
    new_store = request.get_json()
    storeList[storeId] = {key: new_store.get(key, storeList[storeId][key]) for key in storeList[storeId]}
    return (storeList[storeId], 200)
    

@app.route('/store/<storeId>/byId', methods=['GET'])
def find_store(storeId):
    return (storeList[storeId], 200)
    

@app.route('/store/create', methods=['GET', 'POST'])
def create_store():
    data = request.form.to_dict(flat=False)
    storeList['this is the test store'] = dict( #TODO: id should be from database
        capacity = data["capacity"],
        customerCount = data["customerCount"],
        isSafe = data["isSafe"],
        temperatures = data["temperatures"],
        email = data["email"],
        name = data["name"],
        liveStreamIds = data["liveStreamIds"],
    )
    return ('created', 200) # TODO: return False for error when actually connected to MongoDB
    #TODO: actually put this into a database and then store the generated id from there


@app.route('/store/getAll', methods=['GET'])
def get_all_stores():
    return (storeList, 200)

############## store endpoints ################

storeList = stores 

# TODO: fetch livestream endpoint

@app.route('/store/<storeId>/deleteStore', methods=['DELETE'])
async def delete_store(storeId):
    delattr(storeList, storeId)
    return True

@app.route('/store/<storeId>/update', methods=['PUT'])
async def update_store(storeId):
    new_store = request.get_json()
    storeList[storeId] = {key: new_store.get(key, storeList[storeId][key]) for key in storeList[storeId]}
    return storeList[storeId]
    

@app.route('/store/<storeId>/byId', methods=['GET'])
def find_store(storeId):
    return storeList[storeId]
    

@app.route('/store/create', methods=['POST'])
def create_store():
    data = request.form
    storeList['this is the test store'] = dict( #TODO: id should be from database
        capacity = data.capacity,
        customerCount = data.customerCount,
        isSafe = data.isSafe,
        temperatures = data.temperatures,
        email = data.email,
        name = data.name,
        liveStreamIds = data.liveStreamIds,
    )
    return True # TODO: return False for error when actually connected to MongoDB
    #TODO: actually put this into a database and then store the generated id from there


@app.route('/store/getAll', methods=['GET'])
def get_all_stores():
    return storeList

@app.route('/', methods=['GET'])
def testing():
    if request.method == 'GET':
        return ('Hello', 200)

if __name__ == '__main__':
    app.run(debug=True)



# TODO
# 2. integrate with the video api
# 4. change the static data to connect to MongoDB