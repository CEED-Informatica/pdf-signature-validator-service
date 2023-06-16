from flask import Flask

app = Flask(__name__)

# import declared routes
import route_upload

if __name__ == '__main__':
    app.run()
