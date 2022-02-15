from flask import Flask, request
from flask_cors import CORS

from users import users

app = Flask(__name__)
CORS(app)

# constants
userList = users

@app.route('/user/byEmailOrId', method=['GET'])
def find_user():
    email = request.args.get('email')
    if email:
        for user in userList:
            if user.email == email:
                return user
        return null #TODO
    

@app.route('/user/create', methods=['POST'])
def create_user():
    data = request.form
    userList.append(dict(
        _id = data.userId,
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