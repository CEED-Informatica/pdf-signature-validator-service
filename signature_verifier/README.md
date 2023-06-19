


## Output

You must check HTTP status. If you receive a 200, the verification could have succeed, and then you must check the API output. It can be a success output or an error output

### Success outputs

They will have success as true, and the common name of the pdf's signer:
```
{
  "success": true,
  "CN": <common name of the signer>
}
```

### Error outputs

They will have `success` as false, an error code, an error message and an optional `output` field:
```
{
  "success": false,
  "error": "NO_FILE",
  "error_message": "No file uploaded"
  "output": "EXAMPLE HERE"
}
```

The error codes are the ones defined in error_codes.py:
```python
error_codes = {
    'NO_FILE': 'No file uploaded',
    'INVALID_FILE': 'Invalid file uploaded',
}
```

It can also return error codes from `pdf_signature_validation` module:

```python
'PDFSIG_ERROR': 'Error running pdfsig',
'PDFSIG_BAD_OUTPUT': 'Error parsing pdfsig output',
'NOT_SIGNED': 'The PDF file is not signed',
'INVALID_SIGNATURE': 'The signature is not valid',
'EXPIRED_CERTIFICATE': 'The certificate has expired',
'REVOKED_CERTIFICATE': 'The certificate has been revoked',
'NOT_VALID_CERTIFICATE': 'The certificate is not valid',
```



