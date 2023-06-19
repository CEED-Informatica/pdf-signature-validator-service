ARG DEBIAN_VERSION=slim-bullseye
ARG PYTHON_VERSION=3.11.4
ARG PORT=5555
FROM python:${PYTHON_VERSION}-${DEBIAN_VERSION}

EXPOSE ${PORT}
# ENV SERVER_PORT=${PORT}
ENV SERVER_PORT=80

RUN apt-get update && apt-get upgrade -y

#-----------------------------------------------------
# User
#-----------------------------------------------------
RUN adduser --system --no-create-home appuser
# RUN adduser -D nonroot
# RUN mkdir /home/app/ && chown -R nonroot:nonroot /home/app
# RUN mkdir -p /var/log/flask-app && touch /var/log/flask-app/flask-app.err.log && touch /var/log/flask-app/flask-app.out.log
# RUN chown -R nonroot:nonroot /var/log/flask-app
# WORKDIR /home/app
# USER nonroot

#-----------------------------------------------------
# Timezone
#-----------------------------------------------------
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#-----------------------------------------------------
# Certificates and pdfsig
#-----------------------------------------------------
# Install pdfsig and certutil
# We need to pin the poppler-utils version because we depend on its output
# It will probably work with newer versions, but we need to test it
ENV POPPLER_VERSION="20.09.0-3.1+deb11u1"
ENV PACKAGES="poppler-utils=${POPPLER_VERSION} libnss3-tools"
RUN apt-get install $PACKAGES -y

COPY certificates /certificates

# Build certificate database
COPY scripts /scripts
RUN chmod ug+x /scripts/*.sh
RUN /scripts/build_certificate_database.sh

#-----------------------------------------------------
# Flask app
#-----------------------------------------------------
COPY waitress/waitress_server.py /
COPY signature_verifier /signature_verifier

RUN pip install --upgrade pip && \
    pip install -r /signature_verifier/requirements.txt && \
    pip install waitress

USER appuser
WORKDIR /
# CMD python waitress_server.py
CMD ["python", "waitress_server.py"]
# CMD ["echo $PATH && /usr/local/bin/waitress-serve", "--port", "80", "signature_verifier:app.app"]
# CMD "waitress_serve --port 80 signature_verifier:app.app"
# CMD ["waitress-serve", "--port", "80", "signature_verifier:app.app"]
