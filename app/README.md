


## Output

You must check HTTP status. If you receive a 200, the verification could have succeed, and then you must check the API output. It can be a success output or an error output

### Success outputs

They will have success as true, and ¿THE ONES WHO SIGNED THE PDF?
```
{
  "success": true
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


# WORKING NOTES

pyenv virtualenv 3.11.1 validacion-certificados
pip install flask

OK:
curl -X POST -F "file=@/path/to/file" http://localhost:5000/verify_signature

"No file uploaded"
curl -X POST -F "filee=@./banana.txt" http://localhost:5000/verify_signature


docker run --rm --name pdf_checker -ti pdf_checker /bin/bash

docker cp




