#! /usr/bin/env bash

DATABASE=/certificates_database
CERTIFICATES_DIR=/certificates

# Create empty certificates database
mkdir $DATABASE
certutil -N -d $DATABASE --empty-password

# Adds certificates
for CERT_FILE in $CERTIFICATES_DIR/*; do
  CERT_NAME=$(basename $CERT_FILE)
  certutil -A -n $CERT_NAME -i $CERT_FILE -t ",C" -d $DATABASE
done

# Certificates are not needed anymore
rm -rf $CERTIFICATES_DIR
