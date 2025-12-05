from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    return "coucou 😎 v2"

if __name__ == "__main__":
    # important: host=0.0.0.0 pour que Docker expose bien le serveur
    app.run(host="0.0.0.0", port=5045)