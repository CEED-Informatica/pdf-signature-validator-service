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

Start the container with:
```bash
docker run --rm -p 8080:80 -ti pdf_checker
```

Invoke the endpoint with:
```bash
FILE=<your pdf file>
curl -X POST -F "file=@$FILE" http://localhost:8080/verify_signature
```

## Development?

To start a container for development:
```bash
docker run --rm -ti --name pdf_checker \
       -p 8080:80 \
       --mount type=bind,source=`pwd`/signature_verifier,target=/signature_verifier \
       pdf_checker python -m signature_verifier
```

THIS DOESNT WORK: WRITE PERMISSION ISSUES WHEN BUILDING?
If you want to install the module pdf_signature_validator for development:
```bash
PDF_SIGNATURE_VALIDATOR=<your absolute path to pdf_signature_validator>
docker run --rm -ti --name pdf_checker \
       -p 8080:80 \
       --mount type=bind,source=`pwd`/signature_verifier,target=/signature_verifier \
       --mount type=bind,source=$PDF_SIGNATURE_VALIDATOR,target=/pdf_signature_validator \
       pdf_checker python -m signature_verifier
```

# NOTES
docker build -t pdf_checker .
docker run --rm --port 8080:80 --name pdf_checker -ti pdf_checker /bin/bash

docker exec -ti pdf_checker /bin/bash




PDF_SIGNATURE_VALIDATOR=/home/alvaro/Software/validacion-certificados-2/pdf-signature-validator

