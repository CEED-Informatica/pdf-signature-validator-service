import os
PORT = os.getenv('SERVER_PORT', 80)

from waitress import serve
from signature_verifier.app import app

print(f"Starting server in port {PORT}...")

serve(app, host='0.0.0.0', port=PORT)
