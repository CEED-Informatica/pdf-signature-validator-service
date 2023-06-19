## Configuration
Download all the certificates in the "certificates" directory.

If a signature is failing, you can download the issuer certificate with:
- Dump the signature:
  `pdfsig -dump your_file.pdf`
  This will generate a `your_file.pdf.sig0` file.

- Get the client certificate from the signature:
  `openssl pkcs7 -print_certs -inform der -in your_file.pdf.sig0 | \
          tac | sed '/-----BEGIN/q' | tac > certificate.pem`

- Get the issuer URL from the certificate:
  `openssl x509 -noout -in certificate.pem -ext authorityInfoAccess \
    | grep "CA Issuers" | head -1 | sed 's/CA Issuers - URI://g' | sed 's/ //g'`

You can download the certificate from that URL and place it in the certificates directory.

## Certificates included
This is an informative list of the certificates included here:

AC FNMT Usuarios:                     http://www.cert.fnmt.es/certs/ACUSU.crt
ACCVCA-120 (Generalitat Valenciana):  http://www.accv.es/gestcert/ACCVCA120SHA2.cacert.crt

## Building
To build the image:
`docker build -t pdf_checker  .`


## Running the server


# NOTES
docker build -t pdf_checker .
docker run --rm --port 8080:80 --name pdf_checker -ti pdf_checker /bin/bash

docker exec -ti pdf_checker /bin/bash

curl -X POST -F "file=@/tmp/test.pdf" http://localhost:8080/verify_signature

pip install flask waitress
https://flask.palletsprojects.com/en/1.1.x/tutorial/deploy/#run-with-a-production-server

https://github.com/rochacbruno/flask-project-template.git



RUN WITH WAITRESS:

waitress-serve --port 5000 signature_verifier:app.app
python waitres_server.py
