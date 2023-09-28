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
Anoter certificate from FNMT:         http://www.cert.fnmt.es/certs/ACRAIZFNMTRCM.crt
ACCVCA-120 (Generalitat Valenciana):  http://www.accv.es/gestcert/ACCVCA120SHA2.cacert.crt
DNIe Certificates:
- http://pki.policia.es/dnie/certs/AC004.crt
- http://pki.policia.es/dnie/certs/AC005.crt
- http://pki.policia.es/dnie/certs/AC006.crt


## Getting the signer certificate from a file

```bash
FILE=<your file here>

pdfsig -dump $FILE
openssl pkcs7 -inform der -text  -print_certs -in $FILE.sig0 > chain.txt
```

Search for "Authority Information Access" `in chain.txt`, there is a CA Issuers URI there.

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

## Development

TO-DO

To start a container for development:
```bash
docker run --rm -ti --name pdf_checker \
       -p 8080:80 \
       --mount type=bind,source=`pwd`/signature_verifier,target=/signature_verifier \
       pdf_checker python -m signature_verifier
```

If you want to install the module pdf_signature_validator for development.
TO-DO: modules are cached, so our local changes wont reload:

```bash
PDF_SIGNATURE_VALIDATOR=<your absolute path to pdf_signature_validator> # Which path? src/pdf_signature_validator?

docker run --rm -ti --name pdf_checker \
       -p 8080:80 \
       --mount type=bind,source=`pwd`/signature_verifier,target=/signature_verifier \
       --mount type=bind,source=$PDF_SIGNATURE_VALIDATOR,target=/usr/local/lib/python3.11/site-packages/pdf_signature_validator \
       pdf_checker python -m signature_verifier
```
