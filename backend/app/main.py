from flask import Flask, request
from flask_cors import CORS

from app.users import users
from app.stores import stores
# import firebase_admin

app = Flask(__name__)
CORS(app)

# constants
userList = users

@app.route('/user/<userId>/deleteUser', methods=['DELETE'])
async def delete_user(userId):
    delattr(userList, userId)
    return True

@app.route('/user/<userId>/update', methods=['PUT'])
async def update_user(userId):
    new_user = request.get_json()
    userList[userId] = {key: new_user.get(key, userList[userId][key]) for key in userList[userId]}
    return userList[userId]
    

@app.route('/user/byEmailOrId', methods=['GET'])
def find_user():
    email = request.args.get('email')
    userId = request.args.get('userId')

    if email:
        for user in userList:
            if user.email == email:
                return user
    elif userId:
        return userList[userId]

    return None
    

@app.route('/user/create', methods=['POST'])
def create_user():
    data = request.form
    userList['this is the test account'] = dict( #TODO: id should be from database
        phone = data.phone,
        photoUrl = data.photoUrl,
        lastTime = data.lastTime,
        safeTime = data.safeTime,
        email = data.email,
        name = data.name,
        notificationToken = data.notificationToken,
        storeIds = data.storeIds,
    )
    return True # TODO: return False for error when actually connected to firebase
    #TODO: actually put this into a database and then store the generated id from there


@app.route('/user/getAll', methods=['GET'])
def get_all_users():
    return userList

storeList = stores 

@app.route('/user/<userId>/deleteUser', methods=['DELETE'])
async def delete_user(userId):
    delattr(userList, userId)
    return True

@app.route('/user/<userId>/update', methods=['PUT'])
async def update_user(userId):
    new_user = request.get_json()
    userList[userId] = {key: new_user.get(key, userList[userId][key]) for key in userList[userId]}
    return userList[userId]
    

@app.route('/store/<storeId>/byId', methods=['GET'])
def find_store(storeId):
    return storeList[storeId]
    

@app.route('/store/create', methods=['POST'])
def create_store():
    data = request.form
    userList['this is the test store'] = dict( #TODO: id should be from database
        capacity = data.capacity,
        customerCount = data.customerCount,
        isSafe = data.isSafe,
        temperatures = data.temperatures,
        email = data.email,
        name = data.name,
        liveStreamIds = data.liveStreamIds,
    )
    return True # TODO: return False for error when actually connected to firebase
    #TODO: actually put this into a database and then store the generated id from there


@app.route('/store/getAll', methods=['GET'])
def get_all_stores():
    return storeList

@app.route('/', methods=['GET'])
def testing():
    if request.method == 'GET':
        return 'Hello'

if __name__ == '__main__':
    app.run(debug=True)



# Todo
# 1. finish the basic info endpoints and queries
# 3. deploying on heroku
# 2. integrate with the video api
# 4. change the static data to connect to firebase