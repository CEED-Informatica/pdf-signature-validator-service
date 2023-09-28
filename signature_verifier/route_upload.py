# from __main__ import app
from .app import app

from flask import request

import json
import os
import tempfile

from pdf_signature_validator import SignatureValidator, SignatureValidatorException
from .error_codes import error_codes

CERTIFICATE_DATABASE = '/certificates_database'

def JSONOK():
    data = {
        'success': True
    }
    return json.dumps(data)

def JSONError(error_code, error_message = None, output = None):
    data = {
        'success': False,
        'error': error_code,
        'error_message': error_message or error_codes[error_code],
        'output': output
    }
    data = {key: value for key, value in data.items() if value is not None}
    return json.dumps(data)

def JSONOK(signer):
    data = {
        'success': True,
        'CN': signer
    }
    return json.dumps(data)

def temporary_filename():
    temp_file = tempfile.NamedTemporaryFile()
    return temp_file.name

# -----------------------------------------------------
# Route for checking
# -----------------------------------------------------
@app.route('/verify_signature', methods=['POST'])
def upload_file():

    file = request.files.get('file', None)
    if not file:
        return JSONError('NO_FILE')

    # How to test this in curl?
    if file.filename == '':
        return JSONError('INVALID_FILE')

    download_filename = temporary_filename()
    app.logger.info(f'Saving file to {download_filename}')
    file.save(download_filename)

    validator = SignatureValidator(download_filename, CERTIFICATE_DATABASE)
    try:
        signer = validator.get_signer()
        app.logger.info(f'Valid signature: {signer}')
        os.remove(download_filename)
        return JSONOK(signer)
    except SignatureValidatorException as e:
        app.logger.error(f'Error validating signature: {e.error_code} {e.error_message} {e.output}')
        os.remove(download_filename)
        return JSONError(e.error_code, e.error_message, e.output)


