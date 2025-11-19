from flask import Flask, jsonify

app = Flask(__name__)


@app.route('/')
def hello():
    return " Hello from Flask inside Docker! "


@app.route('/data')
def data():
    return jsonify(message="This is sample data", items=[1,2,3])

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
    
