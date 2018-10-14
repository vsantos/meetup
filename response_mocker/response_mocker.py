from flask import Flask
import json


app = Flask(__name__)

## Error handlers

@app.errorhandler(404)
def page_not_found(e):
    return json.dumps({"status":404, "details":"Could not find requested page or resource"}), 404, {'Content-Type': 'application/json; charset=utf-8'}

@app.errorhandler(500)
def page_not_found(e):
    return json.dumps({"status":500, "details":"Something went wrong! Internal server error"}), 500, {'Content-Type': 'application/json; charset=utf-8'}

## Routing

@app.route('/', methods=['GET'])
def index():
    return json.dumps({"status":200, "details":"Welcome to home!"}), 200, {'Content-Type': 'application/json; charset=utf-8'}

@app.route('/health', methods=['GET'])
def healthcheck():
    return json.dumps({"status":200, "details":"system up and running!"}), 200, {'Content-Type': 'application/json; charset=utf-8'}

@app.route('/mock/error', methods=['GET'])
def server_error():
    return json.dumps({"status":500, "details":"Something went wrong! Internal server error"}), 500, {'Content-Type': 'application/json; charset=utf-8'}

@app.route('/mock/unauthorized', methods=['GET'])
def unauthorized():
    return json.dumps({"status":401,"details":"Sorry, but who are you?"}), 401, {'Content-Type': 'application/json; charset=utf-8'}

@app.route('/mock/forbidden', methods=['GET'])
def forbidden():
    return json.dumps({"status":403, "details":"Sorry, but you are not able to go on!"}), 403, {'Content-Type': 'application/json; charset=utf-8'}

@app.route('/mock/consult', methods=['GET'])
def consul():
    return json.dumps({"status":200, "details":"This is a successful GET"}), 200, {'Content-Type': 'application/json; charset=utf-8'}

@app.route('/mock/create', methods=['GET', 'POST'])
def create():
    return json.dumps({"status":201, "details":"User 'admin' created"}), 201, {'Content-Type': 'application/json; charset=utf-8'}

if __name__ == '__main__':
    app.run(debug=False, port=8080, host='0.0.0.0', threaded=True)