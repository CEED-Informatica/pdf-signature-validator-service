import sys
from waitress import serve
from signature_verifier.app import app

PORT=sys.argv[1]
print(f"Starting server in port {PORT}...")

serve(app, host='0.0.0.0', port=PORT)
