from flask import Flask, request, jsonify, json
from model import model
from database.SQLProvider import SQLProvider
import os

app = Flask(__name__)

with open("../data/db_config.json") as f:
    app.config['db_config'] = json.load(f)

path = os.path.join(os.path.dirname(os.getcwd()), 'database', 'sql')
sql_provider = SQLProvider(path)
app.config['provider'] = sql_provider


@app.route('/api/auth', methods=['POST'])
def authenticate():
    data = request.get_json()

    if not data or 'username' not in data or 'password' not in data:
        return jsonify({"error": "Invalid request"}), 400

    result = model(app.config['db_config'], data, app.config['provider'])

    if type(result) == tuple:
        return jsonify({"id": result[0][0], "username": result[0][1]}), 200

    if result == 2:
        return jsonify({"error": "Unauthorized"}), 401

    else:
        return jsonify({"error": "Unauthorized"}), 501


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5006, debug=True)
