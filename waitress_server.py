from waitress import serve
# import app
from signature_verifier.app import app

print(app)

serve(app, host='0.0.0.0', port=8080)
