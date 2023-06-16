from flask import Flask

app = Flask(__name__)

# import declared routes
from .route_upload import *

if __name__ == '__main__':
    app.run()
