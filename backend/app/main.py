from flask import Flask, request
from flask_cors import CORS

from app.users import users
from app.stores import stores

app = Flask(__name__)
CORS(app)

############## user endpoints ################
userList = users


@app.route('/user/<userId>/deleteUser', methods=['DELETE'])
async def delete_user(userId):
    delattr(userList, userId)
    return ('', 200)


@app.route('/user/<userId>/update', methods=['PUT'])
async def update_user(userId):
    new_user = request.get_json()
    userList[userId] = {key: new_user.get(
        key, userList[userId][key]) for key in userList[userId]}
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
        return ("invalid query", 400)  # TODO add status code
    return ("DNE", 204)


@app.route('/user/create', methods=['GET', 'POST'])
def create_user():
    from datetime import datetime
    if request.method == 'POST':
        data = request.form.to_dict()
        print(type(data), data)

        epoch = datetime.utcfromtimestamp(0)
        time = (datetime.now() - epoch).total_seconds() * 1000.0

        data["lastTime"] = data["safeTime"] = time
        userList['userId1'] = data
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
        # TODO: return False for error when actually connected to MongoDB
        return ('user created', 200)
    # TODO: actually put this into a database and then store the generated id from there


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
    storeList[storeId] = {key: new_store.get(
        key, storeList[storeId][key]) for key in storeList[storeId]}
    return (storeList[storeId], 200)


@app.route('/store/<storeId>/byId', methods=['GET'])
def find_store(storeId):
    return (storeList[storeId], 200)


@app.route('/store/create', methods=['GET', 'POST'])
def create_store():
    data = request.form.to_dict()
    data["isSafe"] = True
    storeList['this is the test store'] = dict(  # TODO: id should be from database
        capacity=data["capacity"],
        customerCount=data["customerCount"],
        isSafe=data["isSafe"],
        temperatures=data["temperatures"],
        name=data["name"],
        liveStreamIds=data["liveStreamIds"],
    )
    # TODO: return False for error when actually connected to MongoDB
    return ('created', 200)
    # TODO: actually put this into a database and then store the generated id from there


@app.route('/store/getAll', methods=['GET'])
def get_all_stores():
    return (storeList, 200)


@app.route('/', methods=['GET'])
def testing():
    if request.method == 'GET':
        return ('Hello, Guy Lemieux', 200)


if __name__ == '__main__':
    app.run(debug=True)


# TODO
# 2. integrate with the video api
# 4. change the static data to connect to MongoDB
