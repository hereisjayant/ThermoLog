from flask import Flask, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

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