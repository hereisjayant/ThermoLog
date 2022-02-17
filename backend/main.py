from flask import Flask, request
from flask_cors import CORS

from users import users
import firebase_admin

app = Flask(__name__)
CORS(app)

# constants
userList = users

@app.route('/user/<userId>/update', method=['PUT'])
async def update_user(userId):
    new_user = request.get_json()
    userList[userId] = {key: new_user.get(key, userList[userId][key]) for key in userList[userId]}
    return userList[userId]
    

@app.route('/user/byEmailOrId', method=['GET'])
def find_user():
    email = request.args.get('email')
    userId = request.args.get('userId')

    if email:
        for user in userList:
            if user.email == email:
                return user
    elif userId:
        for user in userList:
            if user._id == userId:
                return user

    return None
    

@app.route('/user/create', methods=['POST'])
def create_user():
    data = request.form
    userList.append(dict(
        _id = data.userId, #TODO: this should be from database
        phone = data.phone,
        photoUrl = data.photoUrl,
        lastTime = data.lastTime,
        safeTime = data.safeTime,
        email = data.email,
        name = data.name,
        notificationToken = data.notificationToken,
        storeIds = data.storeIds,
    ))
    return True # TODO: return False for error when actually connected to firebase
    #TODO: actually put this into a database and then store the generated id from there


@app.route('/user/getAll', methods=['GET'])
def get_all_users():
    return userList

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